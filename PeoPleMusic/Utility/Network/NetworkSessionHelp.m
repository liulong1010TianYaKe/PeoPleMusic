//
//  NetworkSessionHelp.m
//  MainApp
//
//  Created by Kyo on 20/11/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import "NetworkSessionHelp.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPSessionManager.h"
#import "NSProgress+KyoDownload.h"

#define kNetworkKeyAlertViewTag 104248  //多点登录被迫下线的alertview弹出框tag

@implementation KyoURLSessionTask

#pragma mark --------------------
#pragma mark - CycLife

- (id)initWithTask:(NSURLSessionTask *)task withDownloadSavePath:(NSString *)savePath {
    self = [super init];
    
    if (self) {
        self.task = task;
        self.savePath = savePath;
    }
    
    return self;
}

#pragma mark --------------------
#pragma mark - Methods

//清空网络请求
- (void)clearOperation {
    if (self && self.task) {
        if ([self.task respondsToSelector:@selector(cancelByProducingResumeData:)]) {
            [[NetworkSessionHelp shareNetwork] cancelBySaveResumeData:self];
        } else {
            [self.task cancel];
        }
    }
}

+ (void)clearOperation:(KyoURLSessionTask *)operation {
    if (operation && operation.task) {
        if ([operation.task respondsToSelector:@selector(cancelByProducingResumeData:)]) {
            [[NetworkSessionHelp shareNetwork] cancelBySaveResumeData:operation];
        } else {
            [operation.task cancel];
        }
    }
    
    operation = nil;
}

@end

@interface NetworkSessionHelp()
{
    NSMutableDictionary *_dictProgress;
}

@property (strong, nonatomic) AFHTTPSessionManager *httpSessionManager;
@property (strong, nonatomic) AFURLSessionManager *urlSessionManager;

- (void)insertDownloadUrl:(NSString *)url withProgress:(NSProgress *)progress withCurrentProcess:(void (^)(long long countByte, long long currentByte))currentProcess; //存储下载需要的progress
- (void)deleteDownloadProgress:(NSString *)url; //删除下载需要的progress

+ (void)thePopUpDialogSecurityTips:(NSString *)tip;    //多点登录被破下线提示
//+ (void)reLoginWithTips:(NSString *)msg;    /**< 需要重新登录被迫下线提示（大多数是session过期） */

- (void)loginSuccessNotification:(NSNotification *)notification;

@end

@implementation NetworkSessionHelp

#pragma mark --------------------
#pragma mark - CycLife


+ (NetworkSessionHelp *)shareNetwork
{
    static NetworkSessionHelp *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetworkSessionHelp alloc] init];
        _sharedClient.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _sharedClient.urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:nil];
        
        //开启允许https模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        _sharedClient.httpSessionManager.securityPolicy = securityPolicy;
        _sharedClient.urlSessionManager.securityPolicy = securityPolicy;
        
        [[NSNotificationCenter defaultCenter] addObserver:_sharedClient selector:@selector(loginSuccessNotification:) name:kNotificationName_LoginSuccess object:nil];
    });
    
    return _sharedClient;
}

#pragma mark --------------------
#pragma mark - Params

//数据体
+ (NSDictionary *)getNetworkParams:(id)dict
{
    if (!dict || dict == [NSNull null]) {
        dict = [NSMutableDictionary dictionary];
    }
    
    if (![dict isKindOfClass:[NSMutableDictionary class]] && ![dict isKindOfClass:[NSString class]]) {
        dict = [dict mutableCopy];
    }
    
    //统计参数
    if ([dict isKindOfClass:[NSMutableDictionary class]]) {
        [dict setObject:[KyoUtil getAppstoreVersion] forKey:@"VersionStr"];
        [dict setObject:[KyoUtil getAppKeyChar] forKey:@"IDCode"];
    }
    
    //把字典拼接成JSON字符串
    NSString *args = @"{}";
    if (dict != nil && [dict isKindOfClass:[NSMutableDictionary class]]) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *tempArgs = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        args = tempArgs;
    } else if (dict && [dict isKindOfClass:[NSString class]]) {
        args = dict;
    }
    
    //添加公共参数
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:kAppPlatform forKey:@"appType"];
    [dictParams setObject:[[NSDate date] strLongDate] forKey:@"timestamp"];
    [dictParams setObject:[UserInfo sharedUserInfo].session ? : @"12345" forKey:@"session"];
