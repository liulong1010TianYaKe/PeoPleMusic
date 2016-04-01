//
//  YMTCPClient.m
//  PeoPleMusic
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "YMTCPClient.h"
#import "GCDAsyncSocket.h"


@interface YMTCPClient (){
    NSString *_serverIp;
    NSInteger _serverPort;
    NSString *_cmdType;
}
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;

@property (nonatomic, copy) void (^completionBlock)(NSInteger result,NSDictionary *dict, NSError *err);
@end
@implementation YMTCPClient
+ (instancetype)share{
    
    static YMTCPClient *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[YMTCPClient alloc] init];
        [_shared configurationInit];
    });
    return _shared;
}

- (void)configurationInit{
    dispatch_queue_t client_queue = dispatch_queue_create("client.socked.com", NULL);
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:client_queue];
  
}

- (void)destroySocket{
    
    if (_clientSocket) {
        [_clientSocket disconnect];
        _isConnect = NO;
        _clientSocket = nil;
    }
}

- (void)connectServer:(NSString *)ip port:(long)port{
    
    NSError *err = nil;
    //    92.168.1.112 : 7433
    if([_clientSocket connectToHost:ip onPort:port withTimeout:60  error:&err]){
        KyoLog(@"----连接成功!--");
        _isConnect = YES;
        _serverIp = ip;
        _serverPort = port;
    }else{
        KyoLog(@"----连接失败!--");
        _isConnect = NO;
    }
    
}

#pragma mark -------------------
#pragma mark -  CMDTYPE
/**< 设备注册 */
- (void)networkSendDeviceForRegisterWithCompletionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
      _cmdType = YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK;
     self.completionBlock = completionBlock;
     [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForRegister]dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:0];
   
}
/**
 *  发送获取当前正在播放的歌曲信息
 */
- (void)networkSendCmdForPlaySongInforWithCompletionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO_FEEDBACK;
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForCurrentPlayingSongInfoJson] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**
 *  获取点播列表
 *
 *  @param pageNum  页数
 *  @param pageSize 每页数量
 */
- (void)networkSendBookingSongListWithPageNum:(NSInteger)pageNum withPageSize:(NSInteger)pageSize completionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
     _cmdType = YM_HEAD_CMDTYPE_GET_SONG_LIST_FEEDBACK;
     self.completionBlock = completionBlock;
     [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForBooKingSongListWithpageNum:pageNum withPageSize:pageSize] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**
 *   点播歌曲
 *
 *  @param songInfo 需要点播的歌曲
 *  @param playType 点播的歌曲类型 ，网络 还是音响
 */
- (void)networkSendBookSongInfo:(SongInforModel *)songInfo withPlayType:(NSInteger)playType completionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG_FEEDBACK;
    self.completionBlock = completionBlock;
         [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForBookIngPlaySong:songInfo withPlayType:playType] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
//    self.CompletionBlock = completionBlock;
}

/**< 删除歌曲 */
- (void)networkSendDeleteSongInfo:(SongInforModel *)songInfo withPlayType:(NSInteger)playType completionBlock:(void (^)(NSInteger result,NSDictionary *dict, NSError *err)) completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_DEL_SONG_FEEDBACK;
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForDeleteSongInfo] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**< 11,停止播放 */
- (void)networkSendStopPlaySongInfoWithCompletionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_STOP_PLAYING_FEEDBACK;
    self.completionBlock = completionBlock;
}

/**< 13,配置设备 */
- (void)networkSendSetDeviceWithDeviceinfo:(DeviceInfor *)deviceInfo completionBlock:(void (^)(NSInteger result,NSDictionary *dict, NSError *err)) completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_SET_DEVICE_FEEDBACK;
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForSetDevice:deviceInfo] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**<17.	设置设备音量	 */

