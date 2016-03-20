//
//  YMBonjourHelp.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMBonjourHelp : NSObject
+ (instancetype)shareInstance;

@property (nonatomic, strong) NSString *deviceIp; // 通过AirPlay 搜索 出设备的 服务IP
@property (nonatomic, assign) long port; // 通过AirPlay 搜索 出设备的 服务port

@property (nonatomic, assign) BOOL isAirSuccess;

- (void)startSearch;
- (void)stopSearch;
@end
