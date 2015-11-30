//
//  DMLazyScrollView.m
//  Lazy Loading UIScrollView for iOS
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 24/11/12.
//  Copyright (c) 2012 http://www.danielemargutti.com. All rights reserved.
//  Distribuited under MIT License
//

#import "DMLazyScrollView.h"

#define kDMLazyScrollViewTransitionDuration     0.4f

@interface DMLazyScrollView() <UIScrollViewDelegate> {
    NSUInteger      numberOfPages;
    NSUInteger      currentPage;
    BOOL            isManualAnimating;
    
    BOOL _reloadData;
    NSMutableDictionary *_dictDisplayView;  //现在展示的视图页面
    NSMutableDictionary *_dictReusingView;  //旧视图页
}

@end

@implementation DMLazyScrollView

@synthesize numberOfPages,currentPage;
@synthesize controlDelegate;

- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControl];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeControl];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiveMemoryWarningNotification:(NSNotification *)notification
{
    [self clearResuingView];
}

- (void) awakeFromNib {
    
    [self initializeControl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void) initializeControl
{
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.delegate = self;
    self.circulation = YES; //默认循环
    self.movePageDisplayEveryPage = NO; //默认跳页不每页都显示
    self.alreadyLoadData = NO;
    
    currentPage = 0;
    if (_dictReusingView) {
        [self clearResuingView];
    }
    
    if (_dictDisplayView) {
        [self clearDisplayView];
    }
    
    _dictReusingView = [NSMutableDictionary dictionary];
    _dictDisplayView = [NSMutableDictionary dictionary];
}

- (UIView *)viewWithTag:(NSInteger)tag
{
    UIView *view = [super viewWithTag:tag];
    
    if (view) {
        return view;
    } else {
        
        for (UIView *view in _dictReusingView.allValues) {
            if (view.tag == tag) {
                return view;
            }
        }
        
        for (UIView *view in _dictDisplayView.allValues) {
            if (view.tag == tag) {
                return view;
            }
        }
    }
    
    return nil;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.contentSize = CGSizeMake(self.contentSize.width, self.frame.size.height);
}

- (void) setNumberOfPages:(NSUInteger)pages {
    if (pages != numberOfPages) {
        numberOfPages = pages;   
//        [self reloadData];
    }
}

- (void) reloadData
{
    [self reloadDataWithIndex:0];
}

- (void)reloadDataWithIndex:(NSUInteger)index
{
    if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(numberOfPagesInLazyScrollView:)]) {
        self.numberOfPages = [self.controlDelegate numberOfPagesInLazyScrollView:self];
    }
    if (self.numberOfPages > 0) {   //如果总页面大于0，可以重新加载
        
        self.alreadyLoadData = YES; //标记已经加载过数据
        _reloadData = YES;
        [self setCurrentViewController:@(index)];
        
    } else if (_dictDisplayView && _dictDisplayView.allKeys.count > 0) {    //反之如果当前显示有视图，则清空掉
        for (int i = 0; i < _dictDisplayView.allKeys.count; i++) {
            id key = [_dictDisplayView.allKeys objectAtIndex:i];
            UIView *reusingView = [_dictDisplayView objectForKey:key];
            [reusingView removeFromSuperview];
            [_dictReusingView setObject:reusingView forKey:key];
        }
        [_dictDisplayView removeAllObjects];
        
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
}

- (CGRect) visibleRect {
    CGRect visibleRect;
    visibleRect.origin = self.contentOffset;
    visibleRect.size = self.bounds.size;
    return visibleRect;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isManualAnimating) return;
    
    // with two pages only scrollview you can only go forward
    // (this prevents us to have a glitch with the next UIView (it can't be placed in two positions at the same time)
