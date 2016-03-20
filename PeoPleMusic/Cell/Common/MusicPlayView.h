//
//  MusicPlayView.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayTime;
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)btnPreTouchInside:(id)sender;

- (IBAction)btnNextTouchInside:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPlaying;

- (IBAction)btnPlayingTouchInside:(UIButton *)sender;
- (IBAction)btnDianboTouchInside:(id)sender;
- (IBAction)btnCloseTouchInside:(id)sender;

@property (nonatomic, assign) BOOL isPlaying;

@end
