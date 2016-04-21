//
//  YMBonjourHelp.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "YMBonjourHelp.h"

@interface YMBonjourHelp ()<NSNetServiceDelegate,NSNetServiceBrowserDelegate>
@property (nonatomic, strong) NSNetServiceBrowser *brower;
@property (nonatomic, strong) NSNetService *netService;
@end
@implementation YMBonjourHelp


#pragma mark -------------------
#pragma mark - CycLife
+ (instancetype)shareInstance{
    static YMBonjourHelp *_share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[YMBonjourHelp alloc] init];
        [_share configurationInit];
        
    });
    return _share;
}

- (void)configurationInit{
    _brower = [[NSNetServiceBrowser alloc] init];
    _brower.delegate = self;
    self.arrIp = [NSMutableArray array];
    
}

- (void)startSearch{
    [_brower searchForServicesOfType:@"_raop._tcp." inDomain:@"local."];
//    [_brower scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopSearch{
    [_brower stop];
}
#pragma mark -------------------
#pragma mark - Setting


#pragma mark -------------------
#pragma mark - NSNetServiceBrowserDelegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict{
    KyoLog(@"未搜到服务!");
    _isAirSuccess = NO;
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing{
    
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing{
    
//    NSLog(@"-----%@ %@",service.name ,service.type);
    NSString *serviceName = [NSString stringWithFormat:@"%@",service];
//    NSLog(@"devices :%@", serviceName);
    
    if ([serviceName rangeOfString:@"_znt_ios_rrdg_sp"].location != NSNotFound) {
        //        [_airPlayDevices addObject:service];
        
        _netService = service;
        [service setDelegate:self];
        //    aNetService.delegate = self;
        [service resolveWithTimeout:6.0];
    }
    
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender{
    NSString *ip = [self IPFromAddressData:[sender.addresses objectAtIndex:0]];
//    NSLog(@"Ip ----%@ : %@ : %ld----", [sender name], ip, (long)sender.port);
    
    if ([[sender name] rangeOfString:@"_znt_ios_rrdg_sp"].location != NSNotFound){

       
        _isAirSuccess = YES;
        _deviceIp = ip;
        _port =  sender.port;
         [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_DIDSUCESSFINDSERVICE object:nil];
        
//        [_brower stop];
        for (NSString *ip2 in self.arrIp) {
            if ([ip2 isEqualToString:ip]) {
                return;
            }
        }
        [self.arrIp addObject:ip];
        

    }
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