//    if (self.numberOfPages == 2 && scrollView.contentOffset.x <= (self.frame.size.width))
//        [self setContentOffset: CGPointMake((self.frame.size.width), 0)];
//    NSInteger newPageIndex = currentPage;
//    NSLog(@"----------%f-------",scrollView.contentOffset.x);
//    if (scrollView.contentOffset.x <= 0)
//    {
//        newPageIndex = [self pageIndexByAdding:-1 from:currentPage];
//    }
//    else if (scrollView.contentOffset.x >= (self.frame.size.width*2))
//        newPageIndex = [self pageIndexByAdding:+1 from:currentPage];
//    
//    [self setCurrentViewController:newPageIndex];
    
    NSInteger newPageIndex = currentPage;
    //如果不是轮回
    if (!self.circulation)
    {
        if (self.numberOfPages == 2) {
            if (self.currentPage == 0 && scrollView.contentOffset.x >= self.frame.size.width) {
                [self setContentOffset: CGPointMake(self.frame.size.width, 0)];
                currentPage++;
                if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(lazyScrollView:didSelectedIndex:)]) {
                    [self.controlDelegate lazyScrollView:self didSelectedIndex:currentPage];
                }
                return;
            } else if (self.currentPage == self.numberOfPages - 1 && scrollView.contentOffset.x <= 0) {
                [self setContentOffset: CGPointMake(0, 0)];
                currentPage--;
                if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(lazyScrollView:didSelectedIndex:)]) {
                    [self.controlDelegate lazyScrollView:self didSelectedIndex:currentPage];
                }
                return;
            }
        } else if (self.numberOfPages > 2) {
            if (self.currentPage == 0 && scrollView.contentOffset.x >= self.frame.size.width) {
                [self setContentOffset: CGPointMake(self.frame.size.width, 0)];
                newPageIndex++;
            } else if (self.currentPage == self.numberOfPages - 1 && scrollView.contentOffset.x <= 0) {
                [self setContentOffset: CGPointMake(0, 0)];
                newPageIndex--;
            } else if (scrollView.contentOffset.x >= self.frame.size.width * 2) {
                newPageIndex++;
            } else if (scrollView.contentOffset.x <= 0 && self.currentPage != 0) {
                newPageIndex--;
            }
        }
    } else {
        if (scrollView.contentOffset.x <= 0) {
            newPageIndex = [self pageIndexByAdding:-1 from:currentPage];
            [self setContentOffset: CGPointMake(0, 0)];
        } else if (scrollView.contentOffset.x >= self.frame.size.width * 2) {
            newPageIndex = [self pageIndexByAdding:1 from:currentPage];
            [self setContentOffset: CGPointMake(self.frame.size.width * 2, 0)];
        }
    }
    
    if (newPageIndex != currentPage) {
        [self performSelector:@selector(setCurrentViewController:) withObject:@(newPageIndex) afterDelay:0];
    }
    
//    [self setCurrentViewController:newPageIndex];
    
    // alert delegate
    if (nil != controlDelegate && [controlDelegate respondsToSelector:@selector(lazyScrollViewDidScroll:at:)])
        [controlDelegate lazyScrollViewDidScroll:self at:[self visibleRect].origin];
}

