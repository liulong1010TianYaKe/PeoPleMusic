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
    
}

- (void)startSearch{
    [_brower searchForServicesOfType:@"_raop._tcp." inDomain:@"local."];
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
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing{
    
//    NSLog(@"-----%@ %@",service.name ,service.type);
    NSString *serviceName = [NSString stringWithFormat:@"%@",service];
//    NSLog(@"devices :%@", serviceName);
    
    if ([serviceName rangeOfString:@"_znt_ios_rrdg_sp"].location != NSNotFound) {
        //        [_airPlayDevices addObject:service];
        _isAirSuccess = YES;
        _netService = service;
        [service setDelegate:self];
        //    aNetService.delegate = self;
        [service resolveWithTimeout:15.0];
    }
    
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender{
    NSString *ip = [self IPFromAddressData:[sender.addresses objectAtIndex:0]];
//    NSLog(@"Ip ----%@ : %@ : %ld----", [sender name], ip, (long)sender.port);
    
    if ([[sender name] rangeOfString:@"_znt_ios_rrdg_sp"].location != NSNotFound){
        //save ip
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:ip forKey:@"DEVICE_HOT_IP_NAME"];
        
        _deviceIp = ip;
        _port =  sender.port;
        
        [_brower stop];

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
