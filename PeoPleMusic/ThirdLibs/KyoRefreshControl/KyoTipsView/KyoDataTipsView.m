//
//  KyoDataTipsView.m
//  MainApp
//
//  Created by Kyo on 19/10/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import "KyoDataTipsView.h"

#define kLabelXSpacing  16  //x轴左右间距
#define kLabelYSpacing  16  //y轴上下间距

@interface KyoDataTipsView()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIButton *btnBG;
@property (strong, nonatomic) UIImageView *imgv;
@property (strong, nonatomic) UILabel *lblTips;
@property (strong, nonatomic) UIButton *btnOperation;

@property (strong, nonatomic) NSLayoutConstraint *lcImgvTop;
@property (strong, nonatomic) NSLayoutConstraint *lcImgvWidth;
@property (strong, nonatomic) NSLayoutConstraint *lcImgvHeight;
@property (strong, nonatomic) NSLayoutConstraint *lcLblTipsHeight;
@property (strong, nonatomic) NSLayoutConstraint *lcBtnOperationTop;
@property (strong, nonatomic) NSLayoutConstraint *lcBtnOperationWidth;
@property (strong, nonatomic) NSLayoutConstraint *lcBtnOperationHeight;


- (void)btnBGTouchIn:(UIButton *)btn;
- (void)btnOperationTouchIn:(UIButton *)btn;

- (void)initialize:(UIScrollView *)scrollView;

@end

@implementation KyoDataTipsView

#pragma mark --------------------
#pragma mark - CycLife

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        [self initialize:scrollView];
    }
    
    return self;
}

#pragma mark --------------------
#pragma mark - Settings

- (void)setKyoDataTipsModel:(KyoDataTipsModel *)kyoDataTipsModel {
    _kyoDataTipsModel = kyoDataTipsModel;
    
    if (kyoDataTipsModel) {
        
        self.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        
        CGFloat height = 0;
        
        self.imgv.image = kyoDataTipsModel.img;
        self.lcImgvWidth.constant = kyoDataTipsModel.img.size.width;
        self.lcImgvHeight.constant = kyoDataTipsModel.img.size.height;
        
        height += self.lcImgvHeight.constant;
        height += kLabelYSpacing;
        
        CGSize tipsSize = CGSizeZero;
        self.lblTips.text = nil;
        self.lblTips.attributedText = nil;
        if (kyoDataTipsModel.tip &&
            [kyoDataTipsModel.tip isKindOfClass:[NSString class]]) {
            self.lblTips.text = kyoDataTipsModel.tip;
            tipsSize =  [kyoDataTipsModel.tip boundingRectWithSize:CGSizeMake([[[UIApplication sharedApplication] delegate] window].bounds.size.width - kLabelXSpacing * 2, 1000)
                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.lblTips.font, NSFontAttributeName, nil] context:NULL].size;
        } else if (kyoDataTipsModel.tip &&
                   [kyoDataTipsModel.tip isKindOfClass:[NSAttributedString class]]) {
            self.lblTips.attributedText = kyoDataTipsModel.tip;
            tipsSize = [kyoDataTipsModel.tip boundingRectWithSize:CGSizeMake([[[UIApplication sharedApplication] delegate] window].bounds.size.width - kLabelXSpacing * 2, 1000)
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size;
        }
        self.lcLblTipsHeight.constant = tipsSize.height + 4;
        
        height += tipsSize.height + 4;
        
        if (kyoDataTipsModel.isShowOperationButton) {
            height += kLabelYSpacing;
            
            self.btnOperation.hidden = NO;
            
            if (kyoDataTipsModel.buttonTextColor) {
                [self.btnOperation setTitleColor:kyoDataTipsModel.buttonTextColor forState:UIControlStateNormal];
            }
            
            [self.btnOperation setBackgroundImage:kyoDataTipsModel.imgOperationButtonNormal forState:UIControlStateNormal];
            [self.btnOperation setBackgroundImage:kyoDataTipsModel.imgOperationButtonHighight forState:UIControlStateHighlighted];
            if (kyoDataTipsModel.imgOperationButtonNormal == nil)
            {
                [self.btnOperation setBackgroundColor:kyoDataTipsModel.buttonBackgroundColor];
            }
            if (kyoDataTipsModel && [kyoDataTipsModel.buttonText isKindOfClass:[NSString class]]) {
                [self.btnOperation setTitle:kyoDataTipsModel.buttonText forState:UIControlStateNormal];
            } else if (kyoDataTipsModel && [kyoDataTipsModel.buttonText isKindOfClass:[NSAttributedString class]]) {
                [self.btnOperation setAttributedTitle:kyoDataTipsModel.buttonText forState:UIControlStateNormal];
            }
            self.lcBtnOperationTop.constant = -kyoDataTipsModel.operationButtonTop;
            self.lcBtnOperationWidth.constant = kyoDataTipsModel.operationButtonWidth;
            self.lcBtnOperationHeight.constant = kyoDataTipsModel.operationButtonHeight;
            
            height += kyoDataTipsModel.operationButtonHeight;
        } else {
            self.btnOperation.hidden = YES;
        }
        
        //计算top
        CGFloat top = self.scrollView.frame.size.height / 2.0 - height / 2.0;
        top = top * kyoDataTipsModel.yScale;
        top += kyoDataTipsModel.yOffset;
        top -= (self.scrollViewDefaultInsets.top - self.scrollViewDefaultInsets.bottom);
        self.lcImgvTop.constant = -top;
        
        self.btnBG.hidden = !kyoDataTipsModel.isShowBGButton;
    }
}