- (void) setCurrentViewController:(id) pageindex {
    NSInteger index = [pageindex integerValue];
    if (index == currentPage && !_reloadData) return;
    currentPage = index;
    
    for (int i = 0; i < _dictDisplayView.allKeys.count; i++) {
        id key = [_dictDisplayView.allKeys objectAtIndex:i];
        UIView *reusingView = [_dictDisplayView objectForKey:key];
        [reusingView removeFromSuperview];
        [_dictReusingView setObject:reusingView forKey:key];
    }
    [_dictDisplayView removeAllObjects];
    
    
    NSInteger prevPage = [self pageIndexByAdding:-1 from:currentPage];
    NSInteger nextPage = [self pageIndexByAdding:+1 from:currentPage];
   
    CGRect currentRect = CGRectZero;
    
    if (!self.circulation) {
        //如果是轮回或当前页不等于0，可以加载上一页
        if (currentPage !=0) {
            CGRect previousRect =  CGRectMake(0,
                                              0,
                                              self.frame.size.width,
                                              self.frame.size.height);
            [self loadControllerAtIndex:prevPage withFrame:previousRect];   // load previous page
        }
        
        //如果事轮回或不等于0页或最后一页,则当前也rect等于当前宽，反之等于当前宽
        if (currentPage !=0) {
            currentRect = CGRectMake(self.frame.size.width,
                                     0,
                                     self.frame.size.width,
                                     self.frame.size.height);
            [self loadControllerAtIndex:index withFrame:currentRect];       // load current page
        } else if (currentPage ==0) {
            currentRect = CGRectMake(0,
                                     0,
                                     self.frame.size.width,
                                     self.frame.size.height);
            [self loadControllerAtIndex:index withFrame:currentRect];       // load current page
        }
        
        //如果事论活或当前页不等于最后一页,可以加载下一页
        if (currentPage != self.numberOfPages-1 && self.numberOfPages > 1) {
            CGRect nextRect = CGRectZero;
            if (numberOfPages != 2 && currentPage != 0) {
                nextRect = CGRectMake(self.frame.size.width * 2,
                                      0,
                                      self.frame.size.width,
                                      self.frame.size.height);
            } else {
                nextRect = CGRectMake(self.frame.size.width,
                                      0,
                                      self.frame.size.width,
                                      self.frame.size.height);
            }
            [self loadControllerAtIndex:nextPage withFrame:nextRect];   // load next page
        }
    } else {
        if (self.numberOfPages > 1) {
            if (self.numberOfPages == 2) {  //如果是只有2页，移除缓存，不然会出现在第一页时，第0页和第1页一样
                [_dictReusingView removeAllObjects];
            }
            
            CGRect previousRect =  CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [self loadControllerAtIndex:prevPage withFrame:previousRect];   // load previous page
            
            currentRect = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            [self loadControllerAtIndex:index withFrame:currentRect];       // load current page
            
            CGRect nextRect = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height);
            [self loadControllerAtIndex:nextPage withFrame:nextRect];   // load next page
        } else {
            currentRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [self loadControllerAtIndex:index withFrame:currentRect];       // load current page
        }
    }
    
    
    
    self.contentOffset = CGPointMake(currentRect.origin.x, 0); // recenter
    
    if (!self.circulation) {
        if (self.numberOfPages <= 1) {
            self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        } else if (self.numberOfPages == 2) {
            self.contentSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height);
        } else if (currentRect.origin.x == 0) {
            self.contentSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height);
        } else if(self.circulation || currentPage != self.numberOfPages - 1) {
            self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        } else if (!self.circulation && currentPage == self.numberOfPages - 1) {
            self.contentSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height);
        }
    } else {
        if (self.numberOfPages <= 1) {
            self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        } else {
            self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        }
    }
    
    _reloadData = NO;
    
    if (self.controlDelegate && [self.controlDelegate respondsToSelector:@selector(lazyScrollView:didSelectedIndex:)]) {
        [self.controlDelegate lazyScrollView:self didSelectedIndex:index];
    }
    
}

- (UIViewController *) visibleViewController {
    __block UIView *visibleView = nil;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (CGRectIntersectsRect([self visibleRect], subView.frame)) {
            visibleView = subView;
            *stop = YES;
        }
    }];
    if (visibleView == nil) return nil;
    return [self viewControllerFromView:visibleView];
}

- (UIViewController *) viewControllerFromView:(UIView*) targetView {
    return (UIViewController *)[self traverseResponderChainForUIViewController:targetView];
}

- (id) traverseResponderChainForUIViewController:(UIView *) targetView {
    id nextResponder = [targetView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController:targetView];
    } else {
        return nil;
    }
}

- (NSInteger) pageIndexByAdding:(NSInteger) offset from:(NSInteger) index {
    NSInteger pageCount = numberOfPages;
    NSInteger current = (pageCount+index+(offset%pageCount))%pageCount;
//    NSLog(@"%d",(pageCount+index+(offset%pageCount))%pageCount);
//    return (numberOfPages+index+(offset%numberOfPages))%numberOfPages;
    return current;
}

- (void) moveByPages:(NSInteger) offset animated:(BOOL) animated
{
    if (self.numberOfPages <= 0) return;
    
    if (self.dragging || self.tracking || self.decelerating) return;
    
//    //如果不是轮回，如果往前超过最大页，往后低于第一页则跳出
//    if (!self.circulation) {
//        NSInteger tempIndexPage = self.currentPage + offset;
//        if (tempIndexPage < 0 || tempIndexPage > self.numberOfPages - 1) {
//            return;
//        }
//    }
    
    NSUInteger finalIndex = [self pageIndexByAdding:offset from:self.currentPage];
    DMLazyScrollViewTransition transition = (offset >= 0 ?  DMLazyScrollViewTransitionForward :
                                                            DMLazyScrollViewTransitionBackward);
    [self setPage:finalIndex transition:transition animated:animated];
}

