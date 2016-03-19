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


@interface YMSocketHelper ()<GCDAsyncSocketDelegate,NSNetServiceBrowserDelegate,NSNetServiceDelegate>{
    NSMutableArray *_airPlayDevices;
    NSNetServiceBrowser *_netServiceBrower;
    NSNetService *_netService;
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
    });
    return _shared;
}



- (void)connectServer{
    if (_clientSocket == nil) {
        _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    NSError *err = nil;
//    92.168.1.112 : 7433
    if([_clientSocket connectToHost:@"192.168.1.112" onPort:@"7433" error:&err]){
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
- (void)searchAirPlaySevices{
    
//    [self destroySocket];
    
    _netServiceBrower = [[NSNetServiceBrowser alloc] init];
    _netServiceBrower.delegate = self;
//    [_netServiceBrower searchForServicesOfType:@"_znt_rrdg_sp._tcp" inDomain:@"local."];
//    [_netServiceBrower searchForRegistrationDomains];
      [_netServiceBrower searchForServicesOfType:@"_raop._tcp." inDomain:@"local."];
//    [_netServiceBrower searchForBrowsableDomains];
//    NSDefaultRunLoopMode
//    [_netServiceBrower scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}
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
    [_clientSocket readDataWithTimeout:-1 tag:0];
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
    NSLog(@"----%@",newMessage);
    
    
    //    [self addText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,newMessage]];
    //[socket readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}

#pragma mark --  NSNetServiceBrowserDelegate
/* Sent to the NSNetServiceBrowser instance's delegate before the instance begins a search. The delegate will not receive this message if the instance is unable to begin a search. Instead, the delegate will receive the -netServiceBrowser:didNotSearch: message.
 */
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser{
    
}

/* Sent to the NSNetServiceBrowser instance's delegate when the instance's previous running search request has stopped.
 */
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser{
    
}

/* Sent to the NSNetServiceBrowser instance's delegate when an error in searching for domains or services has occurred. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a search has been started successfully.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict{
    
}

/* Sent to the NSNetServiceBrowser instance's delegate for each domain discovered. If there are more domains, moreComing will be YES. If for some reason handling discovered domains requires significant processing, accumulating domains until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing{
    
    NSLog(@"%@ %@",domainString,[NSNumber numberWithBool:moreComing]);
}

/* Sent to the NSNetServiceBrowser instance's delegate for each service discovered. If there are more services, moreComing will be YES. If for some reason handling discovered services requires significant processing, accumulating services until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing{
    
    NSLog(@"-----%@ %@",service.name ,service.type);
     NSString *serviceName = [NSString stringWithFormat:@"%@",service];
    NSLog(@"devices :%@", serviceName);
    
    if ([serviceName rangeOfString:@"_znt_ios_rrdg_sp"].location != NSNotFound) {
//        [_airPlayDevices addObject:service];
        _netService = service;
        [service setDelegate:self];
        //    aNetService.delegate = self;
        [service resolveWithTimeout:15.0];
    }
 
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered domain is no longer available.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing{
    
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered service is no longer published.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing{
    
}

- (void)netServiceWillResolve:(NSNetService *)sender{
    
}
- (void)netServiceDidResolveAddress:(NSNetService *)sender{
     NSString *ip = [self IPFromAddressData:[sender.addresses objectAtIndex:0]];
    NSLog(@"Ip ----%@ : %@ : %ld----", [sender name], ip, (long)sender.port);
    
    if ([[sender name] rangeOfString:@"_znt_ios_rrdg_sp"].location != NSNotFound){
        //save ip
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:ip forKey:@"DEVICE_HOT_IP_NAME"];
        [_netServiceBrower stop];
        [self connectServer];
//        [self dialogDismiss];
        //        ViewController *homeViewController = [[ViewController alloc] init];
        //        [self.navigationController pushViewController:homeViewController animated:YES];
    }
}

/* Sent to the NSNetService instance's delegate when an error in resolving the instance occurs. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants).
 */
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *, NSNumber *> *)errorDict{
    
}

-(NSString *)IPFromAddressData:(NSData *) dataIn {
    struct sockaddr_in *socketAddress = nil;
    NSString *ipString = nil;
    
    socketAddress = (struct sockaddr_in *)[dataIn bytes];
    ipString = [NSString stringWithFormat:@"%s",
                inet_ntoa(socketAddress->sin_addr)];
    
    return ipString;
}
@end
