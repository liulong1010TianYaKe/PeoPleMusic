//
//  NetworkHelp.m
//  test-57-AFNetwork2.0
//
//  Created by Kyo on 4/18/14.
//  Copyright (c) 2014 Kyo. All rights reserved.
//


#import "NetworkHelp.h"
#import "NSString+MD5.h"
#import "AFURLRequestSerialization.h"

#define kNetworkKeyAlertViewTag 104248  //多点登录被迫下线的alertview弹出框tag


@interface NetworkHelp()<UIAlertViewDelegate>

+ (void)thePopUpDialogSecurityTips:(NSString *)tip;    //多点登录被破下线提示
+ (void)reLoginWithTips:(NSString *)msg;    /**< 需要重新登录被迫下线提示（大多数是session过期） */

- (void)loginSuccessNotification:(NSNotification *)notification;

@end

@implementation NetworkHelp

#pragma mark --------------------
#pragma mark - CycLife


+ (NetworkHelp *)shareNetwork
{
    static NetworkHelp *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetworkHelp alloc] initWithBaseURL:nil];
        //开启允许https模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        _sharedClient.securityPolicy = securityPolicy;
        
        [[NSNotificationCenter defaultCenter] addObserver:_sharedClient selector:@selector(loginSuccessNotification:) name:kNotificationName_LoginSuccess object:nil];
        
//        ((AFJSONResponseSerializer *)_sharedClient.responseSerializer).removesKeysWithNullValues = YES;
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
        [dict setObject:kAppMarket forKeyedSubscript:@"AppMarket"];
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
//    [dictParams setObject:@"12345" forKey:@"trace"];
    [dictParams setObject:kAppPlatform forKey:@"appType"];
    [dictParams setObject:[[NSDate date] strLongDate] forKey:@"timestamp"];
    [dictParams setObject:[UserInfo sharedUserInfo].session ? : @"12345" forKey:@"session"];
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
    return [NetworkHelp checkDataFromNetwork:dict showAlertView:YES];
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
            
            [KyoUtil showMessageHUD:errorMsg withTimeInterval:kShowMessageTime inView:view];
            
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
- (AFHTTPRequestOperation *)postNetwork:(NSDictionary *)params
                           serverAPIUrl:(NSString *)serverAPIUrl
                        completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                             errorBlock:(void (^)(NSError *error))errorBlock
                          finishedBlock:(void (^)(NSError *error))finishedBlock
{
    return [[NetworkHelp shareNetwork] POST:serverAPIUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NetworkResultModel *result = nil;
        @try {
            result = responseObject ? [NetworkResultModel objectWithKeyValues:responseObject] : nil;
            if ([result.State isEqualToString:kMultipleDevicesSignInErrorCode]) {
                [NetworkHelp thePopUpDialogSecurityTips:result.Msg];
            } else if ([result.State isEqualToString:kReLogInErrorCode]) {
                [NetworkHelp reLoginWithTips:result.Msg];
            }
        }
        @catch (NSException *exception) {
            result = [[NetworkResultModel alloc] init];
        }
        
        completionBlock(responseObject, result);
        finishedBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock && error.code != NSURLErrorCancelled) { //有出错block且出错原因不是cancel，则调用
            errorBlock(error);
        }
        finishedBlock(error);
    }];
}

//upload photo
- (AFHTTPRequestOperation *)uploadNetwork:(NSDictionary *)params
                             serverAPIUrl:(NSString *)serverAPIUrl
                               fileParams:(NSArray *)arrayFile
                          completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                               errorBlock:(void (^)(NSError *error))errorBlock
                            finishedBlock:(void (^)(NSError *error))finishedBlock
{
    return [[NetworkHelp shareNetwork] POST:serverAPIUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *fileDict in arrayFile) {
            for (NSString *key in fileDict.allKeys) {
                id value = [fileDict objectForKey:key];
                [formData appendPartWithFileData:value name:key fileName:@"image.png" mimeType:@"application/octet-stream"];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NetworkResultModel *result = nil;
        @try {
            result = responseObject ? [NetworkResultModel objectWithKeyValues:responseObject] : nil;
            if ([result.State isEqualToString:kMultipleDevicesSignInErrorCode]) {
                [NetworkHelp thePopUpDialogSecurityTips:result.Msg];
            } else if ([result.State isEqualToString:kReLogInErrorCode]) {
                [NetworkHelp reLoginWithTips:result.Msg];
            }
        }
        @catch (NSException *exception) {
            result = [[NetworkResultModel alloc] init];
        }
        completionBlock(responseObject,result);
        finishedBlock(nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock && error.code != NSURLErrorCancelled) { //有出错block且出错原因不是cancel，则调用
            errorBlock(error);
        }
        finishedBlock(error);
    }];
}

