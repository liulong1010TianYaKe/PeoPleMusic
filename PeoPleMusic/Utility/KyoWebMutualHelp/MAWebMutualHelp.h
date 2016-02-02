//
//  MAWebMutualHelp.h
//  MainApp
//
//  Created by Kyo on 16/10/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

#define kMAWebMutualHelpName    @"hzins"

@protocol MAWebViewJSMutualDelegate<JSExport>

/**< 跳转到产品详情界面 */
//JSExportAs(callProDetail,
//           - (void)gotoProductDetailViewControllerWithProductId:(NSInteger)productId withPlanId:(NSInteger)planId);
/**< 打开分享页面 */
//JSExportAs(callShare,
//           - (void)showShareView:(NSString *)openUrl withTitle:(NSString *)title withSummary:(NSString *)summary withPicUrl:(NSString *)picUrl);
///**< 从h5得到分享分享内容 */
//JSExportAs(initShareInfo,
//           - (void)getShareInfo:(NSString *)openUrl withTitle:(NSString *)title withSummary:(NSString *)summary withPicUrl:(NSString *)picUrl);
/**< 跳转到评测报告列表界面 */
//- (void)callEvaluationList;
/**< 跳转到在线客服 */

/**< 顾问状态    0离线 1在线 */
//- (void)updateAdvisorStatus:(NSInteger)status;
/**< 返回用户头像地址 */
//- (NSString *)getUserAvatar;

@end

@interface MAWebMutualHelp : NSObject<MAWebViewJSMutualDelegate>

+ (MAWebMutualHelp *)share;

- (void)bingMutualHelpWithWebView:(UIWebView *)webView withJSContext:(JSContext *)context; //关联一些交互方法和属性

@end
