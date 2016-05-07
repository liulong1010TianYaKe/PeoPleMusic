//
//  NetworkSessionHelp.m
//  MainApp
//
//  Created by Kyo on 20/11/15.
//  Copyright © 2015 zhunit. All rights reserved.
//

#import "NetworkSessionHelp.h"
#import "AFNetworking.h"


@interface NetworkSessionHelp()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation NetworkSessionHelp

#pragma mark --------------------
#pragma mark - CycLife



+ (void)NetworkHTML:(NSString *)urlString completionBlock:(void (^)(NSString *,NSInteger ))completionBlock errorBlock:(void (^)(NSError *))errorBlock  {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionTask *sessionTask  = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_main_async_safeThread(^{
        
            NSHTTPURLResponse *respdose = (NSHTTPURLResponse*)response;
            if (!error) {
                
                NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (completionBlock) {
                    completionBlock(html, respdose.statusCode);
                }
                
                
            }else{
                if (errorBlock) {
                    errorBlock(error);
                }
                
            }
        })
        
      
    }];
    [sessionTask resume];
}

+ (void)Network:(NSString *)urlString completionBlock:(void (^)(NSDictionary *,NSInteger ))completionBlock errorBlock:(void (^)(NSError *))errorBlock finishedBlock:(void (^)(NSError *error))finishedBlock {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionTask *sessionTask  = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
//        NSHTTPURLResponse *respdose = (NSHTTPURLResponse*)response;
        if (!error) {
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            responseString = [KyoUtil changeJsonStringToTrueJsonString:responseString];
           
           NSData *tempdata = [responseString dataUsingEncoding:NSUTF8StringEncoding];
           NSDictionary *dict  = [NSJSONSerialization JSONObjectWithData:tempdata options:0 error:nil];
            if (completionBlock) {
//                completionBlock(html, respdose.statusCode);
            }
            
            if (finishedBlock) {
                finishedBlock(nil);
            }
            
            
        }else{
            if (errorBlock) {
                errorBlock(error);
            }
            
            if (finishedBlock) {
                finishedBlock(error);
            }
        }
    }];
    [sessionTask resume];
}

+ (NetworkSessionHelp *)shareNetwork
{
    static NetworkSessionHelp *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetworkSessionHelp alloc] init];
        _sharedClient.httpSessionManager  = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];;

        //开启允许https模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        _sharedClient.httpSessionManager.securityPolicy = securityPolicy;
  
    });
    
    return _sharedClient;
}


+ (void)postNetwork:(NSString *)urlString completionBlock:(void (^)(NSDictionary *dict, NSInteger result))completionBlock errorBlock:(void (^)(NSError *))errorBlock finishedBlock:(void (^)(NSError *))finishedBlock{

    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionTask *sessionTask  = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_main_async_safeThread(^{
            if (!error) {
                
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                responseString = [KyoUtil changeJsonStringToTrueJsonString:responseString];
                
                NSData *tempdata = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict  = [NSJSONSerialization JSONObjectWithData:tempdata options:0 error:nil];
                NSInteger result = [dict[@"result"] integerValue];
                if (completionBlock) {
                    completionBlock(dict, result);
                }
                
                if (finishedBlock) {
                    finishedBlock(nil);
                }
                
                
            }else{
                if (errorBlock) {
                    errorBlock(error);
                }
                
                if (finishedBlock) {
                    finishedBlock(error);
                }
            }
        });
//        NSHTTPURLResponse *respdose = (NSHTTPURLResponse*)response;
     
    }];
    [sessionTask resume];
}






@end
