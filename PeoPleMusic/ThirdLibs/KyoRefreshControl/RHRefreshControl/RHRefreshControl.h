//
//  RHRefreshControl.h
//  Example
//
//  Created by Ratha Hin on 2/1/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHRefreshControlView.h"
#import "RHRefreshControlConfiguration.h"

typedef NS_ENUM(NSInteger, RHRefreshState) {
    RHRefreshStateNormal,
    RHRefreshStatePulling,
    RHRefreshStateLoading
};

@class RHRefreshControlConfiguration;
@protocol RHRefreshControlDelegate;

@interface RHRefreshControl : NSObject

@property (nonatomic, weak) id<RHRefreshControlDelegate> delegate;
@property (nonatomic, assign) UIEdgeInsets tableViewDefaultInsets;   //tableview默认的insets
@property (nonatomic, assign) CGFloat minimumForStart;
@property (nonatomic, assign) CGFloat maximumForPull;
@property (nonatomic, assign) BOOL isLoading;    //是否正在刷新
@property (nonatomic, assign) BOOL canRefresh; //是否能刷新
@property (nonatomic, assign) NSInteger tag;

- (id)initWithConfiguration:(RHRefreshControlConfiguration *)configuration;
- (void)attachToScrollView:(UIScrollView *)scrollView;

- (void)refreshOperation;   //手动刷新

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading;
- (void)refreshScrollViewDataSourceDidFinishedLoadingNoAnimation;

@end


@protocol RHRefreshControlDelegate <NSObject>

- (void)refreshDidTriggerRefresh:(RHRefreshControl *)refreshControl;
@optional
- (BOOL)refreshDataSourceIsLoading:(RHRefreshControl *)refreshControl;

@end
