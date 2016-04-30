//
//  RootViewController.h
//  YWCat
//
//  Created by Kyo on 23/3/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JMTabBarViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "PlayerViewController.h"
#import "LibrayMusicViewController.h"
#import "UserCenterViewController.h"
#import "YMTCPClient.h"


@interface RootViewController : UIViewController

@property (nonatomic, strong) JMTabBarViewController *tabBarViewController;
@property (nonatomic, assign) AFNetworkReachabilityStatus lasttNetworkState; //之前网络状态
@property (nonatomic, assign) AFNetworkReachabilityStatus currentNetworkState; //当前网络状态
@property (nonatomic, strong) YMTCPClient *clientTcp;

- (BOOL)connectSeriver:(NSString *)ip;
- (void)getDeviceInfo;
- (void)startSearchSerive;
//- (void)scanQRCodeCompletion:(ScanQRCodeSucessBlock)scanQRCodeSucessBlock;  /**< 跳转到二维码扫描 */
- (void)gotoLibrayMusicViewController;



@end
