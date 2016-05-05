//
//  SearchDeviceViewController.m
//  PeoPleMusic
//
//  Created by long on 5/4/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "DeviceVodBoxModel.h"
#import "YMLocationManager.h"
#import "SearchDeviceCell.h"
#import "YMTCPClient.h"

@interface SearchDeviceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *deviceVodBoxArray;

@end

@implementation SearchDeviceViewController


+ (SearchDeviceViewController *)createSearchDeviceViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Player" bundle:nil];
    SearchDeviceViewController  *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SearchDeviceViewController class])];
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"在线设备";
    // 8783f824f672b089703e7dd5b5552d27
 
    
    [[YMLocationManager shareManager] startLocotion:^(CGFloat latitude, CGFloat longitude, NSError *error) {
        if (!error) {
            latitude = 114.01666;
            longitude = 22.538146;
            KyoLog(@"latitude: %f longitude: %f",latitude,longitude);
           [self networkGetDeviceList:latitude longitude:longitude];
        }
        
    }];
}

#pragma mark -------------------
#pragma mark - CycLife

#pragma mark --------------------
#pragma mark - Settings, Gettings

#pragma mark --------------------
#pragma mark - Events
- (void)networkGetDeviceList:(CGFloat)latitude longitude:( CGFloat )longitude{
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://115.28.191.217:8080/vodbox/mobinf/terminalAction!getNearbyTerminal.do?longitude=%f&latitude=%f",latitude,longitude];
    
    
//    NSString *urlString = @"http://115.28.191.217:8080/vodbox/mobinf/terminalMusicAction!getTerminalMusicList.do?terminalId=83";
//     NSString *urlString = @"http://115.28.191.217:8080/vodbox/mobinf/terminalAction!getNearbyTerminal.do";
    [NetworkSessionHelp postNetwork:urlString completionBlock:^(NSDictionary *dict, NSInteger result) {
       self.deviceVodBoxArray = [DeviceVodBoxModel objectArrayWithKeyValuesArray:dict[@"info"]];
    } errorBlock:^(NSError *error) {
        
    } finishedBlock:^(NSError *error) {
        
        [self.tableView reloadData];

    }];
}
#pragma mark -------------------
#pragma mark - Methods

#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceVodBoxArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchDeviceCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchDeviceCell"];
    cell.indexPath = indexPath;
  
    DeviceVodBoxModel *model = self.deviceVodBoxArray[indexPath.row];
    cell.lblName.text = model.name;
    cell.lblAddress.text = model.address;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     DeviceVodBoxModel *model = self.deviceVodBoxArray[indexPath.row];
    KyoLog(@"%@",model.ip);
    
    if ([[YMTCPClient share] connectServer:model.ip port:SOCKET_PORT2]) {
         [self showMessageHUD:@"连接设备成功!" withTimeInterval:kShowMessageTime];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else{
        if ([[YMTCPClient share] connectServer:model.ip port:SOCKET_PORT1]) {
            [self showMessageHUD:@"连接设备成功!" withTimeInterval:kShowMessageTime];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showMessageHUD:@"连接设备失败，请连接其他设备!" withTimeInterval:kShowMessageTime];
        }
    };
    
}
#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC

@end
