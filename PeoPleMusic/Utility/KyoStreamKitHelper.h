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

@property (nonatomic, strong) STKAudioPlayer *audioPlayer;


+ (id)share;


- (void)audioPlayerFromHTTPWith:(NSString *)url;
@end
