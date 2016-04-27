//
//  BasicsViewController.h
//  KidsBook
//
//  Created by Lukes Lu on 13-9-29.
//  Copyright (c) 2013年 KidsBook Office. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MABasicsViewController.h"

@interface BasicsViewController : MABasicsViewController<
    UIGestureRecognizerDelegate,
    MBProgressHUDDelegate>
{
    NSMutableDictionary *_dictCustomerProperty; //自定义属性值， runtime的 addProperty会添加到这
}

@property (nonatomic, assign) CGRect fromFrame;

@property (nonatomic, assign) CGRect currentKeyBoradRect;
@property (nonatomic, assign) BOOL isBarBugttonCanUserInteractionEnabledWhenAppear;   //是否每次willAppear时barbutton的userinteractionEnabled都变成YES,默认是

- (void)setupView;
- (void)setupData;

//在nav上添加返回按钮
//- (void)addNavBackButtonWithTitle:(NSString *)title;
- (void)reSetBackButtonMethod:(SEL)method;
- (void)reSetBackButtonMethod:(SEL)method withTarget:(id)target;

//pop
- (void)popToInsureDetailOrListOrRootViewController;    //pop到投保详情界面（如果没有则跳转到列表页再没有则跳到root）
- (void)popToViewControllerWithName:(NSString *)viewControllerName; //根据字符串pop到对应的viewcontroller

//title
- (void)addAutoScrollLabelTitle:(NSString *)title;

// MBProgressHUD
- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime;
- (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view;
- (void)showLoadingHUD:(NSString *)labelTextOrNil;
- (void)hideLoadingHUD;
- (void)showLoadingInNavigation;
- (void)hideLoadingInNavigation;


// Keyboard
- (void)addObserversWithKeyboard;
- (void)removeObserversWithKeyboard;
- (void)keyboardWillShow:(NSNotification *) notification;
- (void)keyboardWillHide:(NSNotification *) notification;

// Clear
- (void)clearAllTextField:(UIView *)view;

//改变pagecontrol中圆点样式
- (void)changePageControlImage:(UIPageControl *)pageControl;

//interactivePopGestureRecognizer
- (void)configInteractivePopGestureRecognizer:(BOOL)isNotNil;  //设置viewcontroller的滑动返回是否为空


@end
