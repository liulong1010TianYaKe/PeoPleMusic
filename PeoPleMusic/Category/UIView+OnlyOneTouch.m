//
//  UIView+OnlyOneTouch.m
//  KidsBook
//
//  Created by Lukes Lu on 11/14/13.
//  Copyright (c) 2013 KidsBook Office. All rights reserved.
//

#import "UIView+OnlyOneTouch.h"

@implementation UIView (OnlyOneTouch)

#pragma mark - Methods

- (void)onlyOneTouch
{
    [self addTargetEvent:self];
}

- (void)addTargetEvent:(UIView *)view
{
    for (int i = 0; i < view.subviews.count; i++) {
        UIView *subview = [view.subviews objectAtIndex:i];
        if ([subview isKindOfClass:[UIButton class]] ||
            [subview isMemberOfClass:[UIButton class]]) {
            [(UIButton *)subview addTarget:self action:@selector(whenBtnTouchin:) forControlEvents:UIControlEventTouchDown];
        } else if ([subview isKindOfClass:[UIView class]]){
            [self addTargetEvent:subview];
        }
    }
}

- (void)whenBtnTouchin:(UIButton *)btn
{
    [self cancelEvent:self withBtn:btn];
}

- (void)cancelEvent:(UIView *)view withBtn:(UIButton *)focusBtn
{
    for (int i = 0; i < view.subviews.count; i++) {
        UIView *subview = [view.subviews objectAtIndex:i];
        if ([subview isKindOfClass:[UIButton class]] ||
            [subview isMemberOfClass:[UIButton class]]) {
            UIButton *tempBtn = (UIButton *)subview;
            if (tempBtn != focusBtn && tempBtn.state == UIControlEventTouchDown) {
                [tempBtn cancelTrackingWithEvent:nil];
            }
        }else if ([subview isKindOfClass:[UIView class]]){
            [self cancelEvent:subview withBtn:focusBtn];
        }
    }
}

@end