//    [dictParams setObject:[KyoUtil rootViewController].appConfig.longTail forKey:@"lt"];    //保险公司标示
    [dictParams setObject:args forKey:@"args"];
    
    //对字典中的key进行排序，并拼接串
    NSString *strEncryption = @"";
    NSArray *keys = [[dictParams allKeys]sortedArrayUsingSelector:@selector(compare:)];
    for(NSInteger i = 0;i < dictParams.allKeys.count; i++) {
        NSString *strFromat = [NSString stringWithFormat:@"%@%@",keys[i],[dictParams valueForKey:keys[i]]];
        strEncryption = [strEncryption stringByAppendingString:strFromat];
    }
    
    //对拼接后得到的串进行加密处理
    strEncryption = [[[kAppSalt stringByAppendingString:strEncryption] md5] uppercaseString];
    [dictParams setObject:strEncryption forKey:@"sign"];
    
    return dictParams;
}

#pragma mark --------------------
#pragma mark - Check

+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict
{
    return [NetworkSessionHelp checkDataFromNetwork:dict showAlertView:YES];
}

+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict errorShowInView:(UIView *)view
{
    @try {
        id result = (dict && [dict isKindOfClass:[NSDictionary class]]) ? [dict objectForKey:kNetworkKeyState] : nil;
        if (result && result != [NSNull null] && [result intValue] == 0) {
            return YES;
        }else{
            id errorMsg = [dict objectForKey:kNetworkKeyMsg];
            if (!errorMsg || errorMsg == [NSNull null]) {
                errorMsg = @"操作失败，请稍后重试.";
            }
            
            [MBProgressHUD showMessageHUD:errorMsg withTimeInterval:kShowMessageTime inView:view];
            
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    
}

+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict showAlertView:(BOOL)isShow
{
    id result = (dict && [dict isKindOfClass:[NSDictionary class]]) ? [dict objectForKey:kNetworkKeyState] : nil;
    if (result && result != [NSNull null] && [result intValue] == 0) {
        return YES;
    }else{
        if (isShow) {
            id errorMsg = [dict objectForKey:kNetworkKeyMsg];
            if (!errorMsg || errorMsg == [NSNull null]) {
                errorMsg = @"操作失败，请稍后重试.";
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        return NO;
    }
}

+ (BOOL)checkDataFromNetwork:(NSDictionary *)dict withKyoRefreshControl:(KyoRefreshControl *)kyoRefreshControl {
    kyoRefreshControl.errorMsg = kKyoRefreshControlErrorMsgDefault;
    kyoRefreshControl.errorState = nil;
    id result = (dict && [dict isKindOfClass:[NSDictionary class]]) ? [dict objectForKey:kNetworkKeyState] : nil;
    if (result && result != [NSNull null] && [result intValue] == 0) {
        return YES;
    }else{
        id errorMsg = [dict objectForKey:kNetworkKeyMsg];
        if (!errorMsg || errorMsg == [NSNull null]) {
            errorMsg = @"操作失败，请稍后重试.";
        }
        kyoRefreshControl.errorMsg = errorMsg;
        kyoRefreshControl.errorState = [dict objectForKey:kNetworkKeyState] ? [[dict objectForKey:kNetworkKeyState] stringValue] : nil;
        
        return NO;
    }
}

#pragma mark --------------------
#pragma mark - Network

// Post
- (KyoURLSessionTask *)postNetwork:(NSDictionary *)params
                           serverAPIUrl:(NSString *)serverAPIUrl
                        completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                             errorBlock:(void (^)(NSError *error))errorBlock
                          finishedBlock:(void (^)(NSError *error))finishedBlock
{
    NSURLSessionDataTask *urlSessionDataTask = [[NetworkSessionHelp shareNetwork].httpSessionManager POST:serverAPIUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NetworkResultModel *result = nil;
        @try {
            result = responseObject ? [NetworkResultModel objectWithKeyValues:responseObject] : nil;
            if ([result.State isEqualToString:kMultipleDevicesSignInErrorCode]) {
                [NetworkSessionHelp thePopUpDialogSecurityTips:result.Msg];
            } else if ([result.State isEqualToString:kReLogInErrorCode]) {
//                [NetworkSessionHelp reLoginWithTips:result.Msg];
            }
        }
        @catch (NSException *exception) {
            result = [[NetworkResultModel alloc] init];
        }
        completionBlock(responseObject, result);
        finishedBlock(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (errorBlock && error.code != NSURLErrorCancelled) { //有出错block且出错原因不是cancel，则调用
            errorBlock(error);
        }
        finishedBlock(error);
    }];
    
    KyoURLSessionTask *task = [[KyoURLSessionTask alloc] initWithTask:urlSessionDataTask withDownloadSavePath:nil];
    return task;
}

//upload photo
- (KyoURLSessionTask *)uploadNetwork:(NSDictionary *)params
                             serverAPIUrl:(NSString *)serverAPIUrl
                               fileParams:(NSArray *)arrayFile
                          completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                               errorBlock:(void (^)(NSError *error))errorBlock
                            finishedBlock:(void (^)(NSError *error))finishedBlock
{
    NSURLSessionDataTask *urlSessionDataTask = [[NetworkSessionHelp shareNetwork].httpSessionManager POST:serverAPIUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *fileDict in arrayFile) {
            for (NSString *key in fileDict.allKeys) {
                id value = [fileDict objectForKey:key];
                [formData appendPartWithFileData:value name:key fileName:@"image.png" mimeType:@"application/octet-stream"];
            }
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NetworkResultModel *result = nil;
        @try {
            result = responseObject ? [NetworkResultModel objectWithKeyValues:responseObject] : nil;
            if ([result.State isEqualToString:kMultipleDevicesSignInErrorCode]) {
                [NetworkSessionHelp thePopUpDialogSecurityTips:result.Msg];
            } else if ([result.State isEqualToString:kReLogInErrorCode]) {
//                [NetworkSessionHelp reLoginWithTips:result.Msg];
            }
        }
        @catch (NSException *exception) {
            result = [[NetworkResultModel alloc] init];
        }
        completionBlock(responseObject,result);
        finishedBlock(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorBlock(error);
        finishedBlock(error);
    }];
    
    KyoURLSessionTask *task = [[KyoURLSessionTask alloc] initWithTask:urlSessionDataTask withDownloadSavePath:nil];
    return task;
}

// downfile
- (KyoURLSessionTask *)downFileNetwork:(NSString *)url
                                       params:(NSDictionary *)params
                                   saveToPath:(NSString *)savePath
                               curruntProcess:(void (^)(long long countByte, long long currentByte))process
                              completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                                   errorBlock:(void (^)(NSError *error))errorBlock
                                finishedBlock:(void (^)(NSError *error))finishedBlock
{
    [self deleteDownloadProgress:url];
    NSProgress *progressByte = nil;
    
    // 获得临时文件的路径
    NSString  *tempDoucment = NSTemporaryDirectory();
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    NSRange lastCharRange = [savePath rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    NSString *tempFilePath = [NSString stringWithFormat:@"%@%@.temp",
                              tempDoucment,
                              [savePath substringFromIndex:lastCharRange.location + 1]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tempFilePath]) {
        KyoLog(@"继续下载");
        NSData *resumeData = [NSData dataWithContentsOfFile:tempFilePath];
        NSURLSessionDownloadTask *downloadTask = [self.urlSessionManager downloadTaskWithResumeData:resumeData progress:&progressByte destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            if ([fileManager fileExistsAtPath:tempFilePath]) {
                [fileManager removeItemAtPath:tempFilePath error:nil];
            }
            return [NSURL fileURLWithPath:savePath];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [self deleteDownloadProgress:url];
            
            NetworkResultModel *result = [[NetworkResultModel alloc] init];
            if (error && error.code != NSURLErrorCancelled) {   //有出错block且出错原因不是cancel，则调用
                if (errorBlock) {
                    errorBlock(error);
                }
            } else {
                if (completionBlock) {
                    completionBlock(nil, result);
                }
            }
        }];
        [self insertDownloadUrl:url withProgress:progressByte withCurrentProcess:process];
        KyoURLSessionTask *task = [[KyoURLSessionTask alloc] initWithTask:downloadTask withDownloadSavePath:savePath];
        return task;
    } else {
        KyoLog(@"从0下载");
        NSURLRequest *request = [self.httpSessionManager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:url relativeToURL:self.httpSessionManager.baseURL] absoluteString] parameters:params error:nil];    //session下载只能用get方式
        NSURLSessionDownloadTask *downloadTask = [self.urlSessionManager downloadTaskWithRequest:request progress:&progressByte destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            if ([fileManager fileExistsAtPath:tempFilePath]) {
                [fileManager removeItemAtPath:tempFilePath error:nil];
            }
            return [NSURL fileURLWithPath:savePath];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [self deleteDownloadProgress:url];

            NetworkResultModel *result = [[NetworkResultModel alloc] init];
            if (error && error.code != NSURLErrorCancelled) {   //有出错block且出错原因不是cancel，则调用
                if (errorBlock) {
                    errorBlock(error);
                }
            } else {
                if (completionBlock) {
                    completionBlock(nil, result);
                }
            }
            
            if (finishedBlock) {
                finishedBlock(error);
            }
        }];
        [self insertDownloadUrl:url withProgress:progressByte withCurrentProcess:process];
        KyoURLSessionTask *task = [[KyoURLSessionTask alloc] initWithTask:downloadTask withDownloadSavePath:savePath];
        return task;
    }
}

