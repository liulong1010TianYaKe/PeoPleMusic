//
//  PublicNetwork.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/17.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "PublicNetwork.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation PublicNetwork


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
// 字典转化成json字符串
+ (NSString *)getJsonStr:(NSDictionary *)dictJson{
    //转为json字符串
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dictJson options:0 error:NULL];
    if (dataJson) {
        NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
         NSString *cmdStr = [NSString stringWithFormat:@"%@znt_pkg_end",strJson];
        return cmdStr;
    } else {
        return nil;
    }
}

#pragma mark ----
+ (NSString *)sendDeviceJsonForRegister{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_REGISTERED]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    return [PublicNetwork getJsonStr:dictJson];
}

+ (NSString *)sendDeviceJsonForCurrentPlayingSongInfoJson{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson addEntriesFromDictionary:[DeviceModel dictDeviceWithModel:nil]];
    return [PublicNetwork getJsonStr:dictJson];
}

+ (NSString *)sendDeviceJsonForBooKingSongListWithpageNum:(NSInteger)pageNum withPageSize:(NSInteger)pageSize { // 获取点播列表
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_GET_SONG_LIST]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson addEntriesFromDictionary:[DeviceModel dictDeviceWithModel:nil]];
    [dictJson setObject:@(0) forKey:@"total"];
    [dictJson setObject:@(pageSize) forKey:@"pageSize"];
    [dictJson setObject:@(pageNum) forKey:@"pageNum"];
    return [PublicNetwork getJsonStr:dictJson];
}


+ (NSString *)sendDeviceJsonForBookIngPlaySong:(SongInforModel *)songInfoModel withPlayType:(NSInteger)playType{  // 点歌命令
    
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson addEntriesFromDictionary:[DeviceModel dictDeviceWithModel:nil]];
    [dictJson setObject:[SongInforModel getSongInfoDictWtihSongInfo:songInfoModel] forKey:@"songInfor"];
    [dictJson setObject:@(playType) forKey:@"playType"];
    
    return [PublicNetwork getJsonStr:dictJson];
}

+ (NSString *)sendDeviceJsonForDeleteSongInfo{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_DEL_SONG]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson addEntriesFromDictionary:[DeviceModel dictDeviceWithModel:nil]];
    return [PublicNetwork getJsonStr:dictJson];
}

+ (NSString *)sendDeviceJsonForSetDevice:(DeviceInfor*)deviceInfo{ //13,配置设备
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_SETING_DEVICE]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson addEntriesFromDictionary:[DeviceModel dictDeviceWithModel:nil]];
    [dictJson setObject:[deviceInfo keyValues] forKey:@"deviceInfor"];
    return [PublicNetwork getJsonStr:dictJson];
}

+ (NSString *)sendDeviceJsonForSetDeviceVolume:(NSInteger)volume{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_SET_DEVICE_VOICE]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson setObject:@(volume) forKey:@"volume"];
    return [PublicNetwork getJsonStr:dictJson];
}

+ (NSString *)sendDeviceJsonForGetDeviceVolume{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_GET_DEVICE_VOICE]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson setObject:@(0) forKey:@"maxVolume"];
    [dictJson setObject:@(0) forKey:@"volume"];
    return [PublicNetwork getJsonStr:dictJson];
}
/**<20.	获取播放状态	 */
+ (NSString *)sendDeviceJsonForGetDevicePlayState{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_GET_DEVICE_PLAYSTATE]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson setObject:@(0) forKey:@"playState"];
    return [PublicNetwork getJsonStr:dictJson];
}
/**<21.	设置播放状态	 */
+ (NSString *)sendDeviceJsonForSetDevicePlayState:(NSInteger)playState{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_SET_DEVICE_PLAYSTATE]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson setObject:@(playState) forKey:@"playState"];
    return [PublicNetwork getJsonStr:dictJson];
}
/**<24.	获取音响本地歌曲目录	 */
+ (NSString *)sendDeviceJsonForGetDeviceSongDir{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_GET_DEVICE_SONGSDIR]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson setObject:@(0) forKey:@"requestType"];
    return [PublicNetwork getJsonStr:dictJson];
}
/**<24.	获取音响目录下的歌曲	 */
+ (NSString *)sendDeviceJsonForGetDeviceSongWithRequestKey:(NSString *)requestKey withTotalSize:(NSInteger)totalSize{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_GET_DEVICE_SONGSDIR]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson setObject:requestKey forKey:@"requestKey"];
     [dictJson setObject:@(1) forKey:@"requestType"];
    [dictJson setObject:@(totalSize) forKey:@"totalSize"];
    return [PublicNetwork getJsonStr:dictJson];
}
/**<29.设置点播权限	 */
+ (NSString *)sendDeviceJsonForSetDevicePlayPermission:(NSInteger)permission{
    NSMutableDictionary *dictJson = [NSMutableDictionary dictionary];   //传入服务器的json字典
    [dictJson setDictionary:[HeadModel getJSONHead:YM_HEAD_CMDTYPE_SET_DEVICE_PLAYPERMISSION]];
    [dictJson setObject:[UserInfoModel getUserInfoDict:NO] forKey:@"userInfor"];
    [dictJson setObject:@(permission) forKey:@"permission"];
    return [PublicNetwork getJsonStr:dictJson];
}
@end
