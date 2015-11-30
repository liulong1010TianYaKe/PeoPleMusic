//
//  BasicsWebMutualHelp.m
//  MainApp
//
//  Created by Kyo on 15/10/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import "KyoBasicsWebMutualHelp.h"

@interface KyoBasicsWebMutualHelp()

@end

@implementation KyoBasicsWebMutualHelp

#pragma mark --------------------
#pragma mark - CycLife

+ (KyoBasicsWebMutualHelp *)share {
    static KyoBasicsWebMutualHelp *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[KyoBasicsWebMutualHelp alloc] init];
    });
    
    return _shared;
}

#pragma mark --------------------
#pragma mark - Methods

//关联一些交互方法和属性
- (void)bingMutualHelpWithWebView:(UIWebView *)webView withJSContext:(JSContext *)context {
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[kBasicsWebMutualHelpName] = self;
}

#pragma mark --------------------
#pragma mark - KyoWebViewJSMutualDelegate

/**< 获取当前版本号 */
- (NSString *)appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleShortVersionString"];
}

/**< 获取当前版本号 101 */
- (NSInteger)getAppVersion {
    NSString *version = [self appVersion];
    NSArray *arrayVersion = [version componentsSeparatedByString:@"."];
    version = @"";
    for (NSInteger i = 0; i < arrayVersion.count; i++) {
        version = [version stringByAppendingString:arrayVersion[i]];
    }
    
    return [version integerValue];
}

/**< 获取项目名称 */
- (NSString *)projectName {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:(NSString *)kCFBundleExecutableKey];
}

/**< 设备类型 */
- (NSString *)deviceModel {
    return [[UIDevice currentDevice] model];
}

/**< 系统版本号 */
- (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

/**< 屏幕分辨率  320x480 */
- (NSString *)screenResolution {
    return [NSString stringWithFormat:@"%ldx%ld", (long)[UIScreen mainScreen].bounds.size.width, (long)[UIScreen mainScreen].bounds.size.height];
}

/**< 屏幕scale*/
- (NSString *)screenScale {
    return [@([UIScreen mainScreen].scale) stringValue];
}

@end
