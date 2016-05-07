//
//  TerminalMusicModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/5/7.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongInforModel.h"

@interface TerminalMusicModel : NSObject
@property ( nonatomic, strong) NSString *Id;
@property ( nonatomic, strong) NSString *addTime;
@property ( nonatomic, strong) NSString *musicAuther;
@property ( nonatomic, strong) NSString *musicDuration;
@property ( nonatomic, strong) NSString *musicId ;
@property ( nonatomic, strong) NSString *musicName ;
@property ( nonatomic, strong) NSString *musicSing;
@property ( nonatomic, strong) NSString *musicUrl ;
@property ( nonatomic, strong) NSString *status ;
@property ( nonatomic, strong) NSString *terminalId;

+ (NSArray *)getSongInfos:(NSArray *)arr;

@end
