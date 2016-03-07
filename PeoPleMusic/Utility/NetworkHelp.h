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
