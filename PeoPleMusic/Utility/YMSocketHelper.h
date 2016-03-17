//
//  YMSocketHelper.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/15.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicNetwork.h"

#define DEVICE_HOT_IP  @"192.168.43.1"
#define SOCKET_PORT1     9997
#define SOCKET_PORT2     9998
@interface YMSocketHelper : NSObject

+ (instancetype)share;
+ (NSString *)fetchCurrentWiFiName;
- (BOOL)isLinkToDevice; // 是否链接设备

- (void)connectServer;
- (void)searchAirPlaySevices;
@end
