//
//  MusicPlayView.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "MusicPlayView.h"
#import "UIView+CTDialog.h"


@interface MusicPlayView ()

@end

@implementation MusicPlayView

- (void)awakeFromNib{
    [super awakeFromNib];
     self.isPlaying = YES;
    
}

- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    if (_isPlaying) {
        [self.btnPlaying setTitle:@"停止" forState:UIControlStateNormal];
    }else{
        [self.btnPlaying setTitle:@"播放" forState:UIControlStateNormal];
    }
}

- (IBAction)btnPreTouchInside:(id)sender {
}

- (IBAction)btnNextTouchInside:(id)sender {
}


- (IBAction)btnPlayingTouchInside:(UIButton *)sender {
   
    self.isPlaying = !self.isPlaying;
}

- (IBAction)btnDianboTouchInside:(id)sender {
    
}

- (IBAction)btnCloseTouchInside:(id)sender {
    
    [self.dialogView close];
}
@end
