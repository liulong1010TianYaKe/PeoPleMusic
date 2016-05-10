//
//  KyoURLProtocol.m
//  test-57-AFNetwork2.0
//
//  Created by Kyo on 14-12-28.
//  Copyright (c) 2014年 zhuniT All rights reserved.
//

#import "KyoURLProtocol.h"

#define KyoURLProtocolHandled @"KyoURLProtocolHandled"

@interface KyoURLProtocol()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation KyoURLProtocol

#pragma mark ----------------------
#pragma mark - CycLife

/*
 当遍历到我们自定义的NSURLProtocol时，系统先会调用canInitWithRequest:这个方法。顾名思义，这是整个流程的入口，只有这个方法返回YES我们才能够继续后续的处理。我们可以在这个方法的实现里面进行请求的过滤，筛选出需要进行处理的请求。
 */

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:KyoURLProtocolHandled inRequest:request]) {
        return NO;
    }
    
    //如果http头没有custom_header且是http或https请求，才能发起网络请求----这里就是过滤一些网络请求
    NSString *scheme = [[request URL] scheme];
    NSDictionary *dict = [request allHTTPHeaderFields];
    BOOL isCan = [dict objectForKey:@"custom_header"] == nil &&
    ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
     [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame);
    if (isCan) {
        //屏蔽google
        @try {
            NSString *url = [[[request URL] absoluteString] lowercaseString];
//            NSLog(@"%@",url);
            if ([url rangeOfString:@"google"].location != NSNotFound) {
                isCan = NO;
            }
        }
        @catch (NSException *exception) {
            return isCan;
        }
    }
    return isCan;
}

/*
 当筛选出需要处理的请求后，就可以进行后续的处理，需要至少实现如下4个方法
 */

//返回规范化后的request,一般就只是返回当前request即可
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

//用于判断你的自定义reqeust是否相同，这里返回默认实现即可。它的主要应用场景是某些直接使用缓存而非再次请求网络的地方。
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a
                       toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

//实现请求开始
- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
//    [KyoURLProtocol applyCustomHeaders:mutableReqeust];   //统一添加http头applyCustomHeaders
    [NSURLProtocol setProperty:@(YES)
                        forKey:KyoURLProtocolHandled
                     inRequest:mutableReqeust];
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust
                                                    delegate:self];
}

//实现请求结束
- (void)stopLoading
{
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark ---------------------------
#pragma mark - NSURLConnectionDelegate, NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self
            didFailWithError:error];
}
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    //屏蔽google
    NSString *url = [[[request URL] absoluteString] lowercaseString];
    if ([url rangeOfString:@"google"].location != NSNotFound) {
        return nil;
    }
    
    if (response != nil)
    {
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}
- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self.client URLProtocol:self
didReceiveAuthenticationChallenge:challenge];
}
- (void)connection:(NSURLConnection *)connection
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self.client URLProtocol:self
didCancelAuthenticationChallenge:challenge];
}
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    //判断是否是rar，如果是，发送通知
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
        if (httpURLResponse.allHeaderFields &&
            [httpURLResponse.allHeaderFields objectForKey:@"Content-Disposition"] &&
            [[httpURLResponse.allHeaderFields objectForKey:@"Content-Disposition"] isKindOfClass:[NSString class]]) {
            NSString *contentDisposition = [[httpURLResponse.allHeaderFields objectForKey:@"Content-Disposition"] lowercaseString];
            if ([contentDisposition rangeOfString:@"\\.(rar)|(7z)|(zip)$" options:NSRegularExpressionSearch].location != NSNotFound) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_NetworkDownTypePackage object:connection];
                });
            }
        }
    }
    
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:(NSURLCacheStoragePolicy)[[self request] cachePolicy]];
}
- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    //统计总流量
    [KyoURLProtocol setFlowRate:[KyoURLProtocol getFlowRate] + [data length]];
//    KyoLog(@"流量统计:%lld",[KyoURLProtocol getFlowRate]);
    
    [self.client URLProtocol:self
                 didLoadData:data];
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

#pragma mark ---------------------------
#pragma mark - Gettings

static long long _flowRate;   //使用的总流量

+ (long long)getFlowRate
{
    return _flowRate;
}

#pragma mark ---------------------------
#pragma mark - Settings

+ (void)setFlowRate:(long long)flowRate;
{
    _flowRate = flowRate;
}

@end
