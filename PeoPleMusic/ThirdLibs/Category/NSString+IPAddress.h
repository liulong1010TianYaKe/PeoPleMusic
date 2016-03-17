//
//  NSString+IPAddress.h
//  JuMi
//
//  Created by Kyo on 17/6/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (IPAddress)

//+ (NSString *)macAddress;   //mac地址 获取没用 ios7中的api已经屏蔽了mac地址的获取
//+ (NSString *)whatIsMyIpDotCom;    //这是外网可见的ip地址，如果你在小区的局域网中，那就是小区的，不是局域网的内网地址。
+ (NSString *)localWiFiIPAddressAndPort;   //这是获取本地wifi的ip地址
+ (NSString *)stringFromAddress:(const struct sockaddr *)address;  //NSString和Address的转换
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;  //比较字符串ip和scokaddr_in是否是相同的ip地址
+ (NSString *)hostname; //获取host的名称
+ (NSString *)getIPAddressForHost:(NSString *)theHost;  //从host获取地址
+ (NSString *)localIPAddress;   //这是本地host的IP地址

@end
