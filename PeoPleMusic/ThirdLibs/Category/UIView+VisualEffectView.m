//
//  UIView+VisualEffectView.m
//  MainApp
//
//  Created by Kyo on 11/11/15.
//  Copyright © 2015 zhunit. All rights reserved.
//

#import "UIView+VisualEffectView.h"

static char kVisualEffectViewKey;

@implementation UIView (VisualEffectView)

/**< 开启毛玻璃效果 */
- (void)enableVisualEffect {
    //如果是ios8以上，配置毛玻璃效果
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        [self enableVisualEffectWithStyle:UIBlurEffectStyleLight];
    }
}

/**< 开启毛玻璃效果 */
- (void)enableVisualEffectWithStyle:(UIBlurEffectStyle)style {
    //如果是ios8以上，配置毛玻璃效果
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        [self enableVisualEffectWithStyle:style withMaskColor:nil];
    }
}

/**< 开启毛玻璃效果 */
- (void)enableVisualEffectWithStyle:(UIBlurEffectStyle)style withMaskColor:(UIColor *)color {
    //如果是ios8以上，配置毛玻璃效果
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        self.backgroundColor = [UIColor clearColor];
        
        //实现模糊效果
        UIVisualEffectView *visualEffectView = (UIVisualEffectView *)objc_getAssociatedObject(self, &kVisualEffectViewKey);
        if (!visualEffectView) {
            visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
            objc_setAssociatedObject(self, &kVisualEffectViewKey, visualEffectView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        visualEffectView.frame = CGRectMake(0, 0, kWindowWidth, self.frame.size.height);
        visualEffectView.alpha = 1.0;
        [self insertSubview:visualEffectView atIndex:0];
        
        if (color) {
//            UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:style]]];
//            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.frame.size.height)];
//            imgv.backgroundColor = color;
//            [vibrancyView.contentView addSubview:imgv];
//            
//            [visualEffectView.contentView addSubview:vibrancyView];
            
            
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.frame.size.height)];
            imgv.backgroundColor = color;
            
            [visualEffectView.contentView addSubview:imgv];
        }
    }
}

/**< 关闭毛玻璃效果 */
- (void)disableVisualEffect {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        UIVisualEffectView *visualEffectView = (UIVisualEffectView *)objc_getAssociatedObject(self, &kVisualEffectViewKey);
        if (visualEffectView) {
            [visualEffectView removeFromSuperview];
            visualEffectView = nil;
        }
    }
}

@end
