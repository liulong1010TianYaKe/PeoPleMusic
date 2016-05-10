//
//  RootViewController.m
//  YWCat
//
//  Created by Kyo on 23/3/15.
//  Copyright (c) 2015 zhuniT All rights reserved.
//

#import "RootViewController.h"
#import "UIDevice-Hardware.h"
#import "NewfeatureViewController.h"

#import "KyoTopWindow.h"
#import "YMBonjourHelp.h"
#import "YMLocationManager.h"
#import "NSString+IPAddress.h"


@interface RootViewController()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;



@property (nonatomic, strong) UIAlertView *networkChangeAlertView;
//@property (nonatomic, assign) AFNetworkReachabilityStatus lasttNetworkState; //之前网络状态
@property (nonatomic, strong) NSMutableArray *arrayCart;


- (void)setupTabBarViewController;

- (void)checkShowNewFeatureViewController;  //检测是否需要显示新特性viewcontroller


@end

@implementation RootViewController

-(NSMutableArray *)arrayCart
{
    if (_arrayCart == nil) {
        _arrayCart = [NSMutableArray array];
    }
    return _arrayCart;
}
#pragma mark ------------------------
#pragma mark - CycLife

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES]; //设置白色状态栏
     [self startMonitoringNetworkState]; //开始监听网络状态
    [self setupTabBarViewController];   //设置tabbarviewcontroller
//    [self checkShowNewFeatureViewController];   //检测是否需要显示新特性viewcontroller
    
    //添加手势
    [KyoUtil addTagGesture:self performSelector:@selector(clearAllTextField:) withView:self.view];
    
    //判断是否需要自动登录

    self.clientTcp = [YMTCPClient share];
    
    [self searchDeviceSevice];
 
//    [self startSearchSerive]; // 开始搜索服务

//    if ([self.clientTcp connectServer:@"192.168.1.100" port:SOCKET_PORT2]) {
//                    [self getDeviceInfo];
//        }

    //延迟2秒后添加window用于点击滑动到top
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KyoTopWindow show];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvDidBonjour:) name:YNotificationName_DIDSUCESSFINDSERVICE object:nil];  //连接音响通知
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startSearchSerive{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YMBonjourHelp shareInstance] startSearch];
        
    });
}

- (void)searchDeviceSevice{
    [[YMLocationManager shareManager] startLocotion:^(CGFloat latitude, CGFloat longitude, NSError *error) {
        if (!error) {
       
            [self networkGetDeviceList:latitude longitude:longitude];
        }else{
            [self showMessageHUD:@"亲，请在设置中开启允许定位!" withTimeInterval:3.0f];
        }
        
    }];
}

- (void)networkGetDeviceList:(CGFloat)latitude longitude:( CGFloat )longitude{
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://115.28.191.217:8080/vodbox/mobinf/terminalAction!getNearbyTerminal.do?longitude=%f&latitude=%f",latitude,longitude];

    [NetworkSessionHelp postNetwork:urlString completionBlock:^(NSDictionary *dict, NSInteger result) {
        if (result == 0) {
             NSArray *arr = [DeviceVodBoxModel objectArrayWithKeyValuesArray:dict[@"info"]];
            
            
            NSMutableArray *arrDevs = [NSMutableArray array];
            for (DeviceVodBoxModel *model in arr) {
                
                if ([model.wifiName isEqualToString:[NSString getWiFiName]] && [model.wifiMac isEqualToString:[NSString getWIFIBSSID]]) {
                    [[YMTCPClient share] connnectServerIP:model.ip];
                    [arrDevs addObject:model];
                }
            }

        }
       
       
    } errorBlock:^(NSError *error) {
        
    } finishedBlock:^(NSError *error) {
        
    }];
}
- (BOOL)connectSeriver:(NSString *)serveIp{
    
 
    if ([self.clientTcp connectServer:serveIp port:SOCKET_PORT2]) {
        [self getDeviceInfo];
        [[YMBonjourHelp shareInstance] stopSearch];
        return YES;
    }else{
        if([self.clientTcp connectServer:serveIp port:SOCKET_PORT1]){
            [self getDeviceInfo];
            [[YMBonjourHelp shareInstance] stopSearch];
            return YES;
        }
    }
    
    return NO;
}
- (void)startConnectSongServer{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([YMBonjourHelp shareInstance].isAirSuccess) {
            NSString *ips =  [YMBonjourHelp shareInstance].deviceIp;
            NSLog(@"%@  %ld", [YMBonjourHelp shareInstance].deviceIp,[YMBonjourHelp shareInstance].port);
            
            if ([[YMTCPClient share] connectServer:ips port:SOCKET_PORT2]) {
                [self getDeviceInfo];
                [[YMBonjourHelp shareInstance] stopSearch];
            }
        }else{
//            
//            if ([[YMTCPClient share] connectServer:@"192.168.1.100" port:SOCKET_PORT2]) {
//                [self getDeviceInfo];
//            }
        }
        
    });
}

