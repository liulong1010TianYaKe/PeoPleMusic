//
//  AppDelegate.m
//  PeoPleMusic
//
//  Created by long on 11/30/15.
//  Copyright © 2015 long. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "YMBonjourHelp.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //创建窗口
    self.window=[[UIWindow alloc]init];
    self.window.frame=[UIScreen mainScreen].bounds;
    self.window.backgroundColor = kNavBarBGColor;
    
    RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:NSStringFromClass([RootViewController class]) bundle:nil];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
  
    
    NSError* error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    [[YMBonjourHelp shareInstance] startSearch];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    
    NSLog(@"\n\n倔强的打出一行字告诉你我要挂起了。。\n\n");
    
//    //MBAudioPlayer是我为播放器写的单例，这段就是当音乐还在播放状态的时候，给后台权限，不在播放状态的时候，收回后台权限
//    if ([MBAudioPlayer shareInstance].audioPlayer.state == STKAudioPlayerStatePlaying||[MBAudioPlayer shareInstance].audioPlayer.state == STKAudioPlayerStateBuffering||[MBAudioPlayer shareInstance].audioPlayer.state == STKAudioPlayerStatePaused ||[MBAudioPlayer shareInstance].audioPlayer.state == STKAudioPlayerStateStopped) {
//        //有音乐播放时，才给后台权限，不做流氓应用。
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//        [self becomeFirstResponder];
//        //开启定时器
//        [[MBAudioPlayer shareInstance] decideTimerWithType:MBAudioTimerStartBackground andBeginState:YES];
//        [[MBAudioPlayer shareInstance] configNowPlayingInfoCenter];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
//        [self resignFirstResponder];
//        //检测是都关闭定时器
//        [[MBAudioPlayer shareInstance] decideTimerWithType:MBAudioTimerStartBackground andBeginState:NO];
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
