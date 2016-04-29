//
//  UIImage-RoundCorner.h
//  SwapApp
//
//  Created by Yang Gaofeng on 14-9-23.
//  Copyright (c) 2014年 zhunit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (RoundCorner)
///裁剪成圆形
- (UIImage*)imageWithRadius:(float)radius
                      width:(float)width
                     height:(float)height;
- (UIImage*)imageWithTopRadius:(float)radius
                         width:(float)width
                        height:(float)height;
- (UIImage*)imageWithBottomRadius:(float)radius
                            width:(float)width
                           height:(float)height;
- (UIImage*)imageWithLeftRadius:(float)radius
                          width:(float)width
                         height:(float)height;
- (UIImage*)imageWithRightRadius:(float)radius
                           width:(float)width
                          height:(float)height;
- (UIImage*)resizeImageWithNewSize:(CGSize)newSize;
-(UIImage *)imageWithShadow:(UIColor*)_shadowColor
                 shadowSize:(CGSize)_shadowSize
                       blur:(CGFloat)_blur;
///裁剪成方形
- (UIImage *)imageWithWidth:(CGFloat)width height:(CGFloat)height startPoint:(CGPoint)point;
@end