- (void)getDeviceInfo{
    [[YMTCPClient share] networkSendDeviceForRegister:^(NSInteger result, NSDictionary *dict, NSError *err) {
        if (result == 0) {
            NSDictionary *tempDict  = [dict objectForKey:@"deviceInfor"];
            DeviceInfor *deviceInfo =  [DeviceInfor objectWithKeyValues:tempDict];
            [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK withData:deviceInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];
            
        }
    }];

}
#pragma mark ------------------------
#pragma mark - Methods

- (void)setupTabBarViewController
{
    self.tabBarViewController = [[JMTabBarViewController alloc] init];
  

    
    [self addChildViewController:self.tabBarViewController];
    [self.contentView addSubview:self.tabBarViewController.view];
    
     self.tabBarViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *lcLeft = [NSLayoutConstraint constraintWithItem: self.tabBarViewController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]; //左
    NSLayoutConstraint *lcRight = [NSLayoutConstraint constraintWithItem: self.tabBarViewController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];   //右
    NSLayoutConstraint *lcTop = [NSLayoutConstraint constraintWithItem: self.tabBarViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]; //上
    NSLayoutConstraint *lcBottom = [NSLayoutConstraint constraintWithItem: self.tabBarViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]; //下
    [self.contentView addConstraints:@[lcLeft, lcRight, lcTop, lcBottom]];
    [self.contentView layoutIfNeeded];

    
   
     LibrayMusicViewController  *libMusicVC = [LibrayMusicViewController createLibrayMusicViewController];

    [self.tabBarViewController addOneChildVc:libMusicVC title:@"曲库" imageName:@"icon_indicator_music_off" selectedImageName:@"icon_indicator_music_on"];
    
    
     PlayerViewController *playerVC = [PlayerViewController createPlayerViewController];
    [self.tabBarViewController addOneChildVc:playerVC title:@"点播" imageName:@"icon_indicator_dianbo_off" selectedImageName:@"icon_indicator_dianbo_on"];
    
    UserCenterViewController *userCenterVC = [UserCenterViewController createUserCenterViewController];
    [self.tabBarViewController addOneChildVc:userCenterVC title:@"个人中心" imageName:@"icon_indicator_personal_off" selectedImageName:@"icon_indicator_personal_on"];
 
    [self.tabBarViewController addCustomTabBar];
    self.tabBarViewController.lastSelectedViewContoller = playerVC;
    self.tabBarViewController.selectedIndex = 1;    //默认为产品页
}



