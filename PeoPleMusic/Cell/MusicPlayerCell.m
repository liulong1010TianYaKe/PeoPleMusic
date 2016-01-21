//
//  MusicPlayerCell.m
//  PeoPleMusic
//
//  Created by long on 1/21/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "MusicPlayerCell.h"

@interface MusicPlayerCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblM_Name;
@property (weak, nonatomic) IBOutlet UILabel *lblS_Name;

@end

@implementation MusicPlayerCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOnlineMusicModel:(OnlineMusicModel *)onlineMusicModel{
    _onlineMusicModel = onlineMusicModel;
    if (onlineMusicModel) {
        self.lblM_Name.text = onlineMusicModel.m_name;
        self.lblS_Name.text = onlineMusicModel.s_name;
    }
}
@end
