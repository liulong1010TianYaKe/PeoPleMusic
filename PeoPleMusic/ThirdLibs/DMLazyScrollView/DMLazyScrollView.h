//
//  DMLazyScrollView.h
//  Lazy Loading UIScrollView for iOS
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 24/11/12.
//  Copyright (c) 2012 http://www.danielemargutti.com. All rights reserved.
//  Distribuited under MIT License
//

#import <UIKit/UIKit.h>

@class DMLazyScrollView;

enum {
    DMLazyScrollViewTransitionAuto      =   0,
    DMLazyScrollViewTransitionForward   =   1,
    DMLazyScrollViewTransitionBackward  =   2
}; typedef NSUInteger DMLazyScrollViewTransition;

@protocol DMLazyScrollViewDelegate <NSObject>
@optional
- (void)lazyScrollViewWillBeginDragging:(DMLazyScrollView *)pagingView;
- (void)lazyScrollViewDidScroll:(DMLazyScrollView *)pagingView at:(CGPoint) visibleOffset;
- (void)lazyScrollViewDidEndDragging:(DMLazyScrollView *)pagingView;
- (void)lazyScrollViewWillBeginDecelerating:(DMLazyScrollView *)pagingView;
- (void)lazyScrollViewDidEndDecelerating:(DMLazyScrollView *)pagingView;


- (NSUInteger)numberOfPagesInLazyScrollView:(DMLazyScrollView *)lazyScrollView;
- (UIView *)lazyScrollView:(DMLazyScrollView *)lazyScrollView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;
- (void)lazyScrollView:(DMLazyScrollView *)lazyScrollView didSelectedIndex:(NSInteger)index;

@end


@interface DMLazyScrollView : UIScrollView

@property (nonatomic, weak)   id<DMLazyScrollViewDelegate>    controlDelegate;

@property (nonatomic,assign)    NSUInteger                      numberOfPages;
@property (readonly)            NSUInteger                      currentPage;
@property (nonatomic, assign) BOOL circulation; //循环，是否从第0页往左滑动到最后一页，最后一页往左到第一页
@property (nonatomic, assign) BOOL movePageDisplayEveryPage;    //在跳页时，是否显示每一页
@property (nonatomic, assign) BOOL openAllReusingView;  //是否所有视图都放入缓存，默认不放入(不放入则不跳页时只有当前页，上一页，下一页为缓存视图)
@property (nonatomic, assign) BOOL alreadyLoadData; //是否已经加载过数据

- (void) initializeControl; //手动初始化

- (void) reloadData;    //刷新所有页
- (void) reloadDataWithIndex:(NSUInteger)index; //刷新并显示index页,会同时刷新前一页后后一页数据

//设置到index页
- (void) setPage:(NSInteger) index animated:(BOOL) animated;
//设置到index页
- (void) setPage:(NSInteger) newIndex transition:(DMLazyScrollViewTransition) transition animated:(BOOL) animated;
//向前＋offset或向后－offset移动 offset页
- (void) moveByPages:(NSInteger) offset animated:(BOOL) animated;
//得到当前已经加载的第index页，如果第index页没加载，返回nil,     只有3也是加载的，当前页，当前页－1，当前页＋1
- (UIView *)pageViewAtIndex:(NSUInteger)index;
//获得第index页，先从新数据获得，如果新数据没有再从旧数据中得到
- (UIView *)pageResuingViewAtIndex:(NSUInteger)index;
//重新加载第index页的数据,只是单纯的重新加载而已
- (void)resetDataWithIndex:(NSUInteger)index;
//清空缓存页面字典
- (void)clearResuingView;
//清空当前页面字典
- (void)clearDisplayView;

- (UIViewController *) visibleViewController;

@end