//得到当前已经加载的第index页，如果第index页没加载，返回nil,     只有3也是加载的，当前页，当前页－1，当前页＋1
- (UIView *)pageViewAtIndex:(NSUInteger)index
{
//    if (abs(index - self.currentPage) > 1) {    //如果想要得到的index页与当前页相差1页以上则是肯定没有加载的，返回空
//        return nil;
//    }

    if (!_dictDisplayView)  return nil;
    
    return [_dictDisplayView objectForKey:@(index)];
}

//获得第index页，先从新数据获得，如果新数据没有再从旧数据中得到
- (UIView *)pageResuingViewAtIndex:(NSUInteger)index {
    if (_dictDisplayView && [_dictDisplayView objectForKey:@(index)]) {
        return [_dictDisplayView objectForKey:@(index)];
    } else if (_dictReusingView && [_dictReusingView objectForKey:@(index)]) {
        return [_dictReusingView objectForKey:@(index)];
    } else {
        return nil;
    }
}

//重新加载第index页的数据,只是单纯的重新加载而已
- (void)resetDataWithIndex:(NSUInteger)index
{
    UIView *indexView = [_dictDisplayView objectForKey:@(index)];
    if (!indexView) return;
    
    indexView = [self.controlDelegate lazyScrollView:self viewForItemAtIndex:index reusingView:indexView];
}

- (void) setPage:(NSInteger) newIndex animated:(BOOL) animated {
    [self setPage:newIndex transition:DMLazyScrollViewTransitionForward animated:animated];
}

