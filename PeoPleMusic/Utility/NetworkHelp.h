//
//  NetworkHelp.h
//  test-57-AFNetwork2.0
//
//  Created by Kyo on 4/18/14.
//  Copyright (c) 2014 Kyo. All rights reserved.
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
#define kNetworkGetAdvertisementList    @"GetAdvertisementList"
#define kNetworkLogin   @"Login"

// 找产品页面  http://api.m.hzins.com/Product/FindRroduct
#define kNetworkProduct         @"/Product/"
#define KNetworkFindRoduct      @"FindProduct"
#define kNetworkGetProuductDetailInfo   @"GetProuductDetailInfo"
#define kNetworkGetCalculatePrice   @"GetCalculatePrice"  //试算
#define kNetworkAddNotifyAnswer @"AddNotifyAnswer"  //保存健康告知信息，得到id

// 产品列表页面
#define KNetworkProductFilter    @"/ProductFilter/"
#define KNetworkGetFilter        @"GetFilter"
#define KNetworkGetCategoryList        @"GetCategoryList"

//产品详情中的接口
#define KNetworkProductAssist   @"/ProductAssist/"
#define KNetworkClauseList        @"ClauseList"
#define kNetworkClauseDetail    @"ClauseDetail"
#define kNetworkInsureCondition @"InsureCondition"
#define kNetowrkCommentList @"CommentList"
#define kNetworkHzTips  @"HzTips"
#define kNetowrkJobDetail   @"JobDetail"
#define kNetworkFavoriteOperate @"FavoriteOperate"

#define kNetworkTypeInsure  @"/Insure/"
#define kNetworkInsureGetInsureDetail @"GetInsureDetail"
#define kNetworkSaveInsure  @"SaveInsure"

//支付接口
#define kNetowrkTypePay @"/pay/"
#define kNetworkPayInsure   @"PayInsure"
#define kNetworkGetRedEnvelopeList  @"GetRedEnvelopeList"
#define kNetworkCheckUsableAndActivateRedEnvelope   @"CheckUsableAndActivateRedEnvelope"
#define kNetworkSubmitPay   @"SubmitPay"
#define kNetworkGetPaySuccessData   @"GetPaySuccessData"

//注册接口
#define kNetworkTypeRegister    @"/Register/"
#define kNetworkRegisterStep1    @"Step1"
#define kNetworkRegisterStep2    @"Step2"
#define kNetworkRegisterStep3    @"Step3"

//找回密码
#define kNetworkTypeRetrieve    @"/Retrieve/"
#define kNetworkGetUserInfo     @"GetUserInfo"
#define kNetworkSendSMS @"SendSMS"
#define kNetworkCheckMobileCode @"CheckMobileCode"
#define kNetworkModifyPasswordByMobile  @"ModifyPasswordByMobile"
#define kNetworkSendEmail   @"SendEmail"
#define kNetworkReSendEmail @"ReSendEmail"


// 我_保单

#define kNetworkMyPolicy   @"/MyPolicy/"
#define kNetworkGetPolicyCount @"GetPolicyCount"
#define kNetworkGetAll     @"GetAll"
#define kNetworkGetEffectivingPay    @"GetEffectivingPay"
#define kNetworkGetOverOrCancelPay     @"GetOverOrCancelPay"
#define kNetworkGetInsureDetail     @"GetInsureDetail"

#define kNetworkSearchPolicy      @"SearchPolicy"
#define kNetworkDeleteInsure     @"DeleteInsure"  // 删除保单
#define kNetworkmypolicy   @"/mypolicy/"
#define kNetworkGetPolicyListByCardNum    @"GetPolicyListByCardNum"
#define kNetworkGetPolicyListByCName   @"GetPolicyListByCName"
// 我的钱包
#define kNetworkMySafe  @"/MySafe/"
#define kNetworkGetMyWallet @"GetMyWallet"
#define kNetworkGetAccountInfo @"GetAccountInfo"
#define kNetworkGetMyRedEnvelopeList @"GetMyRedEnvelopeList"
#define kNetworkAuthMobile @"AuthMobile"
#define kNetworkSendSms @"SendSms"
#define kNetworkGetActivativeRedEnvelope @"ActivativeRedEnvelope"
// 我_邀请送红包
#define kNetworkmysafe  @"/mysafe/"
#define kNetworkGetMyInviteCode @"GetMyInviteCode"
#define kNetworkBindReferrerInviteCode @"BindReferrerInviteCode"
// 我_评测报告
#define kNetworkGetEvaluationRptList @"GetEvaluationRptList"
#define kNetworkGetMyEvaluateRpt @"GetMyEvaluateRpt"
#define kNetworkGetEvaluationRptDetail @"GetEvaluationRptDetail"
#define kNetworkGetContactEvaluationStatus @"GetContactEvaluationStatus"
// 我_设置
#define kNetworkGetRedEnvelopeSource @"GetRedEnvelopeSource"
#define kNetworkCheckPassword @"CheckPassword"
#define kNetworkModifyPassword @"ModifyPassword"
// 我_个人信息
#define kNetworkGetMyDetail     @"GetMyDetail"
#define kNetworkGetMemberAdvertisement     @"GetMemberAdvertisement"
#define kNetworkModifyAvatar    @"ModifyAvatar"

// 我_我的收藏
#define kNetworkMyFavorite  @"/MyFavorite/"
#define kNetworkGetMyFavoriteList @"GetMyFavoriteList"

