//
//  NetworkSessionHelp.h
//  MainApp
//
//  Created by Kyo on 20/11/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NetworkResultModel.h"
#import "KyoRefreshControl.h"

#define kServerBase @"api.m.hzins.com"
#define kServerAPIUrl(_methodType, _methodName)   [NSString stringWithFormat:@"http://%@%@%@", kServerBase, _methodType, _methodName]

#define kMultipleDevicesSignInErrorCode  @"1005"  //多点登录错误码
#define kReLogInErrorCode  @"1004" //重新登录的状态码

//首页接口
#define kNetworkTypeHome    @"/home/"
#define kNetworkSpecialSubjectList  @"SpecialSubjectList"
#define kNetworkLogin   @"Login"
#define kNetworkSyncLoginFromH5    @"SyncLoginFromH5"
#define kNetworkStartUpImage    @"StartUpImage"

// 产品列表页面
#define kNetworkTypeProduct    @"/LongTail/Product/"
#define kNetworkGetProductList        @"GetProductList"
#define kNetworkGetCategoryList        @"GetCategoryList"

// 我的钱包
#define kNetworkMySafe  @"/MySafe/"
#define kNetworkGetMyDetail     @"GetMyDetail"


//html5页面相关
#define kHtml5ProductDetail(_proId, _planId) [NSString stringWithFormat:@"http://m.hzins.com/LongTailApp/LTproduct/detail?prodId=%ld&planId=%ld", (long)_proId, (long)_planId]  //产品详情页面
#define kHtml5InsureDetail(_proId, _planId) [NSString stringWithFormat:@"http://m.hzins.com/longtailApp/LTProduct/Insure?prodId=%ld&planId=%ld", (long)_proId, (long)_planId]  //投保页面
#define kHtml5PolicyList    @"http://m.hzins.com/longtailApp/LTMySafe/PolicyList"   //保单列表页面
#define kHtml5FavoriteList  @"http://m.hzins.com/longtailApp/LTMySafe/FavoriteList" //收藏列表页面
#define kHtml5EvaluationList    @"http://m.hzins.com/Evaluation/EvaluationList" //我的评测报告列表页面
#define kHtml5ContactList   @"http://m.hzins.com/myinformation/regularContact/list" //常用联系人列表页面
#define kHtml5MyAccount @"http://m.hzins.com/myaccount"    //慧择钱包页面
#define kHtml5AppointmentByMobile   @"http://m.hzins.com/AppointmentByMobile"   //定制保险方案页面
#define kHtml5Register  @"http://m.hzins.com/register"  //注册页面
#define kHtml5FindPW    @"http://m.hzins.com/retrieve"  //找回密码页面
#define kHtml5Claims    @"http://m.hzins.com/claims"    //理赔报案页面
#define kHtml5PolicyQuery   @"http://m.hzins.com/insure/policyquery"    //保单查询页面
#define kHtml5MyInformation @"http://m.hzins.com/myinformation"    //个人信息页面
#define kHtml5About  @"http://m.hzins.com/LongTailApp/LTHome/About"  //关于我们
#define kHtml5MoreGoodProduct   @"http://m.hzins.com/app/hzapp.html?accessType="   //产品页=1，更多精选产品页面=2
#define kHtml5InsureTest  @"http://m.hzins.com/baoxianxuqiupingce"  //保险需求评测页面

#define kHtml5Transportion  [NSString stringWithFormat:@"http://m.hzins.com/Home/sso4app?session=%@&returnUrl=", [[UserInfo sharedUserInfo].session encodeToPercentEscapeString]] //跳转地址，拼接上session
#define kHtml5FormatURL(_url) [NSString stringWithFormat:@"%@%@", kHtml5Transportion, [_url encodeToPercentEscapeString]]  //html5需要的最终地址


static NSString *manyPeopleLogOnElasticBoxMarking;   /**< 是否触发了多点登录 */
static UIAlertView *networkTipAlertView;    /**< 网络被提下线或session过期的弹框 */
static BOOL reloginAlertMarking;    /**< 是否需要重新登录(比如session过期) */

@interface KyoURLSessionTask : NSObject

@property (strong, nonatomic) NSURLSessionTask *task;
@property (copy, nonatomic) NSString *savePath;  /**< 如果是下载的文件的保存路径 */

- (id)initWithTask:(NSURLSessionTask *)task withDownloadSavePath:(NSString *)savePath;

- (void)clearOperation;    //清空网络请求
+ (void)clearOperation:(KyoURLSessionTask *)operation;

@end

@interface NetworkSessionHelp : NSObject

+ (NetworkSessionHelp *)shareNetwork;

+ (NSDictionary *)getNetworkParams:(id)dict;   //数据体
//check网络请求是否正确，是否需要提示
+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict;
+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict errorShowInView:(UIView *)view;
+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict showAlertView:(BOOL)isShow;
+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict withKyoRefreshControl:(KyoRefreshControl *)kyoRefreshControl;


// Post
- (KyoURLSessionTask *)postNetwork:(NSDictionary *)params
                           serverAPIUrl:(NSString *)serverAPIUrl
                        completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                             errorBlock:(void (^)(NSError *error))errorBlock
                          finishedBlock:(void (^)(NSError *error))finishedBlock;

//upload photo
- (KyoURLSessionTask *)uploadNetwork:(NSDictionary *)params
                             serverAPIUrl:(NSString *)serverAPIUrl
                               fileParams:(NSArray *)arrayFile
                          completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                               errorBlock:(void (^)(NSError *error))errorBlock
                            finishedBlock:(void (^)(NSError *error))finishedBlock;

// downfile
- (KyoURLSessionTask *)downFileNetwork:(NSString *)url
                                       params:(NSDictionary *)params
                                   saveToPath:(NSString *)savePath
                               curruntProcess:(void (^)(long long countByte, long long currentByte))process
                              completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                                   errorBlock:(void (^)(NSError *error))errorBlock
                                finishedBlock:(void (^)(NSError *error))finishedBlock;

//cancel downfile and save data
- (void)cancelBySaveResumeData:(KyoURLSessionTask *)kyoURLSessionTask;

@end