- (void) setPage:(NSInteger) newIndex transition:(DMLazyScrollViewTransition) transition animated:(BOOL) animated
{
    if (newIndex == currentPage) return;
    if (newIndex > self.numberOfPages - 1) return;
    if (newIndex < 0) return;
    
    if (animated) {
        BOOL isOnePageMove = (abs((int)(self.currentPage-newIndex)) == 1);
        if (self.circulation &&
            (self.currentPage == 0 && newIndex == self.numberOfPages - 1 && transition != DMLazyScrollViewTransitionForward)) {  //是循环滚动，且从第一页跳到最后一页且不是向前跳
            isOnePageMove = YES;  //标示为是跳转1页
            transition = DMLazyScrollViewTransitionBackward;
        } else if (self.circulation &&
                   (self.currentPage == self.numberOfPages - 1 && newIndex == 0 && transition != DMLazyScrollViewTransitionBackward)) {  //是循环滚动，且从最后一页跳到第一页且不是向后跳
            isOnePageMove = YES;  //标示为是跳转1页
            transition = DMLazyScrollViewTransitionForward;
        }
        
        CGPoint finalOffset;
        
        if (transition == DMLazyScrollViewTransitionAuto) {
            if (newIndex > self.currentPage) transition = DMLazyScrollViewTransitionForward;
            else if (newIndex < self.currentPage) transition = DMLazyScrollViewTransitionBackward;
        }
    
//        if (transition == DMLazyScrollViewTransitionForward) {
//            if (!isOnePageMove)
//                [self loadControllerAtIndex:newIndex andPlaceAtIndex:2];
//            finalOffset = CGPointMake(self.frame.size.width*(isOnePageMove ? 3 : 4), 0);
//        } else {
//            if (!isOnePageMove)
//                [self loadControllerAtIndex:newIndex andPlaceAtIndex:-2];
//            finalOffset = CGPointMake(self.frame.size.width*(isOnePageMove ? 1 : 0), 0);
//        }
        
        
        if (transition == DMLazyScrollViewTransitionForward) {
            if (!self.circulation) {
                if (!isOnePageMove) {
                    if (self.currentPage == 0) {
                        if (!self.movePageDisplayEveryPage) {
                            CGRect rect = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height);
                            [self loadControllerAtIndex:newIndex withFrame:rect];
                            self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
                            finalOffset = CGPointMake(self.frame.size.width * 2, 0);
                        } else {
                            NSUInteger nextIndex = [self pageIndexByAdding:2 from:self.currentPage];
                            CGFloat x = self.frame.size.width * 2;
                            while (nextIndex != newIndex) {
                                CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                                [self loadControllerAtIndex:nextIndex withFrame:rect];
                                
                                x += self.frame.size.width;
                                nextIndex = [self pageIndexByAdding:1 from:nextIndex];
                            }
                            
                            CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                            [self loadControllerAtIndex:nextIndex withFrame:rect];
                            self.contentSize = CGSizeMake(self.frame.size.width + x, self.frame.size.height);
                            finalOffset = CGPointMake(x, 0);
                        }
                        
                    } else {
                        if (!self.movePageDisplayEveryPage) {
                            CGRect rect = CGRectMake(self.frame.size.width * 3, 0, self.frame.size.width, self.frame.size.height);
                            [self loadControllerAtIndex:newIndex withFrame:rect];
                            self.contentSize = CGSizeMake(self.frame.size.width * 4, self.frame.size.height);
                            finalOffset = CGPointMake(self.frame.size.width * 3, 0);
                        } else {
                            NSUInteger nextIndex = [self pageIndexByAdding:2 from:self.currentPage];
                            CGFloat x = self.frame.size.width * 3;
                            while (nextIndex != newIndex) {
                                CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                                [self loadControllerAtIndex:nextIndex withFrame:rect];
                                
                                x += self.frame.size.width;
                                nextIndex = [self pageIndexByAdding:1 from:nextIndex];
                            }
                            
                            CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                            [self loadControllerAtIndex:nextIndex withFrame:rect];
                            self.contentSize = CGSizeMake(self.frame.size.width + x, self.frame.size.height);
                            finalOffset = CGPointMake(x, 0);
                        }
                    }
                } else {
                    if (self.currentPage == 0) {
                        finalOffset = CGPointMake(self.frame.size.width, 0);
                    } else {
                        finalOffset = CGPointMake(self.frame.size.width * 2, 0);
                    }
                }
            } else {
                if (!isOnePageMove) {
                    if (!self.movePageDisplayEveryPage) {
                        CGRect rect = CGRectMake(self.frame.size.width * 3, 0, self.frame.size.width, self.frame.size.height);
                        [self loadControllerAtIndex:newIndex withFrame:rect];
                        self.contentSize = CGSizeMake(self.frame.size.width * 4, self.frame.size.height);
                        finalOffset = CGPointMake(self.frame.size.width * 3, 0);
                    } else {
                        NSUInteger nextIndex = [self pageIndexByAdding:2 from:self.currentPage];
                        CGFloat x = self.frame.size.width * 3;
                        while (nextIndex != newIndex) {
                            CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                            [self loadControllerAtIndex:nextIndex withFrame:rect];
                            
                            x += self.frame.size.width;
                            nextIndex = [self pageIndexByAdding:1 from:nextIndex];
                        }
                        
                        CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                        [self loadControllerAtIndex:nextIndex withFrame:rect];
                        self.contentSize = CGSizeMake(self.frame.size.width + x, self.frame.size.height);
                        finalOffset = CGPointMake(x, 0);
                    }
                } else {
                    finalOffset = CGPointMake(self.frame.size.width * 2, 0);
                }
            }
        } else if (transition == DMLazyScrollViewTransitionBackward) {
            if (!self.circulation) {
                if (!isOnePageMove) {
                    if (!self.movePageDisplayEveryPage) {
                        CGRect rect = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                        [self loadControllerAtIndex:newIndex withFrame:rect];
                        finalOffset = CGPointMake(-self.frame.size.width, 0);
                    } else {
                        NSUInteger nextIndex = [self pageIndexByAdding:-2 from:self.currentPage];
                        CGFloat x = -self.frame.size.width;
                        while (nextIndex != newIndex) {
                            CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                            [self loadControllerAtIndex:nextIndex withFrame:rect];
                            
                            x -= self.frame.size.width;
                            nextIndex = [self pageIndexByAdding:-1 from:nextIndex];
                        }
                        
                        CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                        [self loadControllerAtIndex:nextIndex withFrame:rect];
                        finalOffset = CGPointMake(x, 0);
                    }
                } else {
                    finalOffset = CGPointMake(0, 0);
                }
            } else {
                if (!isOnePageMove) {
                    if (!self.movePageDisplayEveryPage) {
                        CGRect rect = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                        [self loadControllerAtIndex:newIndex withFrame:rect];
                        finalOffset = CGPointMake(-self.frame.size.width, 0);
                    } else {
                        NSUInteger nextIndex = [self pageIndexByAdding:-2 from:self.currentPage];
                        CGFloat x = -self.frame.size.width;
                        while (nextIndex != newIndex) {
                            CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                            [self loadControllerAtIndex:nextIndex withFrame:rect];
                            
                            x -= self.frame.size.width;
                            nextIndex = [self pageIndexByAdding:-1 from:nextIndex];
                        }
                        
                        CGRect rect = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
                        [self loadControllerAtIndex:nextIndex withFrame:rect];
                        self.contentSize = CGSizeMake(x, self.frame.size.height);
                        finalOffset = CGPointMake(x, 0);
                    }
                } else {
                    finalOffset = CGPointMake(0, 0);
                }
            }
        }
        
        
        
        isManualAnimating = YES;
        
        [UIView animateWithDuration:kDMLazyScrollViewTransitionDuration
                              delay:0.0
                            options:(UIViewAnimationOptions)UIViewAnimationCurveEaseOut
                         animations:^{
                             self.contentOffset = finalOffset;
                         } completion:^(BOOL finished) {
                            if (!finished) return;
                            [self setCurrentViewController:@(newIndex)];
                             isManualAnimating = NO;
                         }];
    } else {
        [self setCurrentViewController:@(newIndex)];
    }
}

