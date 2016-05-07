//
//  YMBonjourHelp.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 zhuniT All rights reserved.
//

#import <Foundation/Foundation.h>


#define YNotificationName_DIDSUCESSFINDSERVICE   @"YNotificationName_DIDSUCESSFINDSERVICE"  //发现网络配置
#define YNotificationName_DISSUCESSFINDSERVICE   @"YNotificationName_DISSUCESSFINDSERVICE"  //未找到网络配置
@interface YMBonjourHelp : NSObject
+ (instancetype)shareInstance;

@property (nonatomic, strong) NSMutableArray *arrIp;
@property (nonatomic, strong) NSString *deviceIp; // 通过AirPlay 搜索 出设备的 服务IP
@property (nonatomic, assign) long port; // 通过AirPlay 搜索 出设备的 服务port

@property (nonatomic, assign) BOOL isAirSuccess;

- (void)startSearch;
- (void)stopSearch;
@end
