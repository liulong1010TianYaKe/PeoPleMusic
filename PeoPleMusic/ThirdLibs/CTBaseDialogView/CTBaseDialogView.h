//
//  CTBaseDialogView.h
//  MulScreen
//
//  Created by lingmin on 12-3-23.
//  Copyright 2012 Shenzhen iDooFly Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kCTBaseDialogViewDefaultShowKeybroadY   50  //在键盘弹出时，键盘会遮住弹出视图时，移动弹出视图到上端，距离顶部的一个距离

typedef NS_ENUM (NSInteger, CTAnimationType){
    CTAnimationTypeNone = 0,
    CTAnimationTypeDownToUp = 1,
    CTAnimationTypeUpToDown = 2,
    CTAnimationTypeStepChange = 3,
    CTAnimationTypeAlphaTo1 = 4,
    CTAnimationTypeAlphaTo0 = 5,
    CTAnimationTypeUnwind = 6,
    CTAnimationTypeOverturn = 7
};

@protocol CTBaseDialogViewDelegate;

@interface CTBaseDialogView : UIView
{
	UIView *overView;// 遮挡层
	UIScrollView *mainView;//添加视图层
	UIDeviceOrientation _orientation;
	BOOL _showingKeyboard;
    CTAnimationType _animationType;
}

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, assign) BOOL isNoReposeWhenBackgroundTouched;
@property (nonatomic, assign) BOOL isNoNeedCloseBtn;
@property (nonatomic, assign) CGRect fromFrame;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) id<CTBaseDialogViewDelegate> baseDialogViewDelegate;

- (id)initWithSubView:(UIView*)subView animation:(CTAnimationType)animationType fromFrame:(CGRect)fromFrame;
- (void)show;
- (void)showTime:(NSTimeInterval)time withAnimation:(CTAnimationType)animationType;
- (void)showWithAnimation:(CTAnimationType)animationType;
- (void)close;
- (void)close:(BOOL)animation;
- (void)close:(BOOL)animation target:(id)target selector:(SEL)selector;

- (void)addTarget:(id)target selector:(SEL)selector;

- (void)animationWithShow;  //在已经显示出来的情况下再次模拟打开时候的动画

@end

@protocol CTBaseDialogViewDelegate <NSObject>

@optional
- (void)ctBaseDialogViewWillClose:(CTBaseDialogView *)baseDialogView;   //准备关闭时触发委托

@end
