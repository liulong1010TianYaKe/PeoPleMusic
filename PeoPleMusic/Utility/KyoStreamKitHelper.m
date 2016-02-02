//
//  KyoStreamKitHelper.m
//  PeoPleMusic
//
//  Created by long on 2/2/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "KyoStreamKitHelper.h"

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
 
    _audioPlayer = [[STKAudioPlayer alloc] init];
}

- (void)audioPlayerFromHTTPWith:(NSString *)url{
    [_audioPlayer play:url];
    
}
@end
