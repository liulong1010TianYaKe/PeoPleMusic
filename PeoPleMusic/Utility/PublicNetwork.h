//
//  PublicNetwork.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/17.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeadModel.h"
#import "UserInfoModel.h"
#import "DeviceModel.h"

@interface PublicNetwork : NSObject
+ (NSString *)getJsonStr:(NSDictionary *)dictJson; // 字典转换成json字符串

#pragma mark ---- 向设备音响 发送 消息的 json 字符串
+ (NSString *)sendDeviceJsonForRegister; // 设备注册

+ (NSString *)sendDeviceJsonForCurrentPlayingSongInfoJson; // 获取当前正在播放的歌曲信息：
@end
