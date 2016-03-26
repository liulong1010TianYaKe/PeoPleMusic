//
//  YMTCPClient.h
//  PeoPleMusic
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 kyo. All rights reserved.
//


/**
 *  通过IOS的AirPlay模块扫描到音响的DNS服务，根据DNS的名称过滤掉其他的服务只保留以znt_rrdg_sp结尾的服务，然后从该服务中获取音响的服务器ip地址，端口号为9997和9998，二者切换连接，直到连接成功.
 */


#import <Foundation/Foundation.h>

#import "PublicNetwork.h"

#define DEVICE_HOT_IP  @"192.168.43.1"
#define SOCKET_PORT1     9997
#define SOCKET_PORT2     9998


@interface YMTCPClient : NSObject

+ (instancetype)share;

- (void)connectServer:(NSString *)ip port:(long)port;
@end
