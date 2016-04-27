//
//  RootViewController.h
//  YWCat
//
//  Created by Kyo on 23/3/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "JMTabBarViewController.h"
//#import "AFNetworkReachabilityManager.h"
//#import "LoginViewController.h"
#import "PlayerViewController.h"
#import "LibrayMusicViewController.h"
#import "UserCenterViewController.h"



@interface RootViewController : UIViewController

@property (nonatomic, strong) JMTabBarViewController *tabBarViewController;
//@property (nonatomic, assign) AFNetworkReachabilityStatus currentNetworkState; //当前网络状态


- (BOOL)checkCurrentNetworkConnection;  //检测当前网络状态是否通顺
- (void)networkLogin:(void (^)(BOOL result, NSError *error))resultBlock;   //登录

//- (void)loginCompletion:(LoginSucessBlock)loginSucessBlock;  /**< 跳转到登录界面 */
//- (void)scanQRCodeCompletion:(ScanQRCodeSucessBlock)scanQRCodeSucessBlock;  /**< 跳转到二维码扫描 */
- (void)gotoLibrayMusicViewController;



@end