// 我_常用联系人
#define kNetworkMyContacts     @"/MyContacts/"
#define kNetworkGetContactList @"GetContactList"
#define kNetworkGetContactById @"GetContactById"
#define kNetworkAddContact     @"AddContact"
#define kNetworkUpdateContact  @"UpdateContact"
#define kNetworkRemoveContact  @"RemoveContact"
#define kNetworkGetIdentityTypeList @"GetIdentityTypeList"
#define kNetworkGetRelationShipList @"GetRelationShipList"
#define kNetworkGetAreaList  @"GetAreaList"
#define kNetworkGetAllArea   @"GetAllArea"
// 我_帮助与反馈
#define kNetworkMyFeedback  @"/MyFeedback/"
#define kNetworkAddFeedback @"AddFeedback"

// 关于慧择
#define kNetworkAbout @"/About/"
#define kNetworkAbout2 @"About"

// 保障相关接口
#define kNetworkSecurity @"/Security/"
#define kNetworkGetSecurityPersonList @"GetSecurityPersonList"
#define kNetworkGetSecurityGuideList @"GetSecurityGuideList"
#define kNetworkAddFamilyMember @"AddFamilyMember"

////开启家庭保障助手
#define kNetworkGetEnableFamilyAssistant @"EnableFamilyAssistant"
#define kNetworkGetFamilyMemberList @"GetFamilyMemberList"

//精选方案
#define kNetworkTypeProject @"/Project/"
#define kNetworkGetProjecTypeList  @"GetProjectTypeList"
#define kNetworkGetProjectList  @"GetProjectList"
#define kNetowrkGetProjectDetail    @"GetProjectDetail"
#define kNetworkFavoriteOperate @"FavoriteOperate"
#define kNetowrkGetProjectClauseList    @"GetProjectClauseList"
#define kNetworkGetProjectCommonProblem @"GetProjectCommonProblem"
#define kNetworkProjectHzTips  @"HzTips"
#define kNetworkGetProjectComment   @"GetProjectComment"

//下载保单
#define kNetworkTypePolicyDown  @"/PolicyDown/"
#define kNetworkDownFile    @"DownFile"


// 跳转的H5界面
#define KH5_HELP           @"http://m.hzins.com/help"  // 帮助与反馈
#define KH5_CLAIMREPORT    @"http://m.hzins.com/claims/"  // 理赔报案
#define KH5_PRIVILEGE      @"http://m.hzins.com/Member/Privilege?level=" // 会员等级
#define KH5_GZHZWXGZH      @"http://m.hzins.com/about/weixin.html"       // 关注慧择微信公众号
#define KH5_HZ_INTRODUCE   @"http://m.hzins.com/about/about-about.html"  // 慧择介绍
#define KH5_CONTACT_HZ     @"http://m.hzins.com/about/contact.html"  // 联系慧择
#define KH5_SERVER_CLAUSE  @"http://m.hzins.com/Protocol/"  // 服务条款
#define KH5_DEMAND_REPORT   @"http://m.hzins.com/baoxianxuqiupingce/"  // 需求评测
#define KH5_APPOINTMENTBYMOBILE @"http://m.hzins.com/AppointmentByMobile"  // 预约页面

//counselor
#define kNetWorkTypeAdviser @"/Adviser/"
#define kNetWorkGetMyAdviser @"GetMyAdviser"
#define kNetWorkBindAdviser @"BindAdviser"
#define kNetWorkGrade @"Grade"
#define kNetWorkGetServiceRecords @"GetServiceRecords"
#define kNetWorkGetCommentList @"GetCommentList"
#define kNetWorkGetMyAdviserSimple @"GetMyAdviserSimple"



static NSString *manyPeopleLogOnElasticBoxMarking;   /**< 是否触发了多点登录 */
static UIAlertView *networkTipAlertView;    /**< 网络被提下线或session过期的弹框 */
static BOOL reloginAlertMarking;    /**< 是否需要重新登录(比如session过期) */

@interface NetworkHelp : AFHTTPRequestOperationManager

@property (nonatomic, strong) NSString *sign;

+ (NetworkHelp *)shareNetwork;
+ (NSDictionary *)getNetworkParams:(id)dict;   //数据体
//check网络请求是否正确，是否需要提示
+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict;
+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict errorShowInView:(UIView *)view;
+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict showAlertView:(BOOL)isShow;
+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict withKyoRefreshControl:(KyoRefreshControl *)kyoRefreshControl;

// Post
- (AFHTTPRequestOperation *)postNetwork:(NSDictionary *)params
                        serverAPIUrl:(NSString *)serverAPIUrl
                    completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                         errorBlock:(void (^)(NSError *error))errorBlock
                      finishedBlock:(void (^)(NSError *error))finishedBlock;

//upload photo
- (AFHTTPRequestOperation *)uploadNetwork:(NSDictionary *)params
                             serverAPIUrl:(NSString *)serverAPIUrl
                               fileParams:(NSArray *)arrayFile
                        completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                             errorBlock:(void (^)(NSError *error))errorBlock
                          finishedBlock:(void (^)(NSError *error))finishedBlock;

// downfile
- (AFHTTPRequestOperation *)downFileNetwork:(NSString *)url
                                     params:(NSDictionary *)params
                                 saveToPath:(NSString *)savePath
                            completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                                 errorBlock:(void (^)(NSError *error))errorBlock
                              finishedBlock:(void (^)(NSError *error))finishedBlock;

@end
