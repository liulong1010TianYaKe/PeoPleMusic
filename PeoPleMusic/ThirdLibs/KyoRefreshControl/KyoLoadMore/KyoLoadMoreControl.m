//
//  KyoLoadMoreControl.m
//  Example
//
//  Created by Kyo on 8/13/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "KyoLoadMoreControl.h"

typedef enum
{
    KyoLoadMoreControlStateNone = 0,    //没有加载
    KyoLoadMoreControlStateLoading = 1  //正在加载
} KyoLoadMoreControlState;

@interface KyoLoadMoreControl()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIButton *btnLoadMore;
@property (strong, nonatomic) UILabel *lblNoMore;

@property (assign, nonatomic) BOOL isCanShowNoMore; /**< 是否显示没有更多数据了 */
@property (nonatomic, assign) KyoLoadMoreControlState state;

- (void)btnLoadMoreTouchIn:(UIButton *)btn;

- (void)showOrHideLoadMoreView;
- (void)addObserver;
- (void)removeObserver;
- (void)reChangeFrame;  //重置frame(一般是scrollview变化才调用)

@end

@implementation KyoLoadMoreControl

#pragma mark ---------------
#pragma mark - CycLife

- (void)dealloc {
    [self removeObserver];
}

//初始化，指向scrollview的加载更多
- (id)initWithScrollView:(UIScrollView *)scrollView
{
    return [self initWithScrollView:scrollView withIsCanShowNoMore:NO];
}

- (id)initWithScrollView:(UIScrollView *)scrollView withIsCanShowNoMore:(BOOL)isCanShowNoMore {
    if (!scrollView) {
        return nil;
    }
    
    self = [[KyoLoadMoreControl alloc] init];
    if (self) {
        
        _canLoadMore = YES;
        _isCanShowNoMore = isCanShowNoMore;
        
        self.scrollView = scrollView;
        [self.scrollView addSubview:self];
        if (_isCanShowNoMore) {
            self.defaultInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom + 30, self.scrollView.contentInset.right);
        } else {
            self.defaultInsets = self.scrollView.contentInset;
        }
        self.newInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom + 30, self.scrollView.contentInset.right);
        
        [self addObserver];
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.bounds.size.width, 30);
        self.alpha = 0;
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self.activityView hidesWhenStopped];
//        [self.activityView startAnimating];
        [self addSubview:self.activityView];
        
        self.btnLoadMore = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnLoadMore addTarget:self action:@selector(btnLoadMoreTouchIn:) forControlEvents:UIControlEventTouchUpInside];
        self.btnLoadMore.frame = self.bounds;
        [self.btnLoadMore setBackgroundImage:[UIImage imageNamed:@"btn_blue_moren"] forState:UIControlStateNormal];
        [self.btnLoadMore setBackgroundImage:[UIImage imageNamed:@"btn_blue_gaoliang"] forState:UIControlStateHighlighted];
        NSString *buttonTitle = self.loadMoreButtonTitle ? self.loadMoreButtonTitle : @"查看更多";
        [self.btnLoadMore setTitle:buttonTitle forState:UIControlStateNormal];
        self.btnLoadMore.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.btnLoadMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnLoadMore setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.btnLoadMore setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnLoadMore setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self addSubview:self.btnLoadMore];
        
        self.lblNoMore = [[UILabel alloc] initWithFrame:self.bounds];
        self.lblNoMore.backgroundColor = [UIColor clearColor];
        self.lblNoMore.textColor = [UIColor colorWithRed:(153)/255.0 green:(153)/255.0 blue:(153)/255.0 alpha:1.0];
        self.lblNoMore.font = [UIFont systemFontOfSize:12];
        self.lblNoMore.text = @"没有更多了";
        self.lblNoMore.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblNoMore];
        
        if (self.kyoLoadMoreControlType == KyoLoadMoreControlTypeDefault) {
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
            self.btnLoadMore.hidden = YES;
        } else if (self.kyoLoadMoreControlType == KyoLoadMoreControlTypeManualLoad) {
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            self.btnLoadMore.hidden = NO;
        }
        
    }
    return self;
}

#pragma mark ------------------
#pragma mark - Settings

-(void)setCanLoadMore:(BOOL)canLoadMore
{
    _canLoadMore = canLoadMore;
  
    //直接调用，如果在刷新的话，会和刷新控件有点冲突，导致界面闪烁,所以延迟点
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(showOrHideLoadMoreView) object:nil];
    [self performSelector:@selector(showOrHideLoadMoreView) withObject:nil afterDelay:0.5f];

}

- (void)setNumberOfPage:(NSInteger)numberOfPage
{
    if (_numberOfPage == numberOfPage) {
        return;
    }
    _numberOfPage = numberOfPage;
    
    [self showOrHideLoadMoreView];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    [self showOrHideLoadMoreView];
}

- (void)setKyoLoadMoreControlType:(KyoLoadMoreControlType)kyoLoadMoreControlType
{
    _kyoLoadMoreControlType = kyoLoadMoreControlType;
    
    if (self.kyoLoadMoreControlType == KyoLoadMoreControlTypeDefault) {
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
        self.btnLoadMore.hidden = YES;
    } else if (self.kyoLoadMoreControlType == KyoLoadMoreControlTypeManualLoad) {
        self.activityView.hidden = YES;
        [self.activityView stopAnimating];
        self.btnLoadMore.hidden = NO;
    }
}

