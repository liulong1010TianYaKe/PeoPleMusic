//
//  KyoStreamKitHelper.h
//  PeoPleMusic
//
//  Created by long on 2/2/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKAudioPlayer.h"


@interface KyoStreamKitHelper : NSObject


+ (id)share;

@property (nonatomic, strong) STKAudioPlayer *audioPlayer;


// 临时存储当前播放音乐的URL
@property (nonatomic, strong) NSString *currentSource;


@end
