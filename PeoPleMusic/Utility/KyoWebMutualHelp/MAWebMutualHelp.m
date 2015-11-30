//
//  MAWebMutualHelp.m
//  MainApp
//
//  Created by Kyo on 16/10/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import "MAWebMutualHelp.h"


@interface MAWebMutualHelp()

@end

@implementation MAWebMutualHelp

#pragma mark --------------------
#pragma mark - CycLife

+ (MAWebMutualHelp *)share {
    static MAWebMutualHelp *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[MAWebMutualHelp alloc] init];
    });
    
    return _shared;
}

#pragma mark --------------------
#pragma mark - Methods

//关联一些交互方法和属性
- (void)bingMutualHelpWithWebView:(UIWebView *)webView withJSContext:(JSContext *)context {
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[kMAWebMutualHelpName] = self;
}

#pragma mark --------------------
#pragma mark - MAWebViewJSMutualDelegate



///**< 打开分享页面 */
//- (void)showShareView:(NSString *)openUrl withTitle:(NSString *)title withSummary:(NSString *)summary withPicUrl:(NSString *)picUrl {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        KyoShareModel *kyoShareModel = [[KyoShareModel alloc] init];
//        kyoShareModel.title = title;
//        kyoShareModel.text = summary;
//        kyoShareModel.imageUrl = picUrl;
//        kyoShareModel.openUrl = openUrl;
//        [ShareView showInView:[KyoUtil rootViewController].view withKyoShareModel:kyoShareModel];
//    });
//}

///**< 从h5得到分享分享内容 */
//- (void)getShareInfo:(NSString *)openUrl withTitle:(NSString *)title withSummary:(NSString *)summary withPicUrl:(NSString *)picUrl {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        KyoShareModel *kyoShareModel = [[KyoShareModel alloc] init];
//        kyoShareModel.title = title;
//        kyoShareModel.text = summary;
//        kyoShareModel.imageUrl = picUrl;
//        kyoShareModel.openUrl = openUrl;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_InitShareInfo object:kyoShareModel];
//    });
//}



/**< 跳转到在线客服 */
- (void)callOnlineServicePage:(NSString *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_GotoOnlineServicePage object:url];
    });
}

/**< 顾问状态    0离线 1在线 */
- (void)updateAdvisorStatus:(NSInteger)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_AdvisorStatus object:@(status)];
    });
}

///**< 返回用户头像地址 */
//- (NSString *)getUserAvatar {
//    if ([[UserInfo sharedUserInfo] isLogined]) {
//        return [UserInfo sharedUserInfo].avatar ? : @"";
//    } else {
//        return @"";
//    }
//}

@end
