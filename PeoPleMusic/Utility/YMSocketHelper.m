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


@interface YMSocketHelper ()<GCDAsyncSocketDelegate>
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
        [_shared initSocket];
    });
    return _shared;
}

// 初始化Socket
- (void)initSocket{
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)connectServer{
    if (_clientSocket == nil) {
        _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    NSError *err = nil;
    if([_clientSocket connectToHost:DEVICE_HOT_IP onPort:SOCKET_PORT2 error:&err]){
        KyoLog(@"----连接成功!--");
    }else{
        KyoLog(@"----连接失败!--");
    }
    
}

#pragma mark -- Method
- (BOOL)isLinkToDevice{
    return NO;
}

//-(NSString *)jsonString{
//    NSDictionary *o2 = [NSDictionary dictionaryWithObjectsAndKeys:
//                        _wifiPWD.text, @"pwd",
//                        _wifiSSID.text, @"ssid",
//                        nil];
//    NSDictionary *o1 = [NSDictionary dictionaryWithObjectsAndKeys:
//                        @"0x00", @"result",
//                        @"10", @"type",
//                        @"1",@"status",
//                        o2, @"content",
//                        nil];
//    NSData *json;
//    if([NSJSONSerialization isValidJSONObject:o1]){
//        json = [NSJSONSerialization dataWithJSONObject:o1 options:NSJSONWritingPrettyPrinted error:nil];
//        if(json != nil){
//            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", jsonString);
//            return jsonString;
//        }
//    }
//    return nil;
//}
#pragma mark --


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"---%@",host);
    [_clientSocket readDataWithTimeout:-1 tag:0];
//    //    [self addText:[NSString stringWithFormat:@"连接到:%@",host]];
//    NSString *message = [self jsonString];//[NSString stringWithFormat:@"connect:%@:%@", _wifiSSID.text, _wifiPWD.text];
//    [socket writeData:[message dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    
//    [socket readDataWithTimeout:-1 tag:0];
//    [self searchAirplayServices];
//    //    [self performSelector:@selector(searchAirplayServices) withObject:nil afterDelay:3.0f];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    _clientSocket = nil;
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //    [self addText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,newMessage]];
    //[socket readDataWithTimeout:-1 tag:0];
}
@end
