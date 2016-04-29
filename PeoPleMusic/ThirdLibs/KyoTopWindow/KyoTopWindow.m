//
//  KyoTopWindow.m
//  MainApp
//
//  Created by Kyo on 9/9/15.
//  Copyright (c) 2015 zhunit. All rights reserved.
//

#import "KyoTopWindow.h"

@interface KyoTopWindow()

@end

@implementation KyoTopWindow

static UIWindow *_window;

#pragma mark --------------------
#pragma mark - CycLife

+ (void)initialize {
    _window = [[UIWindow alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 9.0) {
        _window.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
    } else {
        _window.frame = CGRectMake(100, 0, [UIScreen mainScreen].bounds.size.width - 100, 20);  //留下返回。。应用的位子
    }
    _window.windowLevel = UIWindowLevelAlert;
    _window.backgroundColor = [UIColor clearColor];
    [_window addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
}

#pragma mark --------------------
#pragma mark - Methods

+ (void)show {
    _window.hidden = NO;
}
+ (void)hide {
    _window.hidden = YES;
}

// 监听窗口点击
+ (void)windowClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superview {
    for (UIScrollView *subview in superview.subviews) {
        // 如果是scrollview, 滚动最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && [KyoTopWindow isShowingOnKeyWindow:subview]) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        // 递归继续查找子控件
        [self searchScrollViewInView:subview];
    }
}

+ (BOOL)isShowingOnKeyWindow:(UIView *)view {
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:view.frame fromView:view.superview];
    CGRect winBounds = keyWindow.bounds;
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    return !view.isHidden && view.alpha > 0.01 && view.window == keyWindow && intersects;
}

@end
