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
    NSInteger  connectCout;
}
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;

@property (nonatomic, strong) NSMutableString* recvStr;

@property (nonatomic, strong) NSMutableDictionary *cmdDict;

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
    _cmdDict = [NSMutableDictionary dictionary];
  
}

- (void)destroySocket{
    
    if (_clientSocket) {
        [_clientSocket disconnect];
        _isConnect = NO;
        _clientSocket = nil;
    }
}

- (BOOL)connectServer:(NSString *)ip port:(long)port{
    
    connectCout = 0;
    NSError *err = nil;

    _serverIp = ip;
    _serverPort = port;
    
//    return [_clientSocket connectToHost:ip onPort:port error:&err];
    if([_clientSocket connectToHost:_serverIp onPort:port withTimeout:60  error:&err]){
        KyoLog(@"----连接成功!-- %@ %ld",_serverIp,port);
        
        return YES;
    }else{
        KyoLog(@"----连接失败!--%@ %ld",_serverIp,port);
        return NO;
    }
    
}


- (void)getDeviceInfo{
    [[YMTCPClient share] networkSendDeviceForRegister:^(NSInteger result, NSDictionary *dict, NSError *err) {
        if (result == 0) {
            NSDictionary *tempDict  = [dict objectForKey:@"deviceInfor"];
            DeviceInfor *deviceInfo =  [DeviceInfor objectWithKeyValues:tempDict];
            [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK withData:deviceInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];
            
        }
    }];
    
}



- (void)dealloc{
    
}
#pragma mark -------------------
#pragma mark -  CMDTYPE

/**< 设备注册 */
- (void)networkSendDeviceForRegister:(CompletionBlock)completionBlock{
     [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK];
      [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForRegister] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

/**
 *  发送获取当前正在播放的歌曲信息
 */
- (void)networkSendCmdForPlaySongInfor:(CompletionBlock)completionBlock{
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO_FEEDBACK];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForCurrentPlayingSongInfoJson] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}


/**
 *  获取点播列表
 *
 *  @param pageNum  页数
 *  @param pageSize 每页数量
 */
- (void)networkSendBookingSongListWithPageNum:(NSInteger)pageNum withPageSize:(NSInteger)pageSize completionBlock:(CompletionBlock)completionBlock{
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_GET_SONG_LIST_FEEDBACK];

    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForBooKingSongListWithpageNum:pageNum withPageSize:pageSize] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**
 *   点播歌曲
 *
 *  @param songInfo 需要点播的歌曲
 *  @param playType 点播的类型  0 点播  1是更新 2强制更新重复点播
 */
- (void)networkSendBookSongInfo:(SongInforModel *)songInfo withPlayType:(NSInteger)playType completionBlock:(CompletionBlock)completionBlock{
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG_FEEDBACK];
      [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForBookIngPlaySong:songInfo withPlayType:playType] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}


/**< 删除歌曲 */
- (void)networkSendDeleteSongInfo:(SongInforModel *)songInfo completionBlock:(CompletionBlock)completionBlock{
    
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_DEL_SONG_FEEDBACK];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForDeleteSongInfo] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**< 11,停止播放 */
- (void)networkSendStopPlaySongInfo:(CompletionBlock)completionBlock{
     [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_STOP_PLAYING_FEEDBACK];
}

/**< 13,配置设备 */
- (void)networkSendSetDeviceWithDeviceinfo:(DeviceInfor *)deviceInfo completionBlock:(CompletionBlock)completionBlock{
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_SET_DEVICE_FEEDBACK];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForSetDevice:deviceInfo] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**<17.	设置设备音量	 */

-(void)networkSendSetDeviceVolumeWithVolume:(NSInteger )volume completionBlock:(CompletionBlock)completionBlock {
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_SET_DEVICE_VOICE_FEEDBACK];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForSetDeviceVolume:volume] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**<19.	获取音量	 */
- (void)networkSendDeviceForGetDeviceVolume:(CompletionBlock)completionBlock{

    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_GET_DEVICE_VOICE];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForGetDeviceVolume] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**<20.	获取播放状态	 */
