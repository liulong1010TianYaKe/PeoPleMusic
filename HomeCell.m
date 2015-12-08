//
//  HomeCell.mho
//  PeoPleMusic
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 long. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *smallTitle;

@end

@implementation HomeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    if (self.model.blockOperation) {
//        self.model.blockOperation();
//    }
}

- (void)setModel:(HomeModel *)model{
    
    _model = model;
    if (model) {
        self.imgIcon.image = [UIImage imageNamed:model.imgIcon];
        self.lblTitle.text = model.title;
        self.smallTitle.text = model.subTitle;
        if (model.subtitleColor) {
            self.smallTitle.textColor = model.subtitleColor;
        }
    }
}


@end
