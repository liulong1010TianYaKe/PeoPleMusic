//
//  MBProgressHUD+Kyo.m
//  CompanyKind
//
//  Created by Kyo on 8/12/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import "MBProgressHUD+Kyo.h"

@implementation MBProgressHUD (Kyo)

static char kMBProgressHUDKey;
static char kMBProgressHUDMessageKey;

+ (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view
{
    MBProgressHUD *HUD = (MBProgressHUD *)objc_getAssociatedObject(view, &kMBProgressHUDMessageKey);
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:HUD];
    }
    
    HUD.labelText = messageText;
    HUD.mode = MBProgressHUDModeText;
    HUD.userInteractionEnabled = NO;
    HUD.removeFromSuperViewOnHide = NO;
    
    [HUD hide:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD show:YES];
        [HUD hide:YES afterDelay:delayTime];
    });
    
    objc_setAssociatedObject(view, &kMBProgressHUDMessageKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)showLoadingHUD:(NSString *)labelTextOrNil inView:(UIView *)view withDelegate:(id<MBProgressHUDDelegate>)delegate userInteractionEnabled:(BOOL)userInteractionEnabled {
    MBProgressHUD *loadingHUD = (MBProgressHUD *)objc_getAssociatedObject(view, &kMBProgressHUDKey);
    if (!loadingHUD) {
        loadingHUD = [[MBProgressHUD alloc] initWithView:view];
        loadingHUD.delegate = delegate;
        loadingHUD.mode = MBProgressHUDModeIndeterminate;
        loadingHUD.dimBackground = YES;
        [view addSubview:loadingHUD];
    }
    
    if (labelTextOrNil.length > 0) {
        loadingHUD.labelText = labelTextOrNil;
    }
    
    loadingHUD.userInteractionEnabled = userInteractionEnabled;
    
    [loadingHUD show:YES];
    
    objc_setAssociatedObject(view, &kMBProgressHUDKey, loadingHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)hideLoadingHUD:(NSTimeInterval)afterTime withView:(UIView *)view
{
    MBProgressHUD *loadingHUD = (MBProgressHUD *)objc_getAssociatedObject(view, &kMBProgressHUDKey);
    [loadingHUD hide:YES afterDelay:afterTime];
}

@end
