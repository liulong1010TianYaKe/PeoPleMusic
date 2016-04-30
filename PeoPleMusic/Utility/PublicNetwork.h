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
#import "SongInforModel.h"

@interface PublicNetwork : NSObject

+ (NSString *)fetchCurrentWiFiName;

+ (NSString *)getJsonStr:(NSDictionary *)dictJson; // 字典转换成json字符串

#pragma mark ---- 向设备音响 发送 消息的 json 字符串
+ (NSString *)sendDeviceJsonForRegister; // 设备注册

+ (NSString *)sendDeviceJsonForCurrentPlayingSongInfoJson; // 获取当前正在播放的歌曲信息：

+ (NSString *)sendDeviceJsonForBooKingSongListWithpageNum:(NSInteger)pageNum withPageSize:(NSInteger)pageSize; // 获取点播列表

+ (NSString *)sendDeviceJsonForBookIngPlaySong:(SongInforModel *)songInfoModel withPlayType:(NSInteger)playType;  // 点歌命令

+ (NSString *)sendDeviceJsonForDeleteSongInfo; // 8.删除歌曲

+ (NSString *)sendDeviceJsonForSetDevice:(DeviceInfor*)deviceInfo; //13,配置设备
+ (NSString *)sendDeviceJsonForSetDeviceVolume:(NSInteger)volume; //17.	设置设备音量
+ (NSString *)sendDeviceJsonForGetDeviceVolume;
/**<20.	获取播放状态	 */
+ (NSString *)sendDeviceJsonForGetDevicePlayState;
/**<21.	设置播放状态	 */
+ (NSString *)sendDeviceJsonForSetDevicePlayState:(NSInteger)playState;
/**<22.	切歌	 */
+ (NSString *)sendDeviceJsonForSetDevicePlayNextSong;
/**<24.	获取音响本地歌曲目录	 */
+ (NSString *)sendDeviceJsonForGetDeviceSongDir;
/**<24.	获取音响目录下的歌曲	 */
+ (NSString *)sendDeviceJsonForGetDeviceSongWithRequestKey:(NSString *)requestKey withTotalSize:(NSInteger)totalSize;
/**<29.设置点播权限	 */
+ (NSString *)sendDeviceJsonForSetDevicePlayPermission:(NSInteger)permission;
@end
