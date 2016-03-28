//
//  HeadModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/16.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 命令类型表
 名称	值	说明
 注册	00
 注册反馈	01
 获取播放的歌曲信息	02
 获取播放的歌曲信息反馈	03
 获取点播列表	04
 获取点播列表反馈	05
 点歌	06
 点播反馈	07
 删除歌曲	08
 删除歌曲反馈	09
 更新广播	10
 停止播放	11
 停止播放反馈	12
 设置设备	13
 设置设备反馈	14
 获取设备信息	16
 设置设备音量	17
 设置设备音量反馈	18
 
协议包格式：
头部	类型	内容	状态	尾部
(head)固定（00）	cmdType	content	(result)0,成功；1，失败	(end)固定（11）
 */



#define  YM_HEAD_CMDTYPE_REGISTERED                   @"00"  //注册
#define  YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK          @"01"  //注册反馈
#define  YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO            @"02"  //获取播放的歌曲信息
#define  YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO_FEEDBACK   @"03"  // 获取播放的歌曲信息反馈
#define  YM_HEAD_CMDTYPE_GET_SONG_LIST                @"04"  //获取点播列表
#define  YM_HEAD_CMDTYPE_GET_SONG_LIST_FEEDBACK       @"05"  //获取点播列表反馈
#define  YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG            @"06"  //点歌
#define  YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG_FEEDBACK   @"07"  //点播反馈
#define  YM_HEAD_CMDTYPE_DEL_SONG                     @"08"  //删除歌曲
#define  YM_HEAD_CMDTYPE_DEL_SONG_FEEDBACK            @"09"  //删除歌曲反馈
#define  YM_HEAD_CMDTYPE_UPDATE_BRAODCAST             @"10"  //更新广播
#define  YM_HEAD_CMDTYPE_STOP_PLAYING                 @"11"  //停止播放
#define  YM_HEAD_CMDTYPE_STOP_PLAYING_FEEDBACK        @"12"  //停止播放反馈
#define  YM_HEAD_CMDTYPE_SETING_DEVICE                @"13"  //配置设备
#define  YM_HEAD_CMDTYPE_SET_DEVICE_FEEDBACK         @"14"  //设置设备反馈反馈
#define  YM_HEAD_CMDTYPE_GET_DEVICEINFO               @"16"  //获取设备信息
#define  YM_HEAD_CMDTYPE_SET_DEVICE_VOICE             @"17"  //设置设备音量
#define  YM_HEAD_CMDTYPE_SET_DEVICE_VOICE_FEEDBACK    @"18"  //设置设备音量反馈
#define  YM_HEAD_CMDTYPE_GET_DEVICE_VOICE             @"19"  //	获取播放音量
#define  YM_HEAD_CMDTYPE_GET_DEVICE_PLAYSTATE         @"20"  // 设置播放状态
#define  YM_HEAD_CMDTYPE_SET_DEVICE_PLAYSTATE         @"21"  // 设置播放状态

#define  YM_HEAD_CMDTYPE_SET_DEVICE_PLAYPERMISSION     @"29"  //设置点播权限
@interface HeadModel : NSObject
@property (nonatomic, strong) NSString *head;// 数据包头 00  必须
@property (nonatomic, strong) NSString *end;  //数据包尾  11  必须
@property (nonatomic, strong) NSString *cmdType; //数据包类型 00，发送；01接收 必须
@property (nonatomic, strong) NSString *result; // 只有接收数据包才有 0, 成功；1失败 必须


/**
 *  通过命令cmdstr 组成 协议包头部
 */
+ (NSDictionary *)getJSONHead:(NSString *)cmdStr;

@end