// downfile
- (AFHTTPRequestOperation *)downFileNetwork:(NSString *)url
                                     params:(NSDictionary *)params
                                 saveToPath:(NSString *)savePath
                            completionBlock:(void (^)(NSDictionary *dict, NetworkResultModel *resultModel))completionBlock
                                 errorBlock:(void (^)(NSError *error))errorBlock
                              finishedBlock:(void (^)(NSError *error))finishedBlock
{
    // 获得临时文件的路径
    NSString  *tempDoucment = NSTemporaryDirectory();
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    NSRange lastCharRange = [savePath rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    NSString *tempFilePath = [NSString stringWithFormat:@"%@%@.temp",
                              tempDoucment,
                              [savePath substringFromIndex:lastCharRange.location + 1]];
    
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL:self.baseURL] absoluteString] parameters:params error:nil];
    // 判断之前是否下载过 如果有下载重新构造Header
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tempFilePath])
    {
        NSError *error = nil;
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:tempFilePath
                                                                     error:&error]
                                       fileSize];
        if (error) {
            NSLog(@"get %@ fileSize failed!\nError:%@", tempFilePath, error);
        }
        NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
        [request addValue:headerRange forHTTPHeaderField:@"Range"];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error = nil;
        
        // 下载完成以后 先删除之前的文件 然后mv新的文件
        if ([fileManager fileExistsAtPath:savePath]) {
            [fileManager removeItemAtPath:savePath error:&error];
            if (error) {
                NSLog(@"remove %@ file failed!\nError:%@", savePath, error);
                exit(-1);
            }
        }
    
        //如果不存在文件夹则创建
        if (![fileManager fileExistsAtPath:[savePath stringByDeletingLastPathComponent]]) {
            [fileManager createDirectoryAtPath:[savePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [fileManager moveItemAtPath:tempFilePath toPath:savePath error:&error];
        if (error) {
            NSLog(@"move %@ file to %@ file is failed!\nError:%@", tempFilePath, savePath, error);
            exit(-1);
        }
        
        NetworkResultModel *result = nil;
        @try {
            result = responseObject ? [NetworkResultModel objectWithKeyValues:responseObject] : nil;
            if ([result.State isEqualToString:kMultipleDevicesSignInErrorCode]) {
                [NetworkHelp thePopUpDialogSecurityTips:result.Msg];
            } else if ([result.State isEqualToString:kReLogInErrorCode]) {
                [NetworkHelp reLoginWithTips:result.Msg];
            }
        }
        @catch (NSException *exception) {
            result = [[NetworkResultModel alloc] init];
        }
        completionBlock(responseObject,result);
        finishedBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock && error.code != NSURLErrorCancelled) { //有出错block且出错原因不是cancel，则调用
            errorBlock(error);
        }
        finishedBlock(error);
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        KyoLog(@"总大小：%lld",totalBytesExpectedToRead);
        KyoLog(@"当前已下载：%lld",totalBytesRead);
        KyoLog(@"下载速度：%ld",(long)bytesRead);
    }];
    
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:tempFilePath append:YES];
    [self.operationQueue addOperation:operation];
    return operation;
}

#pragma mark --------------------
#pragma mark - Methods

//多点登录被破下线提示
+ (void)thePopUpDialogSecurityTips:(NSString *)tip
{
    if (!manyPeopleLogOnElasticBoxMarking &&
        ![manyPeopleLogOnElasticBoxMarking isEqualToString:tip] &&
        !networkTipAlertView) {
        networkTipAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:tip delegate:[NetworkHelp shareNetwork]  cancelButtonTitle:@"知道了" otherButtonTitles:@"重新登录", nil];
        networkTipAlertView.tag = kNetworkKeyAlertViewTag;
        [networkTipAlertView show];
        
        manyPeopleLogOnElasticBoxMarking = tip;
        
        [UserInfo sharedUserInfo].session = @"12345";
    }
}

/**< 需要重新登录被迫下线提示（大多数是session过期） */
+ (void)reLoginWithTips:(NSString *)msg
{
//    if (reloginAlertMarking) {
//        [[KyoUtil rootViewController] loginCompletion:^{
//        }];
//        
//        reloginAlertMarking = YES; //设置 已重新登录
//        [[UserInfo sharedUserInfo] logout];
//        
//        [[KyoUtil getCurrentNavigationViewController] popToRootViewControllerAnimated:YES];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [KyoUtil getRootViewController].selectedIndex = 1;
//        });
//    }
}

#pragma mark --------------------
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kNetworkKeyAlertViewTag) {  //多点登录被T下线
        if (alertView.cancelButtonIndex == buttonIndex) {
            [[UserInfo sharedUserInfo] logout];
            [[KyoUtil getCurrentNavigationViewController] popToRootViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [KyoUtil getRootViewController].selectedIndex = 1;
            });
            networkTipAlertView = nil;
        } else {  //重新登录
            UIWindow *targetWindow = kShowMessageView();
            [KyoUtil showLoadingHUD:nil inView:targetWindow withDelegate:nil userInteractionEnabled:YES];
            [[KyoUtil rootViewController] networkLogin:^(BOOL result, NSError *error) {
                if (!result) {
                    [[UserInfo sharedUserInfo] logout];
                }
                [KyoUtil hideLoadingHUD:0 withView:targetWindow];
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



@end
