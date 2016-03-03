//
//  KyoStreamKitHelper.m
//  PeoPleMusic
//
//  Created by long on 2/2/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "KyoStreamKitHelper.h"

@interface KyoStreamKitHelper ()

@end
@implementation KyoStreamKitHelper

+ (id)share{
    static KyoStreamKitHelper *help = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        help = [[KyoStreamKitHelper alloc] init];
        [help initPlay];
    });
    
  
    return help;
}

- (void)initPlay{

    /*
        flushQueueOnSeek 刷新音频队列
        equalizerBandFrequencies均衡器带频率
        enableVolumeMixer设置为yes,将启用音量控制
     
     */
    _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){
        .flushQueueOnSeek = YES,
        .enableVolumeMixer = YES,
        .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000}
    
    }];
    
    _audioPlayer.volume = 0.5;
    
}


@end
