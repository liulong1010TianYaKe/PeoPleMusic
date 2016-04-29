//
//  UIViewController+KyoHUD.h
//  CompanyKind
//
//  Created by Kyo on 8/12/15.
//  Copyright © 2015 zhunit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+Kyo.h"

@interface UIViewController (KyoHUD) <MBProgressHUDDelegate>

// MBProgressHUD
- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime;
- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view;
- (void)showLoadingHUD:(NSString *)labelTextOrNil;
- (void)showLoadingHUD:(NSString *)labelTextOrNil inView:(UIView *)view userInteractionEnabled:(BOOL)userInteractionEnabled;
- (void)hideLoadingHUD;
- (void)showLoadingInNavigation;
- (void)hideLoadingInNavigation;

@end
