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
#define YNotificationName_UPDATE_BRAODCAST   @"YNotificationName_UPDATE_BRAODCAST"  //接收更新命令通知


typedef void(^CompletionBlock)(NSInteger result,NSDictionary *dict, NSError *err) ;

@interface YMTCPClient : NSObject

+ (instancetype)share;

- (BOOL)connectServer:(NSString *)ip port:(long)port;
@property (nonatomic, assign) BOOL isConnect;  /**< 是否连接上服务器 */

/**< 0,设备注册 */
- (void)networkSendDeviceForRegister:(CompletionBlock)completionBlock;
/**< 2,发送获取当前正在播放的歌曲信息 */
- (void)networkSendCmdForPlaySongInfor:(CompletionBlock)completionBlock;
 /**<4 获取点播列表 */
- (void)networkSendBookingSongListWithPageNum:(NSInteger)pageNum withPageSize:(NSInteger)pageSize completionBlock:(CompletionBlock)completionBlock;

/**< 6,点播歌曲 */
- (void)networkSendBookSongInfo:(SongInforModel *)songInfo withPlayType:(NSInteger)playType completionBlock:(CompletionBlock)completionBlock;

/**< 8,删除歌曲 */
- (void)networkSendDeleteSongInfo:(SongInforModel *)songInfo  completionBlock:(CompletionBlock)completionBlock;

/**< 11,停止播放 */
- (void)networkSendStopPlaySongInfo:(CompletionBlock)completionBlock;

/**< 13,配置设备 */
- (void)networkSendSetDeviceWithDeviceinfo:(DeviceInfor *)deviceInfo completionBlock:(CompletionBlock)completionBlock;

/**<17.	设置设备音量	 */

-(void)networkSendSetDeviceVolumeWithVolume:(NSInteger )volume completionBlock:(CompletionBlock)completionBlock;
/**<19.	获取音量	 */
- (void)networkSendDeviceForGetDeviceVolume:(CompletionBlock)completionBlock;
/**<20.	获取播放状态	 */
- (void)networkSendDeviceForSetDevicePlayState:(CompletionBlock)completionBlock;
/**<21.	设置播放状态	 */
- (void)networkSendDeviceForSetDevicePlayState:(NSInteger)playState completionBlock:(CompletionBlock)completionBlock;
/**<24.	获取音响本地歌曲目录 */
- (void)networkSendDeviceForSongDir:(CompletionBlock)completionBlock;
/**<24.	获取音响本地歌曲目录歌曲 */
- (void)networkSendDeviceForSonglistWithRequestKey:(NSString *)requestKey withTotalSize:(NSInteger)totalSize completionBlock:(CompletionBlock)completionBlock;
/**<29.设置点播权限	 */
- (void)networkSendDeviceForSetDevicePlayPermission:(NSInteger)permission completionBlock:(CompletionBlock)completionBlock;
@end
