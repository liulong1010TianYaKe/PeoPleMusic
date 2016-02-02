//
//  ProductTableHeaderView.h
//  MainApp
//
//  Created by long on 1/19/16.
//  Copyright © 2016 hzins. All rights reserved.
//   首页轮播图

#import <UIKit/UIKit.h>

@protocol  ProductTableHeaderViewDelegate;

@interface ProductTableHeaderView : UIView

@property (nonatomic, assign) CGFloat timeInterval;  // 切换图片时间间隔 默认 3s 可选

@property (nonatomic, strong) UIColor* pageControlIndicatorTintColor; // 指示器颜色 默认灰色 可选

@property (nonatomic, strong) UIColor* currentPageColor;  // 当前选择书页颜色 默认白色 可选

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;  //初始化ScrollView 并把需要的图片存在数组穿进来(网络的图片url)

@property (nonatomic,weak)id<ProductTableHeaderViewDelegate> productTableHeaderViewDelegate;

@end

@protocol  ProductTableHeaderViewDelegate <NSObject>

@optional
- (void)productTableHeaderViewTouchInside:(ProductTableHeaderView *)productTableHeaderView withIndex:(NSInteger)index;

@end