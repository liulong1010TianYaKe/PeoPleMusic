//
//  RHRefreshControl.m
//  Example
//
//  Created by Ratha Hin on 2/1/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "RHRefreshControl.h"
#import "RHRefreshControlConfiguration.h"

@interface RHRefreshControl ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView<RHRefreshControlView> *refreshView;

@property (nonatomic, assign) RHRefreshState state;

@end

@implementation RHRefreshControl

#pragma mark --------------------
#pragma mark - CyCLife

- (id)initWithConfiguration:(RHRefreshControlConfiguration *)configuration {
  self = [super init];
  if (self) {
      self.minimumForStart = [configuration.minimumForStart floatValue];
      self.maximumForPull = [configuration.maximumForPull floatValue];
      self.refreshView = configuration.refreshView;
      self.refreshDisplayType = KyoRefreshDisplayTypeDefault;
  }
  
  return self;
}

- (void)dealloc {
    [self removeObserver];
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

- (void)setState:(RHRefreshState)newState {
    
    
    switch (newState) {
        case RHRefreshStateNormal: {
            [self.refreshView updateViewOnNormalStatePreviousState:_state];
        }
            break;
            
        case RHRefreshStateLoading: {
            [self.refreshView updateViewOnLoadingStatePreviousState:_state];
        }
            break;
            
        case RHRefreshStatePulling: {
            [self.refreshView updateViewOnPullingStatePreviousState:_state];
        }
            break;
            
        default:
            break;
    }
    
    _state = newState;
    
}

#pragma mark --------------------
#pragma mark - Methods

- (void)attachToScrollView:(UIScrollView *)scrollView {
    
    self.scrollView = scrollView;
  _tableViewDefaultInsets = scrollView.contentInset;
    if (self.refreshDisplayType == KyoRefreshDisplayTypeDefault) {
        self.refreshView.center = CGPointMake(CGRectGetMidX(scrollView.bounds), -1*(self.maximumForPull - self.minimumForStart) / 2 + _tableViewDefaultInsets.top / 2  + self.refreshViewOffsetY);
    } else if (self.refreshDisplayType == KyoRefreshDisplayTypeTop) {
        CGFloat centerY = -1*(self.maximumForPull - self.minimumForStart) / 2 + _tableViewDefaultInsets.top / 2 -_tableViewDefaultInsets.top  + self.refreshViewOffsetY;
        self.refreshView.center = CGPointMake(CGRectGetMidX(scrollView.bounds), centerY);
    }
//    self.refreshView.frame = CGRectMake(0, -60, 320, 60);
  [scrollView insertSubview:self.refreshView atIndex:0];
    self.canRefresh = YES;
    
    [self addObserver];
}

//手动刷新
- (void)refreshOperation
{
    if (!self.canRefresh) return;
    
    self.scrollView.contentOffset = CGPointMake(0, -self.minimumForStart-self.maximumForPull);
    [self setState:RHRefreshStatePulling];
    [self refreshScrollViewDidScroll:self.scrollView];
    [self refreshScrollViewDidEndDragging:self.scrollView];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0) {  //兼容ios6，让刷新视图在最下，避免在cell上面
        [self.scrollView sendSubviewToBack:self.refreshView];
    }
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canRefresh) return;
  [self updateRefreshViewWithScrollView:scrollView];
  if (self.state == RHRefreshStateLoading) {
      
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset-_tableViewDefaultInsets.top, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset+_tableViewDefaultInsets.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(refreshDataSourceIsLoading:)]) {
			_loading = [_delegate refreshDataSourceIsLoading:self];
		}
        _loading = self.isLoading;
		
		if (self.state == RHRefreshStatePulling && scrollView.contentOffset.y > -(self.maximumForPull + self.minimumForStart) && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:RHRefreshStateNormal];
		} else if (self.state == RHRefreshStateNormal && scrollView.contentOffset.y < -(self.maximumForPull + self.minimumForStart) && !_loading) {
			[self setState:RHRefreshStatePulling];
		}
		
//		if (scrollView.contentInset.top != 0) {
//			scrollView.contentInset = UIEdgeInsetsZero;
//		}
        
        if (scrollView.contentInset.top != _tableViewDefaultInsets.top) {
			scrollView.contentInset = _tableViewDefaultInsets;
		}
		
	}
}

