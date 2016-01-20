//
//  LibraryMusiceCellTableViewCell.m
//  PeoPleMusic
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "LibraryMusiceCellTableViewCell.h"

@interface LibraryMusiceCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@end

@implementation LibraryMusiceCellTableViewCell

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
        self.lblTitle.text = model.title;
    }
}

@end