- (void)networkSendDeviceForSetDevicePlayState:(CompletionBlock)completionBlock{
  
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_GET_DEVICE_PLAYSTATE];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForGetDevicePlayState] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**<21.	设置播放状态	 */
- (void)networkSendDeviceForSetDevicePlayState:(NSInteger)playState completionBlock:(CompletionBlock)completionBlock{
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_SET_DEVICE_PLAYSTATE];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForSetDevicePlayState:playState] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}
/**<22.	切歌	 */
- (void)networkSendDeviceForSetDevicePlayNextSongCompletionBlock:(CompletionBlock)completionBlock{
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_SET_DEVICE_PLAYSNEXTSONG_FEEDBACK];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForSetDevicePlayNextSong] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}
/**<24.	获取音响本地歌曲目录 */
- (void)networkSendDeviceForSongDir:(CompletionBlock)completionBlock{
  
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_GET_DEVICE_SONGSDIR_FEEDBACK];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForGetDeviceSongDir] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}
/**<24.	获取音响本地歌曲目录歌曲 */
- (void)networkSendDeviceForSonglistWithRequestKey:(NSString *)requestKey withTotalSize:(NSInteger)totalSize completionBlock:(CompletionBlock)completionBlock{
    [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_GET_DEVICE_SONGSDIR_FEEDBACK];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForGetDeviceSongWithRequestKey:requestKey withTotalSize:0] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}
/**<21.设置点播权限	 */
- (void)networkSendDeviceForSetDevicePlayPermission:(NSInteger)permission completionBlock:(CompletionBlock)completionBlock{

  [_cmdDict setObject:completionBlock forKey:YM_HEAD_CMDTYPE_SET_DEVICE_PLAYPERMISSION];
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForSetDevicePlayPermission:permission] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}
#pragma mark --


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"---%@",host);
    
   
    [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_SOCKETDIDCONNECT object:nil];
    [self getDeviceInfo];
    [_clientSocket readDataWithTimeout:-1 tag:0];
    
    
}

- (BOOL)isConnect{
    return _clientSocket.isConnected;
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    //    _clientSocket = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_SOCKETDIDDISCONNECT object:nil];
    KyoLog(@"断开连接。。。");

//    for (CompletionBlock block in _cmdDict) {
//        if (block) {
//            block(6000,nil, err);
//        }
//    }
 
    if (connectCout < 5) {
          KyoLog(@"重新连接。。。%ld",(long)connectCout++);
        if (_serverPort == 9997) {
            _serverPort = 9998;
        }else if(_serverPort == 9998){
            _serverPort = 9997;
        }
     [_clientSocket connectToHost:_serverIp onPort:_serverPort withTimeout:60  error:&err];
    }
   
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
        NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSDictionary *dict = [NSDictionary objectWithJSONData:data];
    NSLog(@"----%@",newMessage);
    
    NSLog(@"--%ld",tag);
    if ([newMessage containsString:@"znt_pkg_end"]) {
        NSInteger pos = [newMessage rangeOfString:@"znt_pkg_end"].location;
//        [newMessage]
        newMessage = [newMessage substringToIndex:pos];
        NSDictionary *dict = [KyoUtil changeJsonStringToDictionary:newMessage];
        if (!dict) {
            [self.recvStr appendString:newMessage];
            dict = [KyoUtil changeJsonStringToDictionary:self.recvStr];
        }
        NSString *cmdType =  [dict objectForKey:@"cmdType"] ;
        NSInteger result = [[dict objectForKey:@"result"] integerValue];
        
        CompletionBlock completionblock =  [_cmdDict objectForKey:cmdType];
        
        if (completionblock) {
            completionblock(result,dict,nil);
        }
        
        if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_UPDATE_BRAODCAST]){ // 接收更新命令
            
            [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_UPDATE_BRAODCAST object:nil];
        }
        
        self.recvStr = nil;
        [_clientSocket readDataWithTimeout:-1 tag:0];
    }else{
        if (!self.recvStr) {
            self.recvStr = [NSMutableString stringWithString:newMessage];
        }else{
            [self.recvStr appendString:newMessage];
        }
         [_clientSocket readDataWithTimeout:-1 tag:tag];
//        NSLog(@"----%@",newMessage);
    }
//    NSLog(@"----------------");
//    NSLog(@"----%@",newMessage);
 
    
   
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}
@end