#pragma mark --------------------
#pragma mark - Events

- (void)btnBGTouchIn:(UIButton *)btn {
    if (self.kyoDataTipsModel && self.kyoDataTipsModel.reloadDataBlock) {
        self.kyoDataTipsModel.reloadDataBlock();
    }
}

- (void)btnOperationTouchIn:(UIButton *)btn {
    if (self.kyoDataTipsModel && self.kyoDataTipsModel.operationBlock) {
        self.kyoDataTipsModel.operationBlock();
    }
}

#pragma mark --------------------
#pragma mark - Methods

- (void)initialize:(UIScrollView *)scrollView {
    self.scrollView = scrollView;
    self.scrollViewDefaultInsets = scrollView.contentInset;
    self.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    self.alpha = 0;
    [scrollView addSubview:self];
    
    _kyoDataTipsModel = [[KyoDataTipsModel alloc] init];
    
    UIButton *btnBG = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBG.frame = self.bounds;
    [btnBG addTarget:self action:@selector(btnBGTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBG];
    self.btnBG = btnBG;
    
    UIImageView *imgv = [[UIImageView alloc] init];
    [self addSubview:imgv];
    self.imgv = imgv;
    imgv.translatesAutoresizingMaskIntoConstraints = NO;
    self.lcImgvTop = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imgv attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraint:self.lcImgvTop];  //上
    self.lcImgvWidth = [NSLayoutConstraint constraintWithItem:imgv attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self addConstraint:self.lcImgvWidth];  //宽
    self.lcImgvHeight = [NSLayoutConstraint constraintWithItem:imgv attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self addConstraint:self.lcImgvHeight];  //高
    NSLayoutConstraint *lcImgvCenterH = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imgv attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraint:lcImgvCenterH]; //中心x
    
    UILabel *lblTips = [[UILabel alloc] init];
    lblTips.textColor = [UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:1.0];
    lblTips.font = [UIFont systemFontOfSize:12];
    lblTips.textAlignment = NSTextAlignmentCenter;
    lblTips.numberOfLines = 0;
    [self addSubview:lblTips];
    self.lblTips = lblTips;
    lblTips.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *lcLblTipsTop = [NSLayoutConstraint constraintWithItem:imgv attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lblTips attribute:NSLayoutAttributeTop multiplier:1 constant:-kLabelYSpacing];
    [self addConstraint:lcLblTipsTop];  //上
    NSDictionary *dictViews = @{@"subView" : lblTips};
    NSDictionary *dictMetrics = @{@"sep" : @(kLabelXSpacing)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==sep)-[subView]-(==sep)-|" options:0 metrics:dictMetrics views:dictViews]]; //左宽右
    self.lcLblTipsHeight = [NSLayoutConstraint constraintWithItem:lblTips attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self addConstraint:self.lcLblTipsHeight];  //高
    
    UIButton *btnOperation = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOperation addTarget:self action:@selector(btnOperationTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnOperation];
    self.btnOperation = btnOperation;
    btnOperation.translatesAutoresizingMaskIntoConstraints = NO;
    self.lcBtnOperationTop = [NSLayoutConstraint constraintWithItem:self.lblTips attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:btnOperation attribute:NSLayoutAttributeTop multiplier:1 constant:-kLabelYSpacing];
    [self addConstraint:self.lcBtnOperationTop];  //上
    self.lcBtnOperationWidth = [NSLayoutConstraint constraintWithItem:btnOperation attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self addConstraint:self.lcBtnOperationWidth];  //宽
    self.lcBtnOperationHeight = [NSLayoutConstraint constraintWithItem:btnOperation attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self addConstraint:self.lcBtnOperationHeight];  //高
    NSLayoutConstraint *lcBtnOperationCenterH = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:btnOperation attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraint:lcBtnOperationCenterH]; //中心x
}


@end
