//
//  KyoRefreshControl.h
//  YWCat
//
//  Created by Kyo on 4/25/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KyoDataTipsView.h"
#import "RHRefreshControl.h"


#define kKyoRefreshControlErrorMsgDefault @"抱歉！当前没有数据"
#define KYOLOADMORECONTROL_NUMBER_OF_PAGES(_total,_rowsAPage)   ((_total + _rowsAPage - 1) / _rowsAPage)

typedef enum : NSInteger {
    KyoDataTipsViewTypeNone = 0,    //什么鸟也没有
    KyoDataTipsViewTypeNoDataNoWifi = 1,    //当前没数据没wifi
    KyoDataTipsViewTypeNoDataHadNetworkError = 2,  //当前没数据且网络请求失败
    KyoDataTipsViewTypeNoDataHadError = 3,  //当前没数据且服务器返回错误
    KyoDataTipsViewTypeNoDataNoError = 4  //当前没数据且服务器返回真的没数据
} KyoDataTipsViewType;

@protocol KyoRefreshControlDelegate;

@interface KyoRefreshControl : NSObject

@property (nonatomic, weak) id<KyoRefreshControlDelegate> kyoRefreshControlDelegate;
@property (nonatomic, assign) NSInteger numberOfPage;   //总共能加载几页
@property (nonatomic, assign) NSInteger currentPage;   //当前加载到第几页
@property (assign, nonatomic) UIEdgeInsets tableViewDefaultInsets;   //tableview默认的insets
@property (assign, nonatomic) CGFloat yOffset;  /**< tipsview的y偏移量 */
@property (assign, nonatomic) KyoRefreshDisplayType refreshDisplayType;    /**< 刷新样式，默认RefreshDisplayTypeDefault */
@property (assign, nonatomic) CGFloat refreshViewOffsetY;   /**< refreshView的y轴偏移量 */


@property (nonatomic, readonly) BOOL isLoading; //是否正在刷新
@property (assign, nonatomic) BOOL isHadLoaded; //是否有过刷新
@property (strong, nonatomic) NSString *errorMsg;   //需要显示的错误信息，在网络请求成功的情况下默认为抱歉！当前没数据
@property (strong, nonatomic) NSString *errorState; /**< 网络请求成功，服务器返回错误时，会得到错误码 */
@property (assign, nonatomic) BOOL isShowErrorMsg;  //是否显示了错误提示框

@property (assign, nonatomic) BOOL isEnableRefresh; //是否可以使用刷新，默认yes
//@property (assign, nonatomic) BOOL isEnableLoadMore; //是否可以使用加载更多，默认yes

- (id)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate;
- (id)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate withIsCanShowNoMore:(BOOL)isCanShowNoMore;
- (id)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate withIsCanShowNoMore:(BOOL)isCanShowNoMore withKyoRefreshDisplayType:(KyoRefreshDisplayType)type;

//- (void)kyoRefreshOperationWithRefreshDisplayType:(RefreshDisplayType)refreshDisplayType;   //手动刷新，根据类型显示刷新样式
- (void)kyoRefreshOperation;   //手动刷新
- (void)kyoRefreshScrollViewDataSourceDidFinishedLoadingWithAnimation:(BOOL)isAnimation;   //刷新完成，是否带动画
- (void)kyoRefreshLoadMore; //加载完成，成功获失败自动判断（通过设置numberofpage就当作加载成功）
- (void)kyoRefreshLoadMoreFinished:(BOOL)isSuccess; //加载完成，是否加载成功
- (void)kyoReset;   //重置
- (void)kyoRefreshDoneRefreshOrLoadMore:(BOOL)isLoadFristPage withHadData:(BOOL)isHadData withError:(NSError *)error;    //根据传入是否第一页判断和设置刷新或加载完成，根据3个参数判断是否在tableview中显示提示框
- (void)kyoRefreshShowOrHideErrorMessage:(NSError *)error  withHadData:(BOOL)isHadData; //显示或隐藏错误框

- (NSString *)currentVersion;   /**< 获得当前版本号 */

@end

@protocol KyoRefreshControlDelegate <NSObject>

@optional
- (void)kyoRefreshDidTriggerRefresh:(KyoRefreshControl *)refreshControl;
- (void)kyoRefreshLoadMore:(KyoRefreshControl *)refreshControl loadPage:(NSInteger)index;
- (KyoDataTipsModel *)kyoRefresh:(KyoRefreshControl *)refreshControl withNoDataShowTipsView:(KyoDataTipsView *)kyoDataTipsView withCurrentKyoDataTipsModel:(KyoDataTipsModel *)kyoDataTipsModel withType:(KyoDataTipsViewType)kyoDataTipsViewType;    /**< 没数据要展示提示view时调用这个委托得到自定义展示数据，如果不想处理的状态返回nil */


@end
