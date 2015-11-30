//
//  KyoTableView.m
//  XFLH
//
//  Created by Kyo on 7/18/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoTableView.h"

@implementation KyoTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    // 1.判断下能否接收触摸事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.0) return nil;
    // 2.判断下点在不在控件上
    if ([self pointInside:point withEvent:event] == NO) return nil;
    // 3.从后往前遍历子控件
    int count = (int)self.subviews.count;
    if (kSystemVersionMoreThan8) {
        for (int i = count - 1; i >= 0 ; i--) {
            // 取出显示在最前面的子控件
            UIView *childView =  self.subviews[i];
            // 转换成子控件坐标系上点
            CGPoint childP = [self convertPoint:point toView:childView];
            UIView *fitView = [childView hitTest:childP withEvent:event];
            if (fitView) {
                return fitView;
            }
        }
    } else {
        
        for (int i = 0; i < count; i++) {
            // 取出显示在最前面的子控件
            UIView *childView =  self.subviews[i];
            // 转换成子控件坐标系上点
            CGPoint childP = [self convertPoint:point toView:childView];
            UIView *fitView = [childView hitTest:childP withEvent:event];
            if (fitView) {
                if ([fitView class] != NSClassFromString(@"UITableViewWrapperView") && point.y > 0) {  //如果不是uitableviewwrapperview要做进一步判断，因为滚动后有可能不能获得焦点, point.y>0说明已经点击到cell上面了
                    continue;
                } else {
                    return fitView;
                }
            }
        }
    }
    
    // 表示没有比自己更合适的view
    return self;
}

@end
