//
//  MBProgressHUD+Kyo.h
//  CompanyKind
//
//  Created by Kyo on 8/12/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Kyo)

// MBProgressHUD
+ (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view;
+ (void)showLoadingHUD:(NSString *)labelTextOrNil inView:(UIView *)view withDelegate:(id<MBProgressHUDDelegate>)delegate userInteractionEnabled:(BOOL)userInteractionEnabled;
+ (void)hideLoadingHUD:(NSTimeInterval)afterTime withView:(UIView *)view;

@end
