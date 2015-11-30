//
//  KyoLoadMoreControl.h
//  Example
//
//  Created by Kyo on 8/13/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import <UIKit/UIKit.h>


#define KYOLOADMORECONTROL_NUMBER_OF_PAGES(_total,_rowsAPage)   ((_total + _rowsAPage - 1) / _rowsAPage)

typedef enum : NSInteger
{
    KyoLoadMoreControlTypeDefault = 0,  //默认，有更多数据，且滑动到下面后自动加载
    KyoLoadMoreControlTypeManualLoad = 1    //手动加载，滑动到下面后出现按钮
} KyoLoadMoreControlType;

@protocol KyoLoadMoreControlDelegate;

@interface KyoLoadMoreControl : UIView

@property (nonatomic, weak) id<KyoLoadMoreControlDelegate> delegate;
@property (nonatomic, assign) BOOL canLoadMore; //是否能加载更多
@property (nonatomic, assign) NSInteger numberOfPage;   //总页数
@property (nonatomic, assign) NSInteger currentPage;    //当前页数
@property (nonatomic, assign) KyoLoadMoreControlType kyoLoadMoreControlType;
@property (nonatomic, strong) NSString *loadMoreButtonTitle;    //加载更多的按钮显示文字
@property (nonatomic, assign) UIEdgeInsets defaultInsets;
@property (nonatomic, assign) UIEdgeInsets newInsets;

- (id)initWithScrollView:(UIScrollView *)scrollView;
- (id)initWithScrollView:(UIScrollView *)scrollView withIsCanShowNoMore:(BOOL)isCanShowNoMore;

- (void)loadCompleteCurrent;    //加载完成第index页
- (void)loadFaultCurrent;   //加载失败index页
- (void)cancelLoadMore; //取消当前正在加载的页

@end

@protocol KyoLoadMoreControlDelegate <NSObject>

- (void)kyoLoadMoreControl:(KyoLoadMoreControl *)kyoLoadMoreControl loadPage:(NSInteger)index;  //加载第index页

@end
