//
//  MusicPlayView.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongInforModel.h"

@interface MusicPlayView : UIView

@property (nonatomic, assign) MusiclistViewStyle type;
- (IBAction)btnPreTouchInside:(id)sender;

- (IBAction)btnNextTouchInside:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPlaying;

- (IBAction)btnPlayingTouchInside:(UIButton *)sender;
- (IBAction)btnDianboTouchInside:(id)sender;
- (IBAction)btnCloseTouchInside:(id)sender;

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSArray *songlist;
@property(nonatomic,assign)NSInteger indexRow;


@end
