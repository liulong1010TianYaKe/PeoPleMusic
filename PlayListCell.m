//
//  PlayListCell.m
//  PeoPleMusic
//
//  Created by apple on 15/12/25.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "PlayListCell.h"


@interface PlayListCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblSonger;

- (IBAction)btnCancelTouchInside:(id)sender;
@end
@implementation PlayListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnCancelTouchInside:(id)sender {
    if (self.cancelOperationBlock) {
        self.cancelOperationBlock();
    }
}
@end
