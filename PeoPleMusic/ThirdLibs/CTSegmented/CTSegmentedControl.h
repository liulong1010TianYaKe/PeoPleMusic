//
//  CTSegmentedControl.h
//  MulScreenMual
//
//  Created by lingmin on 11-12-27.
//  Copyright 2011 Shenzhen iDooFly Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SegmentedControlAnimationType) {
    SegmentedControlAnimationTypeFade = 0,
    SegmentedControlAnimationTypeMove = 1,
    SegmentedControlAnimationTypeMoveUpDown = 2,
};

typedef NS_ENUM(NSInteger, CurrentDisplayAllow){
    CurrentDisplayAllowNo = 0,
    CurrentDisplayAllowLeft = 1,
    CurrentDisplayAllowRight = 2,
    CurrentDisplayAllowAll = 3
};

@protocol CTSegmentedControlDelegate;

@interface CTSegmentedControl : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *attributedTitles;
@property (nonatomic, strong) NSArray *attributedHightlightTitles;
@property (nonatomic, strong) NSArray *buttonImageIcons;
@property (nonatomic, strong) NSArray *buttonImageSelectedIcons;
@property (nonatomic, strong) UIImage *btnBG;
@property (nonatomic, strong) UIImage *selectedBG;
@property (nonatomic, strong) UIColor *titleColor;  //设置这个后arrayTitlesColor无效
@property (nonatomic, strong) UIColor *selectedTitleColor;  //设置这个后arraySelectedTitlesColor无效
@property (nonatomic, strong) NSArray *arrayTitlesColor;
@property (nonatomic, strong) NSArray *arraySelectedTitlesColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) CGSize btnSize;
@property (nonatomic, weak) id<CTSegmentedControlDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat leftMarage;
@property (nonatomic, assign) CGFloat distance;// 间距
@property (nonatomic, assign) UIEdgeInsets iconInsets;  //按钮图标的edgeinsets，设置后，arrayBtnImageOrientation就无效
@property (nonatomic, assign) UIEdgeInsets titleInsets;  //按钮文字的edgeinsets，设置后，arrayBtnImageOrientation就无效
@property (nonatomic, strong) NSArray *arrayBtnImageOrientation;    //每个按钮image的方向，为空默认左边
@property (nonatomic, strong) NSArray *arrayBtnSize;    //每个按钮的size
@property (nonatomic, assign) NSUInteger orientationType; //0为横向 1为枞向
@property (nonatomic, assign) CGRect validFrame;
@property (nonatomic, assign) CGPoint pointToSelf;//相对于本视图self的点坐标
@property (nonatomic, strong) UIImageView *highlightedBackgroundImageView;
@property (nonatomic, strong) UIImageView *selectedBackgroundImageView;
@property (nonatomic, strong) NSArray *arrayHiddenSelectedBackgroundImageViewIndex;  //需要隐藏背景的selectedimageview的项
@property (nonatomic, assign) BOOL isAutoChangeSelectedBackgroundimageViewWidth;    //是否根据当前项的文字动态改变背景view的宽，默认YES
@property (nonatomic, assign) SegmentedControlAnimationType animationType;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, assign) BOOL isBackGroundImageViewWithIsFull; //backgroundimageview的宽是否满屏，默认yes满屏，如果no，则随着button和distance的宽度决定
@property (nonatomic, strong) UIImage *imgSep;  //分割线

@property (nonatomic, assign) BOOL closeAniamtion;
@property (nonatomic, assign) BOOL enable;

- (void)createButtonWithHadSetAttributedTitles; //创建button（在设置attributeedtitles后才能调用）
-(void)setTitle:(id)object index:(NSInteger)index;





@end

@protocol CTSegmentedControlDelegate<NSObject>

@required
- (void)segmented:(CTSegmentedControl *)segmented selectedIndex:(NSInteger)index;
@optional
- (BOOL)segmented:(CTSegmentedControl *)segmented willSelectedIndex:(NSInteger)index;
- (void)segmented:(CTSegmentedControl *)segmented withCurrentDisplayAllow:(CurrentDisplayAllow)currentDisplayAllow;

@end
