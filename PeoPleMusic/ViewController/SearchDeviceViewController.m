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
#import <SystemConfiguration/CaptiveNetwork.h>

#define kbtnLinkDevicekHeight   (230*kWindowHeight/667)
@interface SearchDeviceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *deviceVodBoxArray;

@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSString *macIp;

@property (nonatomic, strong)  UIView *footView ;

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
    
//    NSString *ssid = @"Not Found";
//    NSString *macIp = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            self.ssid = [dict valueForKey:@"SSID"];
            self.macIp = [dict valueForKey:@"BSSID"];
           
            self.macIp = [self.macIp stringByReplacingOccurrencesOfString:@":" withString:@""];

        }
    }
    
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 170)];
    
    UIButton *btnLinkDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLinkDevice.frame = CGRectMake((kWindowWidth - kbtnLinkDevicekHeight)/2, 15, kbtnLinkDevicekHeight, 44);
    [btnLinkDevice setTitle:@"连接音响" forState:UIControlStateNormal];
     btnLinkDevice.backgroundColor = YYColorFromRGB(0xFBA436);
    
    [btnLinkDevice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnLinkDevice  setBackgroundImage:[UIImage imageNamed:@"button_0_0_0_2"] forState:UIControlStateNormal];
    [btnLinkDevice  setBackgroundImage:[UIImage imageNamed:@"button_0_0_0_2"] forState:UIControlStateHighlighted];

    btnLinkDevice.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLinkDevice addTarget:self action:@selector(btnLinkDeviceAction) forControlEvents:UIControlEventTouchUpInside];
    btnLinkDevice.layer.cornerRadius = 5;
    btnLinkDevice.layer.masksToBounds = YES;
    [self.footView addSubview:btnLinkDevice];
    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void) btnLinkDeviceAction{
    
   
    NSString *ip = nil;
    
   
    for (int i = 0; i < self.deviceVodBoxArray.count; i++) {
        DeviceVodBoxModel *model = self.deviceVodBoxArray[i];
        if (model.wifiName == self.ssid) {
            ip = model.ip;
        }
    }
    
    if (!ip) {
        NSString *str = [NSString stringWithFormat:@"您的手机连接的WIFI是%@,请更换店内wifi再连接!",self.ssid];
        [[[UIAlertView alloc] initWithTitle:@"当前连接WifI"
                                    message:str
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"知道了", nil] show];
    }else{
      
            if ([[YMTCPClient share] connectServer:ip port:SOCKET_PORT2]) {
//                [self getDeviceInfo];
                [self showMessageHUD:@"连接音响成功" withTimeInterval:2.0];
            }

    }

}

//- (void)getDeviceInfo{
//    [[YMTCPClient share] networkSendDeviceForRegister:^(NSInteger result, NSDictionary *dict, NSError *err) {
//        if (result == 0) {
//            NSDictionary *tempDict  = [dict objectForKey:@"deviceInfor"];
//            DeviceInfor *deviceInfo =  [DeviceInfor objectWithKeyValues:tempDict];
//          
//            [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK withData:deviceInfo];
//            [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];
//            
//            dispatch_main_async_safeThread(^{
//               [self showMessageHUD:@"连接音响成功" withTimeInterval:2.0];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//                
//            });
//            
//            
//        }
//    }];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"在线设备";
    // 8783f824f672b089703e7dd5b5552d27
 
    
    [[YMLocationManager shareManager] startLocotion:^(CGFloat latitude, CGFloat longitude, NSError *error) {
        if (!error) {
//            latitude = 114.01666;
//            longitude = 22.538146;
            
//            latitude = 151.50998;
//            longitude = -0.1337;

            
            KyoLog(@"latitude: %f longitude: %f",latitude,longitude);
            [[[UIAlertView alloc] initWithTitle:@"获取高德当前的经纬度"
                                        message:[NSString stringWithFormat:@"latitude: %f longitude: %f",latitude,longitude]
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"知道了", nil] show];
           [self networkGetDeviceList:latitude longitude:longitude];
        }else{
            [self showMessageHUD:@"亲，请在设置中开启允许定位!" withTimeInterval:3.0f];
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
        
        if (self.deviceVodBoxArray.count > 0) {
//            self.tableView.tableFooterView = self.footView;
        }else{
            
            ;
            
            [self showMessageHUD:[NSString stringWithFormat:@"亲，未在WIFI:%@搜到店内有音响开启!",self.ssid] withTimeInterval:3.0f];
        }
        [self.tableView reloadData];

    }];
}
#pragma mark -------------------
#pragma mark - Methods

#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceVodBoxArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchDeviceCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchDeviceCell"];
    cell.indexPath = indexPath;
  
    DeviceVodBoxModel *model = self.deviceVodBoxArray[indexPath.row];
    cell.lblName.text = model.name;
    cell.lblAddress.text = model.address;
    if (model.wifiName == self.ssid ) {
        cell.imgSelect.hidden = NO;
    }else{
        cell.imgSelect.hidden = YES;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([YMTCPClient share].isConnect) {
        [self showMessageHUD:@"亲，您已经连接了店内音响了!" withTimeInterval:kShowMessageTime];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else{
         DeviceVodBoxModel *model = self.deviceVodBoxArray[indexPath.row];
        KyoLog(@"%@",model.ip);
        
        if ([[YMTCPClient share] connectServer:model.ip port:SOCKET_PORT2]) {
            [UserInfo sharedUserInfo].deviceVodBoxModel = model;
             [self showMessageHUD:@"连接设备成功!" withTimeInterval:kShowMessageTime];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            if ([[YMTCPClient share] connectServer:model.ip port:SOCKET_PORT1]) {
                [self showMessageHUD:@"连接设备成功!" withTimeInterval:kShowMessageTime];
                [UserInfo sharedUserInfo].deviceVodBoxModel = model;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showMessageHUD:@"连接设备失败，请连接其他设备!" withTimeInterval:kShowMessageTime];
            }
        };
    }
    
}
#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC

@end
