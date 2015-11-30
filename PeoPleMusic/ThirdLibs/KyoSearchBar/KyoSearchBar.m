//
//  CSearchBar.m
//  EasyReimburse
//
//  Created by darklinden on 14-4-26.
//  Copyright (c) 2015年 Kyo. All rights reserved.
//

#import "KyoSearchBar.h"

@interface KyoSearchBar()
@property (nonatomic, strong) UIImage *imgVoice;
@end

@implementation KyoSearchBar

- (void)dealloc
{
    NSArray *subViews;
    subViews = [(self.subviews[0]) subviews];
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            
            [textField removeObserver:self forKeyPath:@"rightView"];
            break;
        }
    }
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initConfig];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self performSelector:@selector(initConfig) withObject:nil afterDelay:.0f]; //  界面刷新之后再调用该方法
        
    }
    return self;
}

#pragma mark -------------
#pragma mark - Settings

- (void)setShowsSearchResultsButton:(BOOL)showsSearchResultsButton
{
//    KyoLog(@"12342");
    [super setShowsSearchResultsButton:showsSearchResultsButton];
}

- (void)setImgVoice:(UIImage *)imgVoice
{
    _imgVoice = imgVoice;
    
    if (imgVoice) {
        
        NSArray *subViews;
        subViews = [(self.subviews[0]) subviews];
        
        for (id view in subViews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)view;
                
                if (!textField.rightView) {
                    return;
                }
                
                UIButton *button = (UIButton *)textField.rightView;
#ifdef _DEBUG
                CGRect r = button.frame;
                r.origin.x = r.origin.x - 150;
                button.frame = r;
#endif
                
                [button setImage:self.imgVoice forState:UIControlStateNormal];
                [button setImage:self.imgVoice forState:UIControlStateHighlighted];
                [button setImage:self.imgVoice forState:UIControlStateNormal | UIControlStateSelected];
                [button setImage:self.imgVoice forState:UIControlStateHighlighted | UIControlStateSelected];
                [button setImage:self.imgVoice forState: UIControlStateSelected];
                
                break;
            }
        }
        
    }
}

#pragma makr -----------
#pragma mark - Methods

- (void)initConfig {

    self.imgVoice = [UIImage imageNamed:@"com_icon_yuyinhuatong"];
    
    NSArray *subViews;
    subViews = [(self.subviews[0]) subviews];
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            
            [textField addObserver:self forKeyPath:@"rightView" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
            break;
        }
    }
}

#pragma makr -----------
#pragma mark - KVO/KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.imgVoice) {
        UITextField *textField = (UITextField *)object;
        if (!textField.rightView) {
            return;
        }
        
        UIButton *button = (UIButton *)textField.rightView;
#ifdef _DEBUG
        CGRect r = button.frame;
        r.origin.x = r.origin.x - 150;
        button.frame = r;
#endif
        [button setImage:self.imgVoice forState:UIControlStateNormal];
        [button setImage:self.imgVoice forState:UIControlStateHighlighted];
        [button setImage:self.imgVoice forState:UIControlStateNormal | UIControlStateSelected];
        [button setImage:self.imgVoice forState:UIControlStateHighlighted | UIControlStateSelected];
        [button setImage:self.imgVoice forState: UIControlStateSelected];
//        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


-(void)btnClick:(UIButton *)sender
{
    KyoLog(@"123XXXX");
}
@end
