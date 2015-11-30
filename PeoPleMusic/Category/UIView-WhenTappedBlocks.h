//
//  UIView-WhenTappedBlocks.h
//  3wyc
//
//  Created by Yang Gaofeng on 14/10/29.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JMWhenTappedBlock)();

@interface UIView (JMWhenTappedBlocks) <UIGestureRecognizerDelegate>

- (void)whenTapped:(JMWhenTappedBlock)block;
- (void)whenDoubleTapped:(JMWhenTappedBlock)block;
- (void)whenTwoFingerTapped:(JMWhenTappedBlock)block;
- (void)whenTouchedDown:(JMWhenTappedBlock)block;
- (void)whenTouchedUp:(JMWhenTappedBlock)block;

@end