- (void)setState:(KyoLoadMoreControlState)state
{
    _state = state;
    
    if (self.kyoLoadMoreControlType == KyoLoadMoreControlTypeManualLoad) {  //如果是手动模式
        if (state == KyoLoadMoreControlStateNone) {
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            self.btnLoadMore.hidden = NO;
        } else if (state == KyoLoadMoreControlStateLoading) {
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
            self.btnLoadMore.hidden = YES;
        }
    }
}

#pragma mark ------------------
#pragma mark - Events

- (void)btnLoadMoreTouchIn:(UIButton *)btn
{
    //加载下一页
    self.state = KyoLoadMoreControlStateLoading;
    if (self.delegate && [self.delegate respondsToSelector:@selector(kyoLoadMoreControl:loadPage:)]) {
        [self.delegate kyoLoadMoreControl:self loadPage:self.currentPage+1];
    }
}

#pragma mark ------------------
#pragma mark - Methods

//显示或隐藏加载更多
- (void)showOrHideLoadMoreView
{
    if (self.canLoadMore) {
        if (self.numberOfPage > self.currentPage+1) {
            self.alpha = 1;
            if (!UIEdgeInsetsEqualToEdgeInsets(self.scrollView.contentInset, self.newInsets)) {
                self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, self.newInsets.bottom, self.scrollView.contentInset.right);
            }
            
            if (self.kyoLoadMoreControlType == KyoLoadMoreControlTypeDefault) {
                self.activityView.hidden = NO;
                [self.activityView startAnimating];
                self.btnLoadMore.hidden = YES;
                self.lblNoMore.hidden = YES;
            } else if (self.kyoLoadMoreControlType == KyoLoadMoreControlTypeManualLoad) {
                self.activityView.hidden = YES;
                [self.activityView stopAnimating];
                self.btnLoadMore.hidden = NO;
                self.lblNoMore.hidden = YES;
            }
            
        } else {
            if (self.numberOfPage > 0 &&
                self.isCanShowNoMore) {
                self.alpha = 1;
                self.activityView.hidden = YES;
                [self.activityView stopAnimating];
                self.btnLoadMore.hidden = YES;
                self.lblNoMore.hidden = NO;
            } else {
                self.alpha = 0;
                if (!UIEdgeInsetsEqualToEdgeInsets(self.scrollView.contentInset, self.defaultInsets)) {
                    self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, self.defaultInsets.bottom, self.scrollView.contentInset.right);
                }
            }
        }
    } else {
        self.alpha = 0;
        if (!UIEdgeInsetsEqualToEdgeInsets(self.scrollView.contentInset, self.defaultInsets)) {
            self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, self.defaultInsets.bottom, self.scrollView.contentInset.right);
        }
    }
}

- (void)addObserver {
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self.scrollView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver {
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"bounds"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
}

//重置frame(一般是scrollview变化才调用)
- (void)reChangeFrame {
    self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.bounds.size.width, 30);
    if (self.activityView) {
        self.activityView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    if (self.btnLoadMore) {
        self.btnLoadMore.frame = self.bounds;
    }
}

//加载完成第index页
- (void)loadCompleteCurrent
{
    if (self.state != KyoLoadMoreControlStateLoading) {
        return;
    }
    
    self.currentPage += 1;
    self.state = KyoLoadMoreControlStateNone;
}

//加载失败第index页
- (void)loadFaultCurrent
{
    if (self.state != KyoLoadMoreControlStateLoading) {
        return;
    }
    
    self.state = KyoLoadMoreControlStateNone;
}

//取消当前正在加载的页
- (void)cancelLoadMore
{
    if (self.state != KyoLoadMoreControlStateLoading) {
        return;
    }
    
    self.state = KyoLoadMoreControlStateNone;
}

#pragma mark ------------------
#pragma mark - KVO/KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.delegate) {
        self.scrollView.delegate = nil;
        return;
    }
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.bounds.size.width, 30);
    } else if ([keyPath isEqualToString:@"contentOffset"]) {
        //如果不能加载或正在加载，跳出
        if (!self.canLoadMore || self.state == KyoLoadMoreControlStateLoading) return;
        //如果总页数小于0或已经是最后一页，跳出
        if (self.numberOfPage <= 0 || self.currentPage+1 >= self.numberOfPage) return;
        //如果没达到加载状态，跳出
        if (self.scrollView.contentOffset.y+self.scrollView.bounds.size.height < self.scrollView.contentSize.height+20) return;
        if (self.scrollView.contentSize.height <= 0) return;
        //如果是手动点击按钮加载更多，跳出
        if (self.kyoLoadMoreControlType == KyoLoadMoreControlTypeManualLoad) return;
        
        //加载下一页
        self.state = KyoLoadMoreControlStateLoading;
        if (self.delegate && [self.delegate respondsToSelector:@selector(kyoLoadMoreControl:loadPage:)]) {
            [self.delegate kyoLoadMoreControl:self loadPage:self.currentPage+1];
        }
    } else if ([keyPath isEqualToString:@"bounds"]) {
        [self reChangeFrame];
    } else if ([keyPath isEqualToString:@"contentInset"]) {
        if (self.scrollView.contentInset.bottom == self.defaultInsets.bottom * 2 && self.scrollView.contentInset.bottom > 0) {
            self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, self.self.defaultInsets.bottom, self.scrollView.contentInset.right);
        }
    }
}

@end