//cancel downfile and save data
- (void)cancelBySaveResumeData:(KyoURLSessionTask *)kyoURLSessionTask {
    if (kyoURLSessionTask &&
        kyoURLSessionTask.task &&
        [kyoURLSessionTask.task isKindOfClass:[NSURLSessionDownloadTask class]]) {
        NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)kyoURLSessionTask.task;
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            if (resumeData) {
                // 获得临时文件的路径
                NSString  *tempDoucment = NSTemporaryDirectory();
                NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
                NSRange lastCharRange = [kyoURLSessionTask.savePath rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
                NSString *tempFilePath = [NSString stringWithFormat:@"%@%@.temp",
                                          tempDoucment,
                                          [kyoURLSessionTask.savePath substringFromIndex:lastCharRange.location + 1]];
                BOOL result = [resumeData writeToFile:tempFilePath atomically:YES];
                KyoLog(@"存储下载temp结果：%ld", (long)result);
            }
        }];
    }
}

#pragma mark --------------------
#pragma mark - Assist Method

//存储下载需要的progress
- (void)insertDownloadUrl:(NSString *)url withProgress:(NSProgress *)progress withCurrentProcess:(void (^)(long long countByte, long long currentByte))currentProcess {
    _dictProgress = _dictProgress ? _dictProgress : [NSMutableDictionary dictionary];
    if (progress) {
        progress.kyo_url = url;
        progress.kyo_progressBlock = currentProcess;
        [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        [_dictProgress setObject:progress forKey:url];
    }
}

//删除下载需要的progress
- (void)deleteDownloadProgress:(NSString *)url {
    _dictProgress = _dictProgress ? _dictProgress : [NSMutableDictionary dictionary];
    if ([_dictProgress objectForKey:url]) {
        NSProgress *progressByte = [_dictProgress objectForKey:url];
        [progressByte removeObserver:self forKeyPath:@"fractionCompleted"];
        progressByte.kyo_progressBlock = nil;
        [_dictProgress removeObjectForKey:url];
        progressByte = nil;
    }
}

//多点登录被破下线提示
+ (void)thePopUpDialogSecurityTips:(NSString *)tip
{
    if (!manyPeopleLogOnElasticBoxMarking &&
        ![manyPeopleLogOnElasticBoxMarking isEqualToString:tip] &&
        !networkTipAlertView) {
        networkTipAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:tip delegate:[NetworkSessionHelp shareNetwork]  cancelButtonTitle:@"知道了" otherButtonTitles:@"重新登录", nil];
        networkTipAlertView.tag = kNetworkKeyAlertViewTag;
        [networkTipAlertView show];
        
        manyPeopleLogOnElasticBoxMarking = tip;
        
        [UserInfo sharedUserInfo].session = @"12345";
    }
}

