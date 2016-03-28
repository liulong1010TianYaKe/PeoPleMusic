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

#define YNotificationName_SOCKETDIDCONNECT @"YNotificationName_SOCKETDIDCONNECT"  //连接上服务器
#define YNotificationName_SOCKETDIDDISCONNECT @"YNotificationName_SOCKETDIDDISCONNECT"  //服务器断连

#define YNotificationName_CMDTYPE_REGISTERED_FEEDBACK   @"YNotificationName_CMDTYPE_REGISTERED_FEEDBACK"  //获册反馈通知
#define YNotificationName_GET_PLAY_SONGINFO_FEEDBACK   @"YNotificationName_GET_PLAY_SONGINFO_FEEDBACK"  //获取播放的歌曲信
#define YNotificationName_GET_SONG_LIST_FEEDBACK   @"YNotificationName_GET_SONG_LIST_FEEDBACK"  //获取点播列表反馈


@interface YMTCPClient : NSObject

+ (instancetype)share;

- (void)connectServer:(NSString *)ip port:(long)port;
@property (nonatomic, assign) BOOL isConnect;  /**< 是否连接上服务器 */

- (void)sendCmdForPlaySongInfo; /**< 发送获取当前正在播放的歌曲信息 */

- (void)getBookingSongListWithPageNum:(NSInteger)pageNum withPageSize:(NSInteger)pageSize; /**< 获取点播列表 */

- (void)sendBookSongInfo:(SongInforModel *)songInfo withPlayType:(NSInteger)playType completionBlock:(void(^)(BOOL success,NSError *err))completionBlock; /**< 点播歌曲 */

@end
