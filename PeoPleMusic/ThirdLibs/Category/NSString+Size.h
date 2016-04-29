//
//  NSString+Size.h
//  JuMi
//
//  Created by zhunit on 15/8/27.
//  Copyright (c) 2015年 zhunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)boundingRectWithSize:(CGSize)size withFont:(UIFont *)font;


/**
 *  计算字符串在UILabel 的高度
 */

- (CGFloat)contentCellHeightWithText:(NSString *)text withSize:(CGSize)size withFont:(UIFont *)font;

- (long long)fileSize;

- (CGFloat)heightForStringWithfontSize:(float)fontSize andWidth:(float)width;
@end