-(void)networkSendSetDeviceVolumeWithVolume:(NSInteger )volume completionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock {
    _cmdType = YM_HEAD_CMDTYPE_SET_DEVICE_VOICE_FEEDBACK;
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForSetDeviceVolume:volume] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**<19.	获取音量	 */
- (void)networkSendDeviceForGetDeviceVolumeCompletionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_GET_DEVICE_VOICE;
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForGetDeviceVolume] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**<20.	获取播放状态	 */
- (void)networkSendDeviceForSetDevicePlayStateCompletionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_GET_DEVICE_PLAYSTATE;
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForGetDevicePlayState] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**<21.	设置播放状态	 */
- (void)networkSendDeviceForSetDevicePlayState:(NSInteger)playState completionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_SET_DEVICE_PLAYSTATE;
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForSetDevicePlayState:playState] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}
/**<24.	获取音响本地歌曲目录 */
- (void)networkSendDeviceForSongDirWithCompletionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_GET_DEVICE_SONGSDIR;
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForGetDeviceSongDir] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}
/**<24.	获取音响本地歌曲目录歌曲 */
- (void)networkSendDeviceForSongDirWithRequestKey:(NSString *)requestKey withTotalSize:(NSInteger)totalSize completionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForGetDeviceSongWithRequestKey:requestKey withTotalSize:0] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}
/**<21.设置点播权限	 */
- (void)networkSendDeviceForSetDevicePlayPermission:(NSInteger)permission completionBlock:(void (^)(NSInteger, NSDictionary *, NSError *))completionBlock{
    _cmdType = YM_HEAD_CMDTYPE_SET_DEVICE_PLAYPERMISSION;
    self.completionBlock = completionBlock;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForSetDevicePlayPermission:permission] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}
#pragma mark --


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"---%@",host);
    
    _isConnect = YES;
   
    [_clientSocket readDataWithTimeout:-1 tag:0];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    //    _clientSocket = nil;
    KyoLog(@"断开连接。。。");
    if (self.completionBlock) {
        self.completionBlock(6000, nil, err);
    }
    _isConnect  = NO;
    [_clientSocket connectToHost:_serverIp onPort:_serverPort withTimeout:60  error:&err];
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
        NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSDictionary *dict = [NSDictionary objectWithJSONData:data];
        NSLog(@"----%@",newMessage);
    
    
    NSDictionary *dict = [KyoUtil changeJsonStringToDictionary:newMessage];
    
    NSString *cmdType =  [dict objectForKey:@"cmdType"] ;
    NSInteger result = [[dict objectForKey:@"result"] integerValue];
    
    if ([_cmdType isEqualToString:cmdType]) {
        if (self.completionBlock) {
            self.completionBlock(result,dict,nil);
        }
    }else if ([_cmdType isEqualToString:YM_HEAD_CMDTYPE_UPDATE_BRAODCAST]){ // 接收更新命令
        
           [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_GET_PLAY_SONGINFO_FEEDBACK object:nil];
    }
//    
//    if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK]) { // 注册反馈
//        
//        NSDictionary *tempDict  = [dict objectForKey:@"deviceInfor"];
//        DeviceInfor *deviceInfo =  [DeviceInfor objectWithKeyValues:tempDict];
//        NSLog(@"%@",deviceInfo.wifiName);
    
        
        
//    }else if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO_FEEDBACK]){ // 当前播放歌曲
//        NSDictionary *tempDict = [dict objectForKey:@"songInfor"];
//        SongInforModel *songInfoModle = [SongInforModel objectWithKeyValues:tempDict];
//        [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO_FEEDBACK withData:songInfoModle];
//        [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_GET_PLAY_SONGINFO_FEEDBACK object:nil];
//    }else if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_GET_SONG_LIST_FEEDBACK]){ //获取点播列表反馈
//        SongInfoList *songList = [[SongInfoList alloc] init];
//        songList.pageNumb =  [[dict objectForKey:@"pageNum"] integerValue];
//        songList.total = [[dict objectForKey:@"total"] integerValue];
//        songList.songList  = [SongInfoList objectArrayWithKeyValuesArray:[dict objectForKey:@"songList"]];
        
//        [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_GET_SONG_LIST_FEEDBACK withData:songList];
//        [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_GET_SONG_LIST_FEEDBACK object:nil];
//        NSLog(@"%@",songList);
//    }else if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG_FEEDBACK])  { //点播反馈
//        NSInteger result = [[dict objectForKey:@"result"] integerValue];
//        if (result == 0) {
//            if (self.completionBlock) {
////                self.CompletionBlock(YES, nil);  // 点播成功
//            }
//        }else{
//            if (self.completionBlock) {
////                self.CompletionBlock(NO, nil); // 点播失败
//            }
//        }
//        
//    }
    //    [self addText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,newMessage]];
    [_clientSocket readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}
@end
