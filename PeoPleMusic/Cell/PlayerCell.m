//
//  PlayerCell.m
//  PeoPleMusic
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "PlayerCell.h"

@interface PlayerCell ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lblNumb;
@property (weak, nonatomic) IBOutlet UILabel *lblSongTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblSongerName;

@property (weak, nonatomic) IBOutlet UIImageView *imgDown;
@property (weak, nonatomic) IBOutlet UILabel *lblJbNub;
@property (weak, nonatomic) IBOutlet UIImageView *imgJb;
@property (weak, nonatomic) IBOutlet UILabel *lblSerNumb;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)btnCellTouchInside:(id)sender;

- (IBAction)btnDetailTouchInside:(id)sender;

- (IBAction)btnDeleteTouchInside:(id)sender;
- (IBAction)btnMsgTouchInside:(id)sender;

- (IBAction)btnChaboTouchInside:(id)sender;
@end

@implementation PlayerCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backgroundColor = YYColorRGBA(255, 193, 4,0.6);
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)getPlayCellHeight:(SongModel *)model{
    return model.isExpect ? KPlayerCellHeight + 38 : KPlayerCellHeight;
}

- (void)setModel:(SongModel *)model{
    _model = model;
    if (model) {
        if (model.isExpect) {
            self.bottomView.hidden = NO;
            self.lblNumb.textColor  = YYColor(230, 101, 4);
            self.lblSongerName.textColor = YYColor(230, 101, 4);
            self.lblSongTitle.textColor = YYColor(230, 101, 4);
            self.lblSerNumb.textColor = YYColor(230, 101, 4);
            self.lblJbNub.textColor = YYColor(230, 101, 4);
            self.imgDown.image = [UIImage imageNamed:@"icon_pull_down"];
            
        }else{
            self.bottomView.hidden = YES;
            self.lblNumb.textColor  = [UIColor whiteColor];
            self.lblSongerName.textColor = [UIColor whiteColor];
            self.lblSongTitle.textColor = [UIColor whiteColor];
            self.lblSerNumb.textColor = [UIColor whiteColor];
            self.lblJbNub.textColor = [UIColor whiteColor];
            self.imgDown.image = [UIImage imageNamed:@"icon_pull_up"];
        }
    }
}


- (IBAction)btnCellTouchInside:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerCellTouchInside:withModel:)]) {
        [self.delegate playerCellTouchInside:self withModel:self.model];
    }
}

// 详情
- (IBAction)btnDetailTouchInside:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(playerCellTouchInside:withBtnType:)]) {
        [self.delegate playerCellTouchInside:self withBtnType:PlayerCellBtnTypeDetail];
    }
}

// 删除
- (IBAction)btnDeleteTouchInside:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(playerCellTouchInside:withBtnType:)]) {
        [self.delegate playerCellTouchInside:self withBtnType:PlayerCellBtnTypeDelete];
    }
}

// 留言
- (IBAction)btnMsgTouchInside:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(playerCellTouchInside:withBtnType:)]) {
        [self.delegate playerCellTouchInside:self withBtnType:PlayerCellBtnTypeMsg];
    }
}

//  插播
- (IBAction)btnChaboTouchInside:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(playerCellTouchInside:withBtnType:)]) {
        [self.delegate playerCellTouchInside:self withBtnType:PlayerCellBtnTypeChabo];
    }
}
@end
