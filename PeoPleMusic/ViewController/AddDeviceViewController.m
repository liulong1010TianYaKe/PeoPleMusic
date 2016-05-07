//
//  AddDeviceViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/4/2.
//  Copyright © 2016年 zhuniT All rights reserved.
//

#import "AddDeviceViewController.h"
#import "DeviceVodBoxModel.h"
#import "YMLocationManager.h"
// 正在自动扫描当前网络设备...
// 未扫描到设备，请切换其他网络设备重试

@interface AddDeviceCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblDevice;

@property (weak, nonatomic) IBOutlet UILabel *lblWiFiName;


@end
@implementation AddDeviceCell



@end

@interface AddDeviceViewController (){
    double  angle;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgCycle;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
- (IBAction)btnUpdateTouchInside:(id)sender;
- (IBAction)btnScanTouchInside:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblScanText;

@property (nonatomic, assign) BOOL isStopBtnUpdateAnimation;

@property (nonatomic, strong) NSArray *deviceVodBoxArray;

@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSString *macIp;

- (IBAction)btnBackTouchInside:(id)sender;

@property (nonatomic,strong) NSMutableArray *arrDevices;
@end

@implementation AddDeviceViewController


+ (AddDeviceViewController *)createAddDeviceViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    AddDeviceViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([AddDeviceViewController class])];
    return controller;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    [UIApplication sharedApplication].
//    self.hidesBottomBarWhenPushed = YES;
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imgCycle.layer.cornerRadius = self.imgCycle.bounds.size.width/2;
    self.imgCycle.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
 
    [[YMLocationManager shareManager] startLocotion:^(CGFloat latitude, CGFloat longitude, NSError *error) {
        if (!error) {
            
            
            KyoLog(@"latitude: %f longitude: %f",latitude,longitude);
            [self networkGetDeviceList:latitude longitude:longitude];
        }else{
            [self showMessageHUD:@"亲，请在设置中开启允许定位!" withTimeInterval:3.0f];
        }
        
    }];
    
}


- (void)setupData{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)setIsStopBtnUpdateAnimation:(BOOL)isStopBtnUpdateAnimation{
    _isStopBtnUpdateAnimation = isStopBtnUpdateAnimation;
}
-(void)startAnimation
{
    _isStopBtnUpdateAnimation = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.btnUpdate.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}
-(void)endAnimation
{
    angle += 5;
    if (!_isStopBtnUpdateAnimation) {
        [self startAnimation];
    }
    
}
#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.deviceVodBoxArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AddDeviceCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDeviceCell"];
    cell.indexPath = indexPath;
    
    DeviceVodBoxModel *model = self.deviceVodBoxArray[indexPath.row];
    cell.lblDevice.text = model.name;
    cell.lblWiFiName.text = model.address;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
 
    
    if ([YMTCPClient share].isConnect) {
        [self showMessageHUD:@"亲，您已经连接了店内音响了!" withTimeInterval:kShowMessageTime];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
          
        });
        
    }else{
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
    

}



- (IBAction)btnUpdateTouchInside:(id)sender {
    [self startAnimation];
    
}

- (IBAction)btnScanTouchInside:(id)sender {
    self.isStopBtnUpdateAnimation = YES;
}
- (IBAction)btnBackTouchInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --------------------
#pragma mark - NSNotification

- (void)networkGetDeviceList:(CGFloat)latitude longitude:( CGFloat )longitude{
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://115.28.191.217:8080/vodbox/mobinf/terminalAction!getNearbyTerminal.do?longitude=%f&latitude=%f",latitude,longitude];
    
    [NetworkSessionHelp postNetwork:urlString completionBlock:^(NSDictionary *dict, NSInteger result) {
        self.deviceVodBoxArray = [DeviceVodBoxModel objectArrayWithKeyValuesArray:dict[@"info"]];
    } errorBlock:^(NSError *error) {
        
    } finishedBlock:^(NSError *error) {
        
        if (self.deviceVodBoxArray.count > 0) {
            
            NSMutableArray *arrDevs = [NSMutableArray array];
            for (DeviceVodBoxModel *model in self.deviceVodBoxArray) {
                
                if ([model.wifiName isEqualToString:[NSString getWiFiName]] && [model.wifiMac isEqualToString:[NSString getWIFIBSSID]]) {
                    [UserInfo sharedUserInfo].deviceVodBoxModel = model;
                    model.isNeedDevice = YES;
                    
                    [arrDevs addObject:model];
                }
            }
            [UserInfo sharedUserInfo].deviceVodBoxArr = [NSArray arrayWithArray:arrDevs];
        }else{
            [self showMessageHUD:[NSString stringWithFormat:@"亲，未在WIFI:%@搜到店内有音响开启!",self.ssid] withTimeInterval:3.0f];
        }
        [self.tableView reloadData];
        
    }];
}

@end
