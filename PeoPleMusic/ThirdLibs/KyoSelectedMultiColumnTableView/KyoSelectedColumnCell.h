//
//  KyoSelectedColumnCell.h
//  YWCat
//
//  Created by Kyo on 3/28/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kKyoSelectedColumnCellIdentifier    @"kKyoSelectedColumnCellIdentifier"
#define kKyoSelectedColumnCellHeight    44

@interface KyoSelectedColumnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgvArrow;

@property (assign, nonatomic) BOOL isHadSelected;  /**< 是否选中 */
@property (nonatomic, strong) UIColor *selectedColor;   /**< 选中或高亮的背景颜色 */
@property (strong, nonatomic) UIColor *titleColor;  /**< 标题正常颜色 */
@property (strong, nonatomic) UIColor *titleSelectedColor;  /**< 标题选中的颜色 */
@property (strong, nonatomic) UIFont *font;

@end