///**< 需要重新登录被迫下线提示（大多数是session过期） */
//+ (void)reLoginWithTips:(NSString *)msg
//{
//    if (reloginAlertMarking) {
//        [[KyoUtil rootViewController] loginCompletion:^{
//        }];
//        
//        reloginAlertMarking = YES; //设置 已重新登录
//        [[UserInfo sharedUserInfo] logout];
//        
//        [[KyoUtil getCurrentNavigationViewController] popToRootViewControllerAnimated:YES];
//    }
//}

#pragma mark --------------------
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kNetworkKeyAlertViewTag) {  //多点登录被T下线
        if (alertView.cancelButtonIndex == buttonIndex) {
            [[UserInfo sharedUserInfo] logout];
            [[KyoUtil getCurrentNavigationViewController] popToRootViewControllerAnimated:YES];
            networkTipAlertView = nil;
        } else {  //重新登录
            UIWindow *targetWindow = kShowMessageView();
            [MBProgressHUD showLoadingHUD:nil inView:targetWindow withDelegate:nil userInteractionEnabled:YES];
            [[KyoUtil rootViewController] networkLogin:^(BOOL result, NSError *error) {
                if (!result) {
                    [[UserInfo sharedUserInfo] logout];
                }
                [MBProgressHUD hideLoadingHUD:0 withView:targetWindow];
                networkTipAlertView = nil;
            }];
        }
    }
}


#pragma mark --------------------
#pragma mark - NSNotification

- (void)loginSuccessNotification:(NSNotification *)notification {
    manyPeopleLogOnElasticBoxMarking = nil;
    reloginAlertMarking = NO;
}

#pragma mark --------------------
#pragma mark - KVO/KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isKindOfClass:[NSProgress class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSProgress *progress = (NSProgress *)object;
            if (progress.kyo_progressBlock) {
                progress.kyo_progressBlock(progress.totalUnitCount, progress.completedUnitCount);
            }
        });
    }
}

@end
