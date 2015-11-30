//
//  GradeView.h
//  XFLH
//
//  Created by Kyo on 7/19/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface KyoGradeView : UIView

@property (nonatomic) IBInspectable CGFloat numberOfStart; //星星的数量，默认5颗
@property (nonatomic) IBInspectable CGFloat fullScore; //满分，默认10分
@property (nonatomic) IBInspectable CGFloat currentScore;   //当前分，默认0分
@property (nonatomic, strong) IBInspectable UIImage *fullStart;   //满星
@property (nonatomic, strong) IBInspectable UIImage *halfStart;   //半星
@property (nonatomic, strong) IBInspectable UIImage *emptyStart;   //空星

@end
