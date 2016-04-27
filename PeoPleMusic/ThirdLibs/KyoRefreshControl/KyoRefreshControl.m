//
//  KyoRefreshControl.m
//  YWCat
//
//  Created by Kyo on 4/25/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoRefreshControl.h"
#import "KyoLoadMoreControl.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

@interface KyoRefreshControl()<KyoLoadMoreControlDelegate, RHRefreshControlDelegate>
{
    BOOL _isCanCheckRefresh;    //是否能检测刷新
    BOOL _isCompleterLoadMore;  //是否完成加载更多，因为每次加载完都会设置numberofpage，所有在设置的时候就说明加载完成
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RHRefreshControl *refreshControl;
@property (nonatomic, strong) KyoLoadMoreControl *kyoLoadMoreControl;
@property (strong, nonatomic) KyoDataTipsView *kyoDataTipsView;

@property (assign, nonatomic) BOOL isCanShowNoMore; /**< 是否显示没有更多数据了 */
@property (strong, nonatomic) NSArray *arrayReloadErrorCode;    /**< 如果有errorcode，可以点击后刷新的code数组 */

- (void)setupControl;
- (void)addObserver;
- (void)removeObserver;
- (void)cancelPreviousPerformRequests;
- (void)changeKyoDataTipsViewCenter;    /**< 修改错误提示的中心点 */
- (BOOL)isConnectNetwork;   //判断当前是否连接了网络

@end

@implementation KyoRefreshControl

#pragma mark ------------------------
#pragma mark - CycLife

- (id)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate {
    return [self initWithScrollView:scrollView withDelegate:delegate withIsCanShowNoMore:NO];
}

- (id)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate withIsCanShowNoMore:(BOOL)isCanShowNoMore {
    return [self initWithScrollView:scrollView withDelegate:delegate withIsCanShowNoMore:isCanShowNoMore withKyoRefreshDisplayType:KyoRefreshDisplayTypeDefault];
}

- (id)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate withIsCanShowNoMore:(BOOL)isCanShowNoMore withKyoRefreshDisplayType:(KyoRefreshDisplayType)type {
    self = [super init];
    if (self) {
        
        self.scrollView = scrollView;
        self.kyoRefreshControlDelegate = delegate;
        self.isCanShowNoMore = isCanShowNoMore;
        _refreshDisplayType = type;
        _tableViewDefaultInsets = scrollView.contentInset;
        _arrayReloadErrorCode = @[@"1005", @"1004"];
        
        [self setupControl];
        [self addObserver];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver];
    [self cancelPreviousPerformRequests];
}

#pragma mark ------------------------
#pragma mark - Gettings

- (NSInteger)numberOfPage {
    return self.kyoLoadMoreControl.numberOfPage;
}

- (NSInteger)currentPage {
    return self.kyoLoadMoreControl.currentPage;
}

- (BOOL)isLoading {
    return self.refreshControl.isLoading;
}

- (BOOL)isShowErrorMsg {
    if (self.kyoDataTipsView.alpha == 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark ------------------------
#pragma mark - Settings

- (void)setNumberOfPage:(NSInteger)numberOfPage {
    self.kyoLoadMoreControl.numberOfPage = numberOfPage;
    _isCompleterLoadMore = YES;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    self.kyoLoadMoreControl.currentPage = currentPage;
}

- (void)setIsEnableRefresh:(BOOL)isEnableRefresh {
    _isEnableRefresh = isEnableRefresh;
    
    self.refreshControl.canRefresh = isEnableRefresh;
}

- (void)setYOffset:(CGFloat)yOffset {
    _yOffset = yOffset;
    
    if (self.kyoDataTipsView && self.kyoDataTipsView.kyoDataTipsModel) {
        KyoDataTipsModel *kyoDataTipsModel = self.kyoDataTipsView.kyoDataTipsModel;
        kyoDataTipsModel.yOffset = _yOffset;
        self.kyoDataTipsView.kyoDataTipsModel = kyoDataTipsModel;
    }
}

- (void)setErrorMsg:(NSString *)errorMsg {
    _errorMsg = errorMsg;
    
    if (self.kyoDataTipsView &&
        self.kyoDataTipsView.kyoDataTipsModel &&
        ![errorMsg isEqualToString:kKyoRefreshControlErrorMsgDefault]) {
        self.kyoDataTipsView.kyoDataTipsModel.tip = errorMsg;
    }
}

- (void)setTableViewDefaultInsets:(UIEdgeInsets)tableViewDefaultInsets {
    _tableViewDefaultInsets = tableViewDefaultInsets;
    
    self.refreshControl.tableViewDefaultInsets = tableViewDefaultInsets;
    self.kyoDataTipsView.scrollViewDefaultInsets = tableViewDefaultInsets;
    self.kyoLoadMoreControl.defaultInsets = tableViewDefaultInsets;
    self.kyoLoadMoreControl.newInsets = tableViewDefaultInsets;
}

- (void)setRefreshDisplayType:(KyoRefreshDisplayType)refreshDisplayType {
    _refreshDisplayType = refreshDisplayType;
    self.refreshControl.refreshDisplayType = _refreshDisplayType;
}

- (void)setRefreshViewOffsetY:(CGFloat)refreshViewOffsetY {
    _refreshViewOffsetY = refreshViewOffsetY;
    self.refreshControl.refreshViewOffsetY = refreshViewOffsetY;
}

#pragma mark ------------------------
#pragma mark - Methods

- (void)setupControl {
    RHRefreshControlConfiguration *refreshConfiguration = [[RHRefreshControlConfiguration alloc] init];
    refreshConfiguration.refreshView = RHRefreshViewStylePinterest;
    refreshConfiguration.minimumForStart = @(0+self.scrollView.contentInset.top);
    refreshConfiguration.maximumForPull = @(60);
    RHRefreshControl *refreshControl = [[RHRefreshControl alloc] initWithConfiguration:refreshConfiguration];
    refreshControl.delegate = self;
    [refreshControl attachToScrollView:self.scrollView];
    refreshControl.refreshDisplayType = self.refreshDisplayType;
    refreshControl.refreshViewOffsetY = self.refreshViewOffsetY;
    self.refreshControl = refreshControl;
    
    KyoDataTipsView *kyoDataTipsView = [[KyoDataTipsView alloc] initWithScrollView:self.scrollView];
    self.kyoDataTipsView = kyoDataTipsView;
    
    KyoLoadMoreControl *kyoLoadMoreControl = [[KyoLoadMoreControl alloc] initWithScrollView:self.scrollView withIsCanShowNoMore:self.isCanShowNoMore];
    kyoLoadMoreControl.delegate = self;
    self.kyoLoadMoreControl = kyoLoadMoreControl;
    
    _isEnableRefresh = YES;
    _errorMsg = kKyoRefreshControlErrorMsgDefault;
}

- (void)addObserver {
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserver {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)cancelPreviousPerformRequests {
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[self.refreshControl class] cancelPreviousPerformRequestsWithTarget:self];
    [[self.refreshControl class] cancelPreviousPerformRequestsWithTarget:self.refreshControl];
    [[self.kyoLoadMoreControl class] cancelPreviousPerformRequestsWithTarget:self];
    [[self.kyoLoadMoreControl class] cancelPreviousPerformRequestsWithTarget:self.kyoLoadMoreControl];
}

/**< 修改错误提示的中心点 */
- (void)changeKyoDataTipsViewCenter {
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        CGFloat y = tableView.tableHeaderView.frame.size.height + (tableView.bounds.size.height - tableView.tableHeaderView.frame.size.height) / 2 - (tableView.bounds.size.height - _tableViewDefaultInsets.top) / 2;
        KyoDataTipsModel *kyoDataTipsModel = self.kyoDataTipsView.kyoDataTipsModel;
        kyoDataTipsModel.yOffset = y + _yOffset;
        self.kyoDataTipsView.kyoDataTipsModel = kyoDataTipsModel;
    }
}

////手动刷新，根据类型显示刷新样式
//- (void)kyoRefreshOperationWithRefreshDisplayType:(RefreshDisplayType)refreshDisplayType {
//    if (refreshDisplayType == RefreshDisplayTypeDefault) {
//        [self kyoRefreshOperation];
//    } else if (refreshDisplayType == RefreshDisplayTypeBody) {
//        if (self.refreshControl.isLoading) return;
//        self.refreshControl.canRefresh = NO;
//        self.kyoLoadMoreControl.canLoadMore = NO;
//        if (self.kyoRefreshControlDelegate && [self.kyoRefreshControlDelegate respondsToSelector:@selector(kyoRefreshDidTriggerRefresh:)]) {
//            [self.kyoRefreshControlDelegate kyoRefreshDidTriggerRefresh:self];
//            self.isHadLoaded = YES; //设置有过刷新
//            
//        }
//        
//        //在中间显示刷新view（目前还没做）
//    }
//}

//手动刷新
- (void)kyoRefreshOperation {
    if (self.refreshControl.isLoading) return;
    [self.refreshControl refreshOperation];
    self.kyoLoadMoreControl.canLoadMore = NO;
}

//刷新完成，是否带动画
- (void)kyoRefreshScrollViewDataSourceDidFinishedLoadingWithAnimation:(BOOL)isAnimation {
    if (self.isEnableRefresh) {
        self.refreshControl.canRefresh = YES;
    }
    if (isAnimation) {
        [self.refreshControl refreshScrollViewDataSourceDidFinishedLoading];
    } else {
        [self.refreshControl refreshScrollViewDataSourceDidFinishedLoadingNoAnimation];
    }
    self.kyoLoadMoreControl.canLoadMore = YES;
    self.kyoLoadMoreControl.currentPage = 0;
}

//加载完成，成功获失败自动判断（通过设置numberofpage就当作加载成功）
- (void)kyoRefreshLoadMore {
    [self kyoRefreshLoadMoreFinished:_isCompleterLoadMore];
}

//加载完成，是否加载成功
- (void)kyoRefreshLoadMoreFinished:(BOOL)isSuccess {
    if (self.isEnableRefresh) {
        self.refreshControl.canRefresh = YES;
    }
    self.kyoLoadMoreControl.canLoadMore = YES;
    if (isSuccess) {
        [self.kyoLoadMoreControl loadCompleteCurrent];  //加载下一页成功
    } else {
        [self.kyoLoadMoreControl cancelLoadMore];   //加载失败
    }
}

//重置
- (void)kyoReset {
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self kyoRefreshScrollViewDataSourceDidFinishedLoadingWithAnimation:NO];
    [self.kyoLoadMoreControl cancelLoadMore];
    [self kyoRefreshShowOrHideErrorMessage:nil withHadData:YES];
    self.numberOfPage = 0;
    self.currentPage = 0;
    self.isHadLoaded = NO;
}

//根据传入是否第一页判断和设置刷新或加载完成，根据3个参数判断是否在tableview中显示提示框
- (void)kyoRefreshDoneRefreshOrLoadMore:(BOOL)isLoadFristPage withHadData:(BOOL)isHadData withError:(NSError *)error {
    if (isLoadFristPage) {  //如果是加载第0页，则是刷新，现在刷新完成
        [self kyoRefreshScrollViewDataSourceDidFinishedLoadingWithAnimation:YES];
    } else {
        [self kyoRefreshLoadMore];   //加载完成，失败或成功自己判断
    }
    
    [self kyoRefreshShowOrHideErrorMessage:error withHadData:isHadData];
}

//显示错误框
- (void)kyoRefreshShowOrHideErrorMessage:(NSError *)error withHadData:(BOOL)isHadData {
    if ((self.currentPage > 0 || isHadData) ||
        (error && error.code == NSURLErrorCancelled)) {
        self.kyoDataTipsView.kyoDataTipsModel.tip = nil;
        self.kyoDataTipsView.alpha = 0;
    } else if (error) {
        KyoDataTipsViewType type = [self isConnectNetwork] ? KyoDataTipsViewTypeNoDataHadNetworkError : KyoDataTipsViewTypeNoDataNoWifi;
        void (^noResultBlock)() = ^{
            KyoDataTipsModel *kyoDataTipsModel = self.kyoDataTipsView.kyoDataTipsModel;
            if (type == KyoDataTipsViewTypeNoDataHadNetworkError) {
                kyoDataTipsModel.tip = @"加载失败，点击屏幕重新加载";
                kyoDataTipsModel.img = [UIImage imageNamed:@"prompt_icon_refresh_normal"];
                kyoDataTipsModel.isShowBGButton = YES;
                kyoDataTipsModel.reloadDataBlock = ^{
                    [self kyoRefreshOperation];
                };
            } else if (type == KyoDataTipsViewTypeNoDataNoWifi) {
                kyoDataTipsModel.tip = @"未连接到网络，请检查网络配置";
                kyoDataTipsModel.img = [UIImage imageNamed:@"prompt_icon_wifi_normal"];
            }
            self.kyoDataTipsView.kyoDataTipsModel = kyoDataTipsModel;
        };
        if (self.kyoRefreshControlDelegate &&
            [self.kyoRefreshControlDelegate respondsToSelector:@selector(kyoRefresh:withNoDataShowTipsView:withCurrentKyoDataTipsModel:withType:)]) {
            KyoDataTipsModel *kyoDataTipsModel = [self.kyoRefreshControlDelegate kyoRefresh:self withNoDataShowTipsView:self.kyoDataTipsView withCurrentKyoDataTipsModel:self.kyoDataTipsView.kyoDataTipsModel withType:type];
            if (kyoDataTipsModel) {
                self.kyoDataTipsView.kyoDataTipsModel = kyoDataTipsModel;
            } else {
                noResultBlock();
            }
        } else {
            noResultBlock();
        }
        self.kyoDataTipsView.alpha = 1;
        [self changeKyoDataTipsViewCenter];
    } else {
        KyoDataTipsViewType type = self.kyoDataTipsView.kyoDataTipsModel.tip ? KyoDataTipsViewTypeNoDataHadError : KyoDataTipsViewTypeNoDataNoError;
        void (^noResultBlock)() = ^{
            KyoDataTipsModel *kyoDataTipsModel = self.kyoDataTipsView.kyoDataTipsModel;
            if (type == KyoDataTipsViewTypeNoDataHadError) {  //如果是没数据且服务器返回了错误
                if (self.errorState && [self.arrayReloadErrorCode containsObject:self.errorState]) {  //如果是需要重新登录
                        kyoDataTipsModel.tip = @"加载失败，点击屏幕重新加载";
                        kyoDataTipsModel.img = [UIImage imageNamed:@"prompt_icon_refresh_normal"];
                        kyoDataTipsModel.isShowBGButton = YES;
                        kyoDataTipsModel.reloadDataBlock = ^{
                            [self kyoRefreshOperation];
                        };
                    } else {
                        kyoDataTipsModel.tip = _errorMsg;
                        kyoDataTipsModel.img = [UIImage imageNamed:@"prompt_img_aberrant_normal-4"];
                    }
            } else if (type == KyoDataTipsViewTypeNoDataNoError) {
                kyoDataTipsModel.tip = @"当前没有数据!";
                kyoDataTipsModel.img = [UIImage imageNamed:@"prompt_img_aberrant_normal-1"];
            }
            self.kyoDataTipsView.kyoDataTipsModel = kyoDataTipsModel;
        };
        if (self.kyoRefreshControlDelegate &&
            [self.kyoRefreshControlDelegate respondsToSelector:@selector(kyoRefresh:withNoDataShowTipsView:withCurrentKyoDataTipsModel:withType:)]) {
            KyoDataTipsModel *kyoDataTipsModel = [self.kyoRefreshControlDelegate kyoRefresh:self withNoDataShowTipsView:self.kyoDataTipsView withCurrentKyoDataTipsModel:self.kyoDataTipsView.kyoDataTipsModel withType:type];
            if (kyoDataTipsModel) {
                self.kyoDataTipsView.kyoDataTipsModel = kyoDataTipsModel;
            } else {
                noResultBlock();
            }
        } else {
            noResultBlock();
        }
        self.kyoDataTipsView.alpha = 1;
        [self changeKyoDataTipsViewCenter];
    }
}

//判断当前是否连接了网络
- (BOOL)isConnectNetwork {
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    //根据获得的连接标志进行判断
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    if (isNetworkReachable == NO) {
        return NO;
    } else {
        return YES;
    }
}

/**< 获得当前版本号 */
- (NSString *)currentVersion {
    return @"v2.0.2";
}

#pragma mark ------------------
#pragma mark - RHRefreshControlDelegate

//刷新
- (void)refreshDidTriggerRefresh:(RHRefreshControl *)refreshControl
{
    self.kyoDataTipsView.kyoDataTipsModel.tip = nil;
    self.kyoDataTipsView.kyoDataTipsModel.isShowBGButton = NO;
    self.kyoDataTipsView.kyoDataTipsModel.isShowOperationButton = NO;
    self.kyoDataTipsView.kyoDataTipsModel.img = [UIImage imageNamed:@"com_tipsView_logo"];
    self.kyoDataTipsView.alpha = 0;
    if (self.kyoRefreshControlDelegate && [self.kyoRefreshControlDelegate respondsToSelector:@selector(kyoRefreshDidTriggerRefresh:)]) {
        [self.kyoRefreshControlDelegate kyoRefreshDidTriggerRefresh:self];
        
        //不能加载下一页
        self.kyoLoadMoreControl.canLoadMore = NO;
        //设置有过刷新
        self.isHadLoaded = YES;
    }
}

#pragma mark ------------------
#pragma mark - KyoLoadMoreControlDelegate

//加载下一页
- (void)kyoLoadMoreControl:(KyoLoadMoreControl *)kyoLoadMoreControl loadPage:(NSInteger)idnex
{
    if (self.kyoRefreshControlDelegate && [self.kyoRefreshControlDelegate respondsToSelector:@selector(kyoRefreshLoadMore:loadPage:)]) {
        [self.kyoRefreshControlDelegate kyoRefreshLoadMore:self loadPage:idnex];
        
        //不能刷新
        self.refreshControl.canRefresh = NO;
        //初始化为加载不成功标识
        _isCompleterLoadMore = NO;
    }
}

#pragma mark ------------------
#pragma mark - KVO/KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (!self.isEnableRefresh) {
            return;
        }
        
        if (self.scrollView.isDragging) {   //如果是拖拽的，设置为可以检测刷新
            _isCanCheckRefresh = YES;
        }
        //如果正在拖拽或不能检测刷新,则只改变动画;反之根据offer判断是否需要刷新
        if (self.scrollView.isDragging || !_isCanCheckRefresh) {
            [self.refreshControl refreshScrollViewDidScroll:self.scrollView];
        } else {
            [self.refreshControl refreshScrollViewDidScroll:self.scrollView];
            [self.refreshControl refreshScrollViewDidEndDragging:self.scrollView];
            _isCanCheckRefresh = NO;
        }
    }
}

@end
