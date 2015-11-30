//
//  BasicsWebMutualHelp.h
//  MainApp
//
//  Created by Kyo on 15/10/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

#define kBasicsWebMutualHelpName    @"basics"

@protocol KyoWebViewJSMutualDelegate<JSExport>

- (NSString *)appVersion;   /**< 获取当前版本号 1.0.1 */
- (NSInteger)getAppVersion;   /**< 获取当前版本号 101 */
- (NSString *)projectName;  /**< 获取项目名称 */
- (NSString *)deviceModel;  /**< 设备类型 */
- (NSString *)systemVersion;  /**< 系统版本号 */
- (NSString *)screenResolution; /**< 屏幕分辨率  320x480 */
- (NSString *)screenScale; /**< 屏幕scale*/

@end

@interface KyoBasicsWebMutualHelp : NSObject<KyoWebViewJSMutualDelegate>

+ (KyoBasicsWebMutualHelp *)share;

- (void)bingMutualHelpWithWebView:(UIWebView *)webView withJSContext:(JSContext *)context; //关联一些交互方法和属性

@end
