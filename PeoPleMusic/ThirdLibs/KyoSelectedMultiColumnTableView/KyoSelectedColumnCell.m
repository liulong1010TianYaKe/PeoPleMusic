//
//  KyoSelectedColumnCell.m
//  YWCat
//
//  Created by Kyo on 3/28/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoSelectedColumnCell.h"

@interface KyoSelectedColumnCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgvSelected;

@end

@implementation KyoSelectedColumnCell

#pragma mark ---------------------------
#pragma mark - CycLife

- (NSString *)reuseIdentifier
{
    return kKyoSelectedColumnCellIdentifier;
}

#pragma mark ---------------------------
#pragma mark - Settings

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    if (selectedColor) {
        if (self.isHadSelected) {
            self.imgvSelected.backgroundColor = selectedColor;
        } else {
            self.imgvSelected.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)setIsHadSelected:(BOOL)isHadSelected {
    _isHadSelected = isHadSelected;
    
    if (isHadSelected) {
        self.imgvArrow.hidden = NO;
        self.lblName.textColor = self.titleSelectedColor;
        self.imgvSelected.backgroundColor = self.selectedColor ? : [UIColor clearColor];
    } else {
        self.imgvArrow.hidden = YES;
        self.lblName.textColor = self.titleColor;
        self.imgvSelected.backgroundColor = [UIColor clearColor];
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    if (font) {
        self.lblName.font = font;
    }
}

//避免手动选择后，被改变背景颜色
- (void)setSelected:(BOOL)selected {}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

@end
