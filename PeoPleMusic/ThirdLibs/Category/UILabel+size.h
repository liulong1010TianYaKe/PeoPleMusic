//
//  UILabel+size.h
//  MainApp
//
//  Created by long on 15/9/10.
//  Copyright (c) 2015年 zhunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (size)


// 计算UILabel中字符串的高度
- (CGSize)boundingRectWithSize:(CGSize)size;

- (CGSize)contentSize;

@end
