//
//  BasicsView.m
//  KidsBook
//
//  Created by Lukes Lu on 13-9-29.
//  Copyright (c) 2013年 KidsBook Office. All rights reserved.
//

#import "BasicsView.h"


@interface BasicsView ()

@property (nonatomic, strong)  MBProgressHUD *loadingHUD;

@end

@implementation BasicsView

#pragma mark - Memory

- (void)dealloc
{
    KyoLog(@"[%@] dealloc", [self class]);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Lifecycle
- (void)viewDidAppear{}
- (void)viewDidDisappear{}

#pragma mark - Methods

- (void)clear
{
    if (self.loadingHUD) {
        [self.loadingHUD removeFromSuperview];
        self.loadingHUD = nil;
    }
}

#pragma mark - MBProgressHUD

- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime
{
    [KyoUtil showMessageHUD:messageText withTimeInterval:delayTime inView:self];
}

- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view
{
    [KyoUtil showMessageHUD:messageText withTimeInterval:delayTime inView:view];
}

- (void)showLoadingHUD:(NSString *)labelTextOrNil
{
    [self showLoadingHUD:labelTextOrNil inView:self userInteractionEnabled:YES];
}

- (void)showLoadingHUD:(NSString *)labelTextOrNil inView:(UIView *)view userInteractionEnabled:(BOOL)userInteractionEnabled
{
    if (!self.loadingHUD) {
        self.loadingHUD = [[MBProgressHUD alloc] initWithView:view];
        self.loadingHUD.delegate = self;
        self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
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
        [_loadingHUD removeFromSuperview];
        _loadingHUD = nil;
    }else{
        [hud removeFromSuperview];
    }
}

@end
