//
//  BasicsView.h
//  KidsBook
//
//  Created by Lukes Lu on 13-9-29.
//  Copyright (c) 2013年 KidsBook Office. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BasicsView : UIView<MBProgressHUDDelegate>
{
    NSMutableDictionary *_dictCustomerProperty; //自定义属性值， runtime的 addProperty会添加到这
}

//appear
- (void)viewDidAppear;
- (void)viewDidDisappear;

// MBProgressHUD
- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime;
- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view;
- (void)showLoadingHUD:(NSString *)labelTextOrNil;
- (void)showLoadingHUD:(NSString *)labelTextOrNil inView:(UIView *)view userInteractionEnabled:(BOOL)userInteractionEnabled;
- (void)hideLoadingHUD;

// Clear
- (void)clear;

@end
