//
//  PlayListView.m
//  PeoPleMusic
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "PlayListView.h"


@interface PlayListView ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)btnCancelTouchInside:(id)sender;
@end
@implementation PlayListView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecoginzer:)];
    [self addGestureRecognizer:tapGR];
//    self.tableView.userInteractionEnabled = NO;
}
+ (instancetype)createPlayListViewFromWindow{
    
    PlayListView *playListView = [[[NSBundle mainBundle] loadNibNamed:@"PlayListView" owner:self options:nil] firstObject];
    
    
    return playListView;
}
- (void)tapGestureRecoginzer:(UITapGestureRecognizer *)GR{
    [self close];
}

- (void)show{
    
    if (self == nil) {
        return;
    }
    self.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    [UIView animateWithDuration:1.0f animations:^{
        self.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    }];
    
    
}

- (void)close{
    
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (IBAction)btnCancelTouchInside:(id)sender {
    
    [self close];
}

@end
