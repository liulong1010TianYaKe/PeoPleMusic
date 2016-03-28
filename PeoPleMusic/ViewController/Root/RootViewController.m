//
//  RootViewController.m
//  YWCat
//
//  Created by Kyo on 23/3/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "RootViewController.h"
#import "UIDevice-Hardware.h"
#import "NewfeatureViewController.h"
#import "PlayerViewController.h"
#import "LibrayMusicViewController.h"
#import "UserCenterViewController.h"
#import "KyoTopWindow.h"
#import "YMBonjourHelp.h"
#import "YMTCPClient.h"

@interface RootViewController()<RESideMenuDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;



@property (nonatomic, strong) UIAlertView *networkChangeAlertView;
@property (nonatomic, assign) AFNetworkReachabilityStatus lasttNetworkState; //之前网络状态
@property (nonatomic, strong) AFHTTPRequestOperation *loginOperation;   //登录操作
@property (strong, nonatomic) AFHTTPRequestOperation *queryDefaultCityOpertaion;
@property (nonatomic, strong) NSMutableArray *arrayCart;


- (void)setupTabBarViewController;
- (void)startMonitoringNetworkState;    //开始监听网络状态
- (void)checkShowNewFeatureViewController;  //检测是否需要显示新特性viewcontroller

-(void)receivingTheNetworkStateChangeNotification:(NSNotification *)notification;   //监听网络状态通知

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
    [self checkShowNewFeatureViewController];   //检测是否需要显示新特性viewcontroller
    
    //添加手势
    [KyoUtil addTagGesture:self performSelector:@selector(clearAllTextField:) withView:self.view];
    
    //判断是否需要自动登录
//    if ([VerifyRegexTool verifyIsNotEmpty:[UserInfo sharedUserInfo].loginName] &&
//        [VerifyRegexTool verifyIsNotEmpty:[UserInfo sharedUserInfo].loginPassWord]) {
//        [self networkLogin:nil];
//    }
    
    [self startConnectSongServer]; // 连接音响
    //延迟2秒后添加window用于点击滑动到top
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KyoTopWindow show];
    });
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];


}

- (void)startConnectSongServer{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([YMBonjourHelp shareInstance].isAirSuccess) {
            NSString *ips =  [YMBonjourHelp shareInstance].deviceIp;
            NSLog(@"%@  %ld", [YMBonjourHelp shareInstance].deviceIp,[YMBonjourHelp shareInstance].port);
            [[YMTCPClient share] connectServer:ips port:SOCKET_PORT2];
        }else{
          [[YMTCPClient share] connectServer:@"192.168.1.106" port:SOCKET_PORT2];
        }
        
    });
}

#pragma mark ------------------------
#pragma mark - Methods

- (void)setupTabBarViewController
{
//    self.tabBarViewController = [[JMTabBarViewController alloc] init];
//    [self addChildViewController:self.tabBarViewController];
//    [self.contentView addSubview:self.tabBarViewController.view];
    
//    self.tabBarViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *lcLeft = [NSLayoutConstraint constraintWithItem:self.tabBarViewController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]; //左
//    NSLayoutConstraint *lcRight = [NSLayoutConstraint constraintWithItem:self.tabBarViewController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];   //右
//    NSLayoutConstraint *lcTop = [NSLayoutConstraint constraintWithItem:self.tabBarViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]; //上
//    NSLayoutConstraint *lcBottom = [NSLayoutConstraint constraintWithItem:self.tabBarViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]; //下
//    [self.contentView addConstraints:@[lcLeft, lcRight, lcTop, lcBottom]];
//    [self.contentView layoutIfNeeded];
    
    self.tabBarViewController = [[JMTabBarViewController alloc] init];
  
    UIViewController *leftVC = [[UIViewController alloc] init];
    
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.tabBarViewController
                                                                    leftMenuViewController:leftVC                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    
    [self addChildViewController:sideMenuViewController];
    [self.contentView addSubview:sideMenuViewController.view];

    
    sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *lcLeft = [NSLayoutConstraint constraintWithItem:sideMenuViewController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]; //左
    NSLayoutConstraint *lcRight = [NSLayoutConstraint constraintWithItem:sideMenuViewController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];   //右
    NSLayoutConstraint *lcTop = [NSLayoutConstraint constraintWithItem:sideMenuViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]; //上
    NSLayoutConstraint *lcBottom = [NSLayoutConstraint constraintWithItem:sideMenuViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]; //下
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
    
    
    //注册网络协议，监听每个网络请求
//    [NSURLProtocol registerClass:[KyoURLProtocol class]];
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

- (void)networkLogin:(void (^)(BOOL result, NSError *error))resultBlock {
//    NSDictionary *dict = @{@"AppId":kAppPlatform,
//                           @"loginName":[UserInfo sharedUserInfo].loginName,
//                           @"password":[UserInfo sharedUserInfo].loginPassWord};
//    
//    [KyoUtil clearOperation:self.loginOperation];
//    self.loginOperation = [[NetworkHelp shareNetwork] postNetwork:[NetworkHelp getNetworkParams:dict] serverAPIUrl:kServerAPIUrl(kNetworkTypeHome, kNetworkLogin) completionBlock:^(NSDictionary *dict, NetworkResultModel *resultModel) {
//        if ([NetworkHelp checkDataFromNetwork:dict showAlertView:NO]) {
//            [UserInfo sharedUserInfo].session = resultModel.Data[@"Session"];
//            [[UserInfo sharedUserInfo] setKeyValues:resultModel.Data[@"UserInfo"]];
//            
//            if (resultBlock) {
//                resultBlock(YES, nil);
//            }
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_LoginSuccess object:nil];
//        } else {
//            if (resultBlock) {
//                resultBlock(NO, nil);
//            }
//        }
//    } errorBlock:^(NSError *error) {
//        if (resultBlock) {
//            resultBlock(NO, error);
//        }
//    } finishedBlock:^(NSError *error) {
//    }];
}

//检测当前网络状态是否通顺
- (BOOL)checkCurrentNetworkConnection {
    if (self.currentNetworkState == AFNetworkReachabilityStatusUnknown ||
        self.currentNetworkState == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    } else {
        return YES;
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

//-(void)loginCompletion:(LoginSucessBlock)loginSucessBlock
//{
//    LoginViewController *loginViewController = [[LoginViewController alloc]init];
//    
//    if (loginSucessBlock) {
//        loginViewController.loginSucessBlock = loginSucessBlock;
//    }
//    
//    JMNavigationViewController *nav = [[JMNavigationViewController alloc]initWithRootViewController:loginViewController];
//    [self presentViewController:nav animated:YES completion:^{
//        
//    }];
//}







#pragma mark --------------------
#pragma mark - UIAlertViewDelegate

#pragma mark -------------------
#pragma mark - NSNotification

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
