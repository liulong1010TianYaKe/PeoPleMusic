//
//  TerminalMusicModel.m
//  PeoPleMusic
//
//  Created by Alen on 16/5/7.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "TerminalMusicModel.h"

@implementation TerminalMusicModel
+ (NSArray *)getSongInfos:(NSArray *)arr{
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (TerminalMusicModel *model in arr) {
        SongInforModel *songInfo = [[SongInforModel alloc] init];
        songInfo.mediaName = model.musicName;
        songInfo.mediaUrl = [model.musicUrl decodeFromPercentEscapeString];
        songInfo.artist = model.musicSing;
        
        [tempArr addObject:songInfo];
    }
    return [NSArray arrayWithArray:tempArr];
}
@end
