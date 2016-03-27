//
//  YMTCPClient.m
//  PeoPleMusic
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "YMTCPClient.h"
#import "GCDAsyncSocket.h"


@interface YMTCPClient (){
    NSString *_serverIp;
    NSInteger _serverPort;
}
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@end
@implementation YMTCPClient
+ (instancetype)share{
    
    static YMTCPClient *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[YMTCPClient alloc] init];
        [_shared configurationInit];
    });
    return _shared;
}

- (void)configurationInit{
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (void)destroySocket{
    
    if (_clientSocket) {
        [_clientSocket disconnect];
        _clientSocket = nil;
    }
}

- (void)connectServer:(NSString *)ip port:(long)port{
    
    NSError *err = nil;
    //    92.168.1.112 : 7433
    if([_clientSocket connectToHost:ip onPort:port error:&err]){
        KyoLog(@"----连接成功!--");
//        [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForRegister]dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:0];
        _serverIp = ip;
        _serverPort = port;
    }else{
        KyoLog(@"----连接失败!--");
    }
    
}



#pragma mark --


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"---%@",host);
    
    
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForRegister]dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:0];
    //
        [_clientSocket readDataWithTimeout:-1 tag:0];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    //    _clientSocket = nil;
    KyoLog(@"断开连接。。。");
    [_clientSocket connectToHost:_serverIp onPort:_serverPort error:&err];
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
        NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSDictionary *dict = [NSDictionary objectWithJSONData:data];
        NSLog(@"----%@",newMessage);
    NSDictionary *dict = [KyoUtil changeJsonStringToDictionary:newMessage];
    NSString *cmdType =  [dict objectForKey:@"cmdType"] ;
    
    if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK]) { // 注册反馈
        
        NSDictionary *tempDict  = [dict objectForKey:@"deviceInfor"];
      DeviceInfor *deviceInfo =  [DeviceInfor objectWithKeyValues:tempDict];
        NSLog(@"%@",deviceInfo.wifiName);
        [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK withData:deviceInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK object:nil];
        
        
    }
    //    [self addText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,newMessage]];
    [_clientSocket readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}
@end
