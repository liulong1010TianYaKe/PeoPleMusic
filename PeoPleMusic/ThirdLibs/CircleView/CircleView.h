//
//  CircleView.h
//  CAShapeLayerDemo
//
//  Created by apple on 15/9/13.
//  Copyright (c) 2015年 龙-天涯客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property (nonatomic, assign) CGFloat startValue; // 起始值(0-1)
@property (nonatomic, assign) CGFloat lineWidth; // 线宽(>0)
@property (nonatomic, strong) UIColor *lineColor; // 线条颜色
@property (nonatomic,assign) CGFloat value; // 变化值

@end
