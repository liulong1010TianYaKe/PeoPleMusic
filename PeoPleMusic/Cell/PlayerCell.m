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
@property (weak, nonatomic) IBOutlet UILabel *lblSongTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblSongerName;

@property (weak, nonatomic) IBOutlet UIImageView *imgDown;
@property (weak, nonatomic) IBOutlet UILabel *lblJbNub;
@property (weak, nonatomic) IBOutlet UIImageView *imgJb;
@property (weak, nonatomic) IBOutlet UILabel *lblSerNumb;
@property (weak, nonatomic) IBOutlet UIView *viewSeg;
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

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(SongInforModel *)model{
    _model = model;
    if (model) {
        self.lblSongTitle.text = model.mediaName;
        self.lblSongerName.text = model.artist;
        self.lblJbNub.text = model.coin;
        self.lblSerNumb.text = model.userId;
        
        if (model.isExtend) {
            self.bottomView.hidden = NO;
            self.imgDown.image = [UIImage imageNamed:@"icon_pull_down"];
        }else{
            self.bottomView.hidden = YES;
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
