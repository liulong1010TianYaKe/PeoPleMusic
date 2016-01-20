//
//  LibraryMusicListCell.m
//  PeoPleMusic
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "LibraryMusicListCell.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface LibraryMusicListCell ()


@end
@implementation LibraryMusicListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MusicCategoryModel *)model{
    _model = model;
    if (model) {
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        self.lblTilte.text = model.title;
        self.lblSubTitle.text = model.number;
    }
}

@end