//清空缓存页面字典
- (void)clearResuingView
{
    if (_dictReusingView && _dictReusingView.allKeys.count > 0) {
        for (UIView *view in _dictReusingView.allValues) {
            [view removeFromSuperview];
        }
    }
    [_dictReusingView removeAllObjects];
}

//清空当前页面字典
- (void)clearDisplayView
{
    if (_dictDisplayView && _dictDisplayView.allKeys.count > 0) {
        for (UIView *view in _dictDisplayView.allValues) {
            [view removeFromSuperview];
        }
    }
    [_dictDisplayView removeAllObjects];
}

- (void) setCurrentPage:(NSUInteger)newCurrentPage {
    [self setCurrentViewController:@(newCurrentPage)];
}

- (UIView *) loadControllerAtIndex:(NSInteger) index withFrame:(CGRect)rect
{
    UIView *resingView = nil;
    //如果找到相同页，则直接用
    if (_dictReusingView.allKeys.count > 0) {
        if ([_dictReusingView objectForKey:@(index)] != nil) {
            resingView = [_dictReusingView objectForKey:@(index)];
            if (resingView && !self.openAllReusingView) {  //如果缓存page存在且不缓存所有页面，则移除掉
                [_dictReusingView removeObjectForKey:@(index)];
            }
            
            //如果不是重新加载，则直接用旧的显示，反之，则调用委托获得数据
            if (!_reloadData) {
                resingView.frame = rect;
                if (!resingView.superview) [self addSubview:resingView];
                [_dictDisplayView setObject:resingView forKey:@(index)];
                return resingView;
            }
        }
//        else {
//            id key = [[_dictReusingView allKeys] objectAtIndex:0];
//            resingView = [_dictReusingView objectForKey:key];
//            [_dictReusingView removeObjectForKey:key];
//        }
    }
    UIView *pageView = [self.controlDelegate lazyScrollView:self viewForItemAtIndex:index reusingView:resingView];
    pageView.frame = rect;
    if (!resingView.superview) [self addSubview:pageView];
    [_dictDisplayView setObject:pageView forKey:@(index)];
    return pageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (nil != controlDelegate && [controlDelegate respondsToSelector:@selector(lazyScrollViewDidEndDragging:)])
        [controlDelegate lazyScrollViewDidEndDragging:self];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (nil != controlDelegate && [controlDelegate respondsToSelector:@selector(lazyScrollViewWillBeginDecelerating:)])
        [controlDelegate lazyScrollViewWillBeginDecelerating:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (nil != controlDelegate && [controlDelegate respondsToSelector:@selector(lazyScrollViewDidEndDecelerating:)])
        [controlDelegate lazyScrollViewDidEndDecelerating:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (nil != controlDelegate && [controlDelegate respondsToSelector:@selector(lazyScrollViewWillBeginDragging:)])
        [controlDelegate lazyScrollViewWillBeginDragging:self];
}


@end
