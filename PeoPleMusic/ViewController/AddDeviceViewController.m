//
//  AddDeviceViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/4/2.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "YMBonjourHelp.h"

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
 
//    if ([YMTCPClient share].isConnect) {
//          DeviceInfor *deviceInfo = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK];
//        if (!_arrDevices) {
//            _arrDevices = [NSMutableArray array];
//        }
//        [_arrDevices removeAllObjects];
//        [_arrDevices addObject:deviceInfo];
//    }
    
}


- (void)setupData{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvDidBonjour:) name:YNotificationName_DIDSUCESSFINDSERVICE object:nil];  //连接音响通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvDeviceInfo:) name:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];  //连接音响通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDiDConnect:) name:YNotificationName_SOCKETDIDCONNECT object:nil];  //断开连接
}

- (void)dealloc{
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
    
    return self.arrDevices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AddDeviceCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDeviceCell"];
    cell.indexPath = indexPath;
    DeviceInfor *deviceInfo = [_arrDevices objectAtIndex:indexPath.row];
    cell.lblDevice.text = deviceInfo.name;
    cell.lblWiFiName.text = deviceInfo.wifiName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
}



- (BOOL)searchDevice{
    
    
    self.lblScanText.hidden = NO;
    self.lblScanText.text = @"在自动扫描当前网络设备...";
    for (int i = 0; i<=255; i ++) {
        
        for (int j = 0; j <= 255; j++) {
            
            NSString *ip = [NSString stringWithFormat:@"192.168.%d.%d",i,j];
            KyoLog(@"搜到ip:  %@",ip);
            if ([[KyoUtil rootViewController] connectSeriver:ip]){
                
                KyoLog(@"搜到店音响 %@",ip);
                return YES;
            }
        }
    }
    
    return NO;
    
}

- (IBAction)btnUpdateTouchInside:(id)sender {
    [self startAnimation];
    
    if([KyoUtil rootViewController].currentNetworkState != AFNetworkReachabilityStatusReachableViaWiFi){
        
        [self showMessageHUD:@"亲，你还未连接店内WIFI哦～" withTimeInterval:kShowMessageTime];
        return;
    }
    if (![YMTCPClient share].isConnect) {
        [self.tableView reloadData];
     
        if(![self searchDevice]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isStopBtnUpdateAnimation = YES;
                self.lblScanText.text = @"在未扫描到设备，请切换其他网络设备重试";
                
            });
        }
        
      
    }

}

- (IBAction)btnScanTouchInside:(id)sender {
    self.isStopBtnUpdateAnimation = YES;
}
- (IBAction)btnBackTouchInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --------------------
#pragma mark - NSNotification

////连接音响通知
//- (void)recvDidBonjour:(NSNotification *)noti{
//    
//   
//    if([[YMTCPClient share] connectServer:[YMBonjourHelp shareInstance].deviceIp port:SOCKET_PORT2]){
//        KyoLog(@"连接成功。。");
//        [[YMTCPClient share] networkSendDeviceForRegister:^(NSInteger result, NSDictionary *dict, NSError *err) {
//            if (result == 0) {
//                NSDictionary *tempDict  = [dict objectForKey:@"deviceInfor"];
//                DeviceInfor *deviceInfo =  [DeviceInfor objectWithKeyValues:tempDict];
//                [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK withData:deviceInfo];
//                [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];
//                if (!_arrDevices) {
//                    _arrDevices = [NSMutableArray array];
//                }
//                [_arrDevices removeAllObjects];
//                [_arrDevices addObject:deviceInfo];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.tableView reloadData];
//                    self.lblScanText.hidden = YES;
//                    self.isStopBtnUpdateAnimation = YES;
//                });
//                
//            }
//        }];
//    }else{
//         [_arrDevices removeAllObjects];
//    }
//}
- (void)recvDeviceInfo:(NSNotification *)noti{
    DeviceInfor *deviceInfo = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK];
    if (!_arrDevices) {
        _arrDevices = [NSMutableArray array];
    }
    [_arrDevices removeAllObjects];
    [_arrDevices addObject:deviceInfo];
    [self.tableView reloadData];
    self.lblScanText.hidden = YES;
    self.isStopBtnUpdateAnimation = YES;
}
- (void)receiveDiDConnect:(NSNotification *)noti{
    [[YMTCPClient share] networkSendDeviceForRegister:^(NSInteger result, NSDictionary *dict, NSError *err) {
        if (result == 0) {
            NSDictionary *tempDict  = [dict objectForKey:@"deviceInfor"];
            DeviceInfor *deviceInfo =  [DeviceInfor objectWithKeyValues:tempDict];
            [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK withData:deviceInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];
            if (!_arrDevices) {
                _arrDevices = [NSMutableArray array];
            }
            [_arrDevices removeAllObjects];
            [_arrDevices addObject:deviceInfo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                self.lblScanText.hidden = YES;
                self.isStopBtnUpdateAnimation = YES;
            });
            
        }
    }];
}


@end