- (void)updateRefreshViewWithScrollView:(UIScrollView *)scrollView {
  if (scrollView.contentOffset.y + self.minimumForStart > 0) return;
  
  // float refreshView on middle of pull disctance...
  
  CGFloat deltaOffsetY = MIN(fabs(scrollView.contentOffset.y + self.minimumForStart ), self.maximumForPull);
  CGFloat percentage = deltaOffsetY/ self.maximumForPull;
  
  CGRect refreshViewFrame = self.refreshView.frame;
  refreshViewFrame.size.height = deltaOffsetY;
  self.refreshView.frame = refreshViewFrame;
    if (self.refreshDisplayType == KyoRefreshDisplayTypeDefault) {
        self.refreshView.center = CGPointMake(CGRectGetMidX(scrollView.bounds), scrollView.contentOffset.y / 2 + _tableViewDefaultInsets.top / 2  + self.refreshViewOffsetY);
    } else if (self.refreshDisplayType == KyoRefreshDisplayTypeTop) {
        CGFloat centerY = scrollView.contentOffset.y / 2 + _tableViewDefaultInsets.top / 2 - _tableViewDefaultInsets.top + self.refreshViewOffsetY;
        self.refreshView.center = CGPointMake(CGRectGetMidX(scrollView.bounds), centerY);
    }
  
  [self.refreshView updateViewWithPercentage:percentage state:self.state];
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (!self.canRefresh) return;
  BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(refreshDataSourceIsLoading:)]) {
		_loading = [_delegate refreshDataSourceIsLoading:self];
	}
    _loading = self.isLoading;
	
//	if (scrollView.contentOffset.y <= -(self.maximumForPull + self.minimumForStart) && !_loading) {
    if (self.state == RHRefreshStatePulling && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(refreshDidTriggerRefresh:)]) {
			[_delegate refreshDidTriggerRefresh:self];
            self.isLoading = YES;
		}
    
		
		[self setState:RHRefreshStateLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.2];
		scrollView.contentInset = UIEdgeInsetsMake((self.maximumForPull + self.minimumForStart)+_tableViewDefaultInsets.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
		[UIView commitAnimations];
		
	}
}

- (void)refreshScrollViewDataSourceDidFinishedLoading {
  [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.scrollView setContentInset:UIEdgeInsetsMake(0.0f+_tableViewDefaultInsets.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right)];
	[UIView commitAnimations];
	
	[self setState:RHRefreshStateNormal];
  if ([self.refreshView respondsToSelector:@selector(updateViewOnComplete)]) {
    [self.refreshView updateViewOnComplete];
  }
    self.isLoading = NO;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0) {  //兼容ios6，让刷新视图在最下，避免在cell上面
        [self.scrollView sendSubviewToBack:self.refreshView];
    }
}

- (void)refreshScrollViewDataSourceDidFinishedLoadingNoAnimation
{
    [self.scrollView setContentInset:UIEdgeInsetsMake(0.0f+_tableViewDefaultInsets.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right)];
    [self setState:RHRefreshStateNormal];
    if ([self.refreshView respondsToSelector:@selector(updateViewOnComplete)]) {
        [self.refreshView updateViewOnComplete];
    }
    self.isLoading = NO;
}

#pragma mark --------------------
#pragma mark - KVO/KVC

- (void)addObserver {
    [self.scrollView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver {
    [self.scrollView removeObserver:self forKeyPath:@"bounds"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
}

#pragma mark ------------------
#pragma mark - KVO/KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"]) {
        if (self.refreshView.frame.size.width != self.scrollView.bounds.size.width) {
            self.refreshView.frame = CGRectMake(0, -60, self.scrollView.bounds.size.width, 60);
            if (self.refreshDisplayType == KyoRefreshDisplayTypeDefault) {
                self.refreshView.center = CGPointMake(CGRectGetMidX(self.scrollView.bounds), -1*(self.maximumForPull - self.minimumForStart) / 2 + _tableViewDefaultInsets.top / 2  + self.refreshViewOffsetY);
            } else if (self.refreshDisplayType == KyoRefreshDisplayTypeTop) {
                CGFloat centerY = -1*(self.maximumForPull - self.minimumForStart) / 2 + _tableViewDefaultInsets.top / 2 - _tableViewDefaultInsets.top  + self.refreshViewOffsetY;
                self.refreshView.center = CGPointMake(CGRectGetMidX(self.scrollView.bounds), centerY);
            }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([self.refreshView respondsToSelector:@selector(reChangeSubViewOrgin)]) {
                [self.refreshView performSelectorOnMainThread:@selector(reChangeSubViewOrgin) withObject:nil waitUntilDone:YES];
            }
#pragma clang diagnostic pop
        }
    } else if ([keyPath isEqualToString:@"contentInset"]) {
        if (self.scrollView.contentInset.top == _tableViewDefaultInsets.top * 2 && self.scrollView.contentInset.top > 0) {  //top是64时触发
            self.scrollView.contentInset = UIEdgeInsetsMake(_tableViewDefaultInsets.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y / 2);
        } else if ( self.scrollView.contentInset.top == _tableViewDefaultInsets.top + 64 && self.scrollView.contentInset.top > 0) { //top是64+。。时触发
            self.scrollView.contentInset = UIEdgeInsetsMake(_tableViewDefaultInsets.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + 64);
        }
    }
}


@end