//检测是否需要显示新特性viewcontroller
- (void)checkShowNewFeatureViewController
{
//    NSString *cacheVersion = [[KyoDataCache shared] readTempDataWithFolderName:kUserDefaultKey_CFBundleShortVersionString];
    NSString *cacheVersion = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:kUserDefaultKey_CFBundleShortVersionString];
    
    NSString *currentVersion = [KyoUtil getAppstoreVersion];
    if (!cacheVersion || ![cacheVersion isEqualToString:currentVersion]) {  //如果没有缓存版本或缓存的版本和当前版本不一样，显示新特性
//        [[KyoDataCache shared] deleteAllTempData];  //由于是新版本，删除以前的所有缓存
        [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] deleteAllData];
        NewfeatureViewController *newFeatureViewController = [[NewfeatureViewController alloc] init];
        newFeatureViewController.newfeatureType = NewfeatureTypeFromeWelcom;
        [self addChildViewController:newFeatureViewController];
        [self.contentView addSubview:newFeatureViewController.view];
        newFeatureViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *dict = @{@"newfeatureView": newFeatureViewController.view};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[newfeatureView]-(==0)-|" options:0 metrics:nil views:dict]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[newfeatureView]-(==0)-|" options:0 metrics:nil views:dict]];
        
        [self.contentView layoutIfNeeded];
    }
}




- (void)clearAllTextField:(id)targer
{
    //判断是否是点击到了textfield右边的clear按钮，如果是，则跳出
    UIView *view;
    if ([targer isKindOfClass:[UIGestureRecognizer class]]) {  //如果是单击手势触发的
        view = [((UIGestureRecognizer *)targer) view];
        
        //验证是否是单击了textfield的右边清空按钮触发的，如果是，返回。
        CGPoint point = [((UIGestureRecognizer *)targer) locationOfTouch:0 inView:view];    //得到手势视图的单击坐标
        UIView *subView = [view hitTest:point withEvent:nil];   //得到单击位置的控件
        if (subView) {  //如果单击位置有控件
            
            //如果单击位置的控件有父视图，且父视图是textField，说明是单击了textfield右边的清空按钮触发的，返回
            if (subView.superview && [subView.superview isKindOfClass:[UITextField class]]) {
                return;
            }
        }
        
    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


- (void)gotoLibrayMusicViewController{
    [[KyoUtil getCurrentNavigationViewController] popToRootViewControllerAnimated:YES];
    [KyoUtil rootViewController].tabBarViewController.selectedIndex = 0;
}




//开始监听网络状态
- (void)startMonitoringNetworkState
{
    self.currentNetworkState = AFNetworkReachabilityStatusUnknown;
    
    /*
     AFNetworkingReachabilityDidChangeNotification其它地方通过监听这个通知可以得到网络状态改变
     */
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.lasttNetworkState = self.currentNetworkState;
        self.currentNetworkState = status;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivingTheNetworkStateChangeNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];  //监听网络状态改变通知
    
}
#pragma mark --------------------
#pragma mark - UIAlertViewDelegate

#pragma mark -------------------
#pragma mark - NSNotification
#pragma mark --------------------
#pragma mark - NSNotification

//连接音响通知
- (void)recvDidBonjour:(NSNotification *)noti{
    
    NSString *ip = noti.object;
    if (ip) {
        [self connectSeriver:ip];
    }else{
        [self startConnectSongServer]; // 连接音响
    }
}

//监听网络状态通知
-(void)receivingTheNetworkStateChangeNotification:(NSNotification *)notification
{
    static NSInteger _fristChangeNetworkState = 0;
    //temp变量的作用是过滤掉第一次进入到程序时的网络环境变化
    if (_fristChangeNetworkState == 0) {
        _fristChangeNetworkState = 1;
        return;
    }
    
    if (self.currentNetworkState == self.lasttNetworkState) {   //过滤掉相同的操作
        return;
    }
    
    if (self.currentNetworkState == AFNetworkReachabilityStatusReachableViaWiFi) {  //过滤掉切换为wifi环境
        return;
    }
    
    if (self.networkChangeAlertView) {  //过滤掉如果当前弹框还在，则不重复弹框
        return;
    }
    
    NSString *msg = nil;
    if (self.currentNetworkState == AFNetworkReachabilityStatusNotReachable) {
        msg = @"当前没有网络,请检查您的网络连接！";
    } else if (self.currentNetworkState == AFNetworkReachabilityStatusReachableViaWWAN) {
        msg = @"当前为非WIFI网络，请确定是否继续使用！";
    }
    self.networkChangeAlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
    [self.networkChangeAlertView show];
}



@end
