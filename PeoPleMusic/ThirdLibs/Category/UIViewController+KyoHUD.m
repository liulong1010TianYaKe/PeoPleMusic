//
//  UIViewController+KyoHUD.m
//  CompanyKind
//
//  Created by Kyo on 8/12/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import "UIViewController+KyoHUD.h"

static char kLoadingInNavigationKey;

@interface UIViewController()

@property (nonatomic, strong)  MBProgressHUD *loadingHUD;

@end

@implementation UIViewController (KyoHUD)

- (NSString *)loadingHUD {
    NSString *hud = objc_getAssociatedObject(self, _cmd);
    return hud;
}

- (void)setLoadingHUD:(MBProgressHUD *)loadingHUD {
    SEL key = @selector(loadingHUD);
    objc_setAssociatedObject(self, key, loadingHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime
{
    [MBProgressHUD showMessageHUD:messageText withTimeInterval:delayTime inView:self.view];
}

- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view
{
    [MBProgressHUD showMessageHUD:messageText withTimeInterval:delayTime inView:view];
}

- (void)showLoadingHUD:(NSString *)labelTextOrNil
{
    [self showLoadingHUD:labelTextOrNil inView:self.view userInteractionEnabled:YES];
}

- (void)showLoadingHUD:(NSString *)labelTextOrNil inView:(UIView *)view userInteractionEnabled:(BOOL)userInteractionEnabled
{
    if (!self.loadingHUD) {
        self.loadingHUD = [[MBProgressHUD alloc] initWithView:view];
        self.loadingHUD.delegate = self;
        self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
        self.loadingHUD.dimBackground = YES;
        [view addSubview:self.loadingHUD];
    }
    
    if (labelTextOrNil.length > 0) {
        self.loadingHUD.labelText = labelTextOrNil;
    }
    
    self.loadingHUD.userInteractionEnabled = userInteractionEnabled;
    
    [self.loadingHUD show:YES];
}

- (void)hideLoadingHUD:(NSTimeInterval)afterTime
{
    [self.loadingHUD hide:YES afterDelay:afterTime];
}

- (void)hideLoadingHUD
{
    [self hideLoadingHUD:0];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (self.loadingHUD) {
        [self.loadingHUD removeFromSuperview];
        self.loadingHUD = nil;
    }else{
        [hud removeFromSuperview];
    }
}

- (void)showLoadingInNavigation {
    if (!self.navigationController) {
        [self showLoadingHUD:nil];
        return;
    }
    
    UIBarButtonItem *barActivity = (UIBarButtonItem *)objc_getAssociatedObject(self, &kLoadingInNavigationKey);
    if (!barActivity) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.hidesWhenStopped = YES;
        activityIndicatorView.center = self.navigationController.navigationBar.center;
        barActivity = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
        
        objc_setAssociatedObject(self, &kLoadingInNavigationKey, barActivity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [(UIActivityIndicatorView *)barActivity.customView startAnimating];
    
    //如果leftbar的最后一项是菊花，直接返回了
    if (self.navigationItem.leftBarButtonItems &&
        self.navigationItem.leftBarButtonItems > 0 &&
        [self.navigationItem.leftBarButtonItems lastObject] == barActivity) {
        return;
    }
    
    //找到navigation的titleview，设置菊花
    NSInteger discante = 6;
    NSInteger currentLeft = 0;  //当前leftbarbuttons的宽度
    if (self.navigationItem.leftBarButtonItems && self.navigationItem.leftBarButtonItems > 0) {
        UIBarButtonItem *barButtonItem = [self.navigationItem.leftBarButtonItems lastObject];
        if (barButtonItem.customView) {
            currentLeft = (barButtonItem.customView.x > 0 ? barButtonItem.customView.x : 11) + barButtonItem.customView.width;
        }
    } else {
        currentLeft = 20;   //默认宽度
    }
    
    //得到titleview
    UIView *titleView = [self findTitleView];
    //得到title的x坐标
    
    NSDictionary *dictTitleTextAttributes = [UINavigationBar appearance].titleTextAttributes;
    UIFont *titleFont = dictTitleTextAttributes[NSFontAttributeName] ? dictTitleTextAttributes[NSFontAttributeName] : [UIFont boldSystemFontOfSize:18.0f];
    NSInteger titleWidth = (KyoSizeWithFont(self.title, titleFont)).width;
    NSInteger titleX = kWindowWidth/2 - titleWidth/2;
    titleX = titleX < titleView.x ? titleX : titleView.x;
    if (titleView) {
        if (currentLeft + 20 + discante < titleX) {  //如果左边宽度＋菊花宽度＋间距还是没超过titileview的x，则可以设置分割线
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
            space.width = titleX - (currentLeft + 20 + discante);
            NSMutableArray *arrayLeftButton = self.navigationItem.leftBarButtonItems ? [self.navigationItem.leftBarButtonItems mutableCopy] : [NSMutableArray array];
            [arrayLeftButton addObject:space];
            [arrayLeftButton addObject:barActivity];
            self.navigationItem.leftBarButtonItems = arrayLeftButton;
        } else if (currentLeft + 20 + discante == titleX) { //如果刚好等于这个距离，则直接添加菊花，不添加分割线
            NSMutableArray *arrayLeftButton = self.navigationItem.leftBarButtonItems ? [self.navigationItem.leftBarButtonItems mutableCopy] : [NSMutableArray array];;
            [arrayLeftButton addObject:barActivity];
            self.navigationItem.leftBarButtonItems = arrayLeftButton;
        } else {    //反之就超过了距离，用正常load
            [self showLoadingHUD:nil];
        }
    } else {
        [self showLoadingHUD:nil];
    }
}

- (void)hideLoadingInNavigation {
    UIBarButtonItem *barActivity = (UIBarButtonItem *)objc_getAssociatedObject(self, &kLoadingInNavigationKey);
    if (barActivity && barActivity.customView) {
        [(UIActivityIndicatorView *)barActivity.customView stopAnimating];
        [self hideLoadingHUD];
    } else {
        [self hideLoadingHUD];
    }
}

- (UIView *)findTitleView {
    for (UIView *subView in self.navigationController.navigationBar.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UINavigationItemView"] ||
            (CGRectContainsPoint(subView.frame, CGPointMake(self.navigationController.navigationBar.bounds.size.width / 2, self.navigationController.navigationBar.bounds.size.height / 2)) && subView.x > 0 && subView.width <= 200)) {  //titleView
            return subView;
        }
    }
    
    return nil;
}

@end
