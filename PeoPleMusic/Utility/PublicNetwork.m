//
//  PublicNetwork.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/17.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "PublicNetwork.h"


@implementation PublicNetwork

// 字典转化成json字符串
+ (NSString *)getJsonStr:(NSDictionary *)dictJson{
    //转为json字符串
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dictJson options:0 error:NULL];
    if (dataJson) {
        NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
        return strJson;
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
@end
