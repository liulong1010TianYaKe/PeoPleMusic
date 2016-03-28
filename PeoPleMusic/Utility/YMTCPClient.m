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
}
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;

@property (nonatomic, copy) void (^CompletionBlock)(BOOL, NSError *);
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
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
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
    if([_clientSocket connectToHost:ip onPort:port error:&err]){
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
/**
 *  发送获取当前正在播放的歌曲信息
 */
- (void)sendCmdForPlaySongInfo{
    
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForCurrentPlayingSongInfoJson] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**
 *  获取点播列表
 *
 *  @param pageNum  页数
 *  @param pageSize 每页数量
 */
- (void)getBookingSongListWithPageNum:(NSInteger)pageNum withPageSize:(NSInteger)pageSize{
     [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForBooKingSongListWithpageNum:pageNum withPageSize:pageSize] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
}

/**
 *   点播歌曲
 *
 *  @param songInfo 需要点播的歌曲
 *  @param playType 点播的歌曲类型 ，网络 还是音响
 */
- (void)sendBookSongInfo:(SongInforModel *)songInfo withPlayType:(NSInteger)playType completionBlock:(void (^)(BOOL, NSError *))completionBlock{
         [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForBookIngPlaySong:songInfo withPlayType:playType] dataUsingEncoding:NSUTF8StringEncoding]   withTimeout:-1 tag:0];
    self.CompletionBlock = completionBlock;
}
#pragma mark --


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"---%@",host);
    
    _isConnect = YES;
    [_clientSocket writeData:[[PublicNetwork sendDeviceJsonForRegister]dataUsingEncoding:NSUTF8StringEncoding]  withTimeout:-1 tag:0];
    [_clientSocket readDataWithTimeout:-1 tag:0];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    //    _clientSocket = nil;
    KyoLog(@"断开连接。。。");
    if (self.CompletionBlock) {
        self.CompletionBlock(NO, err);
    }
    _isConnect  = NO;
    [_clientSocket connectToHost:_serverIp onPort:_serverPort error:&err];
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
        NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSDictionary *dict = [NSDictionary objectWithJSONData:data];
        NSLog(@"----%@",newMessage);
    NSDictionary *dict = [KyoUtil changeJsonStringToDictionary:newMessage];
    NSString *cmdType =  [dict objectForKey:@"cmdType"] ;
    
    if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK]) { // 注册反馈
        
        NSDictionary *tempDict  = [dict objectForKey:@"deviceInfor"];
        DeviceInfor *deviceInfo =  [DeviceInfor objectWithKeyValues:tempDict];
        NSLog(@"%@",deviceInfo.wifiName);
        [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK withData:deviceInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];
        
        
    }else if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO_FEEDBACK]){ // 当前播放歌曲
        NSDictionary *tempDict = [dict objectForKey:@"songInfor"];
        SongInforModel *songInfoModle = [SongInforModel objectWithKeyValues:tempDict];
        [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO_FEEDBACK withData:songInfoModle];
        [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_GET_PLAY_SONGINFO_FEEDBACK object:nil];
    }else if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_GET_SONG_LIST_FEEDBACK]){ //获取点播列表反馈
        SongInfoList *songList = [[SongInfoList alloc] init];
        songList.pageNumb =  [[dict objectForKey:@"pageNum"] integerValue];
        songList.total = [[dict objectForKey:@"total"] integerValue];
        songList.songList  = [SongInfoList objectArrayWithKeyValuesArray:[dict objectForKey:@"songList"]];
        
        [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_GET_SONG_LIST_FEEDBACK withData:songList];
        [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_GET_SONG_LIST_FEEDBACK object:nil];
        NSLog(@"%@",songList);
    }else if ([cmdType isEqualToString:YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG_FEEDBACK])  { //点播反馈
        NSInteger result = [[dict objectForKey:@"result"] integerValue];
        if (result == 0) {
            if (self.CompletionBlock) {
                self.CompletionBlock(YES, nil);  // 点播成功
            }
        }else{
            if (self.CompletionBlock) {
                self.CompletionBlock(NO, nil); // 点播失败
            }
        }
        
    }
    //    [self addText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,newMessage]];
    [_clientSocket readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}
@end
