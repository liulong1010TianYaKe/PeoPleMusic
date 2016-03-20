//
//  YMSocketHelper.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/15.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "YMSocketHelper.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "GCDAsyncSocket.h"


@interface YMSocketHelper ()<GCDAsyncSocketDelegate>{

}
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@end

@implementation YMSocketHelper


+ (NSString *)fetchCurrentWiFiName{
    
    NSString *wifiName = nil;
    
    CFArrayRef wifiInteraces = CNCopySupportedInterfaces();
    if (!wifiInteraces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)(wifiInteraces);
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName);
        if (dictRef) {
            NSDictionary *networkInfo= (__bridge NSDictionary *)(dictRef);
            KyoLog(@"network info ---> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInteraces);
    return wifiName;
}


+ (instancetype)share{
    
    static YMSocketHelper *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[YMSocketHelper alloc] init];
        [_shared configurationInit];
    });
    return _shared;
}

- (void)configurationInit{
        _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}


- (void)connectServer:(NSString *)ip port:(long)port{

    NSError *err = nil;
//    92.168.1.112 : 7433
    if([_clientSocket connectToHost:ip onPort:port error:&err]){
        KyoLog(@"----连接成功!--");
       [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForRegister]dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:0];
    }else{
        KyoLog(@"----连接失败!--");
    }
    
}

- (void)destroySocket{
    
    if (_clientSocket) {
        [_clientSocket disconnect];
        _clientSocket = nil;
    }
}
/**
 *  通过IOS的AirPlay模块扫描到音响的DNS服务，根据DNS的名称过滤掉其他的服务只保留以znt_rrdg_sp结尾的服务，然后从该服务中获取音响的服务器ip地址，端口号为9997和9998，二者切换连接，直到连接成功.
 */

#pragma mark -- Method
- (BOOL)isLinkToDevice{
    return NO;
}


#pragma mark --


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"---%@",host);


     [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForRegister]dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:0];
//
//    [_clientSocket readDataWithTimeout:-1 tag:0];

}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
//    _clientSocket = nil;
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [NSDictionary objectWithJSONData:data];
//    NSLog(@"----%@",newMessage);
    
    
    //    [self addText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,newMessage]];
    //[socket readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}


@end
