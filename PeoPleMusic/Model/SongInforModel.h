//
//  SongInforModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/5.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface SongInforModel : NSObject
@property (nonatomic, strong)NSString *albumName; //专辑名称;
@property (nonatomic, strong)NSString *albumUrl; //专辑图片链接
@property (nonatomic, strong)NSString *artist; //艺术家
@property (nonatomic, strong)NSString *coin; // 金币
@property (nonatomic, assign)NSInteger date; //点播时间，长整形
@property (nonatomic, assign)NSInteger duration; // 歌曲播放时长
@property (nonatomic, strong)NSString  *mediaId; //歌曲id
@property (nonatomic, assign)NSInteger mediaSize; //歌曲大小
@property (nonatomic, strong)NSString *mediaType; //歌曲类型  0，手机本地；1，音响本地；2， 网络
@property (nonatomic, strong)NSString *mediaUrl; //歌曲播放链接
@property (nonatomic, strong)NSString *playMsg; //留言信息
@property (nonatomic,strong)UserInfoModel *userInfor;

@end
