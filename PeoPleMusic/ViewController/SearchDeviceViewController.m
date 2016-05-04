//
//  SearchDeviceViewController.m
//  PeoPleMusic
//
//  Created by long on 5/4/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "DeviceVodBoxModel.h"

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
    
    [self networkGetDeviceList];
}

#pragma mark -------------------
#pragma mark - CycLife

#pragma mark --------------------
#pragma mark - Settings, Gettings

#pragma mark --------------------
#pragma mark - Events
- (void)networkGetDeviceList{
    
    NSString *urlString = @"http://115.28.191.217:8080/vodbox/mobinf/terminalAction!getNearbyTerminal.do";
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"viceceel"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    DeviceVodBoxModel *model = self.deviceVodBoxArray[indexPath.row];
    cell.textLabel.text = model.ip;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    SongInforModel *model = self.songList[indexPath.row];
//    if ([model.userInfor.userId isEqualToString:[UIDevice getUUID]]) {
//        return model.isExtend ? KPlayerCellHeight + 38 : KPlayerCellHeight;
//    }
//    return KPlayerCellHeight;
//}
#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC

@end
