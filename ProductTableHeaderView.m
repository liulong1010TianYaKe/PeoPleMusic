//
//  ProductTableHeaderView.m
//  MainApp
//
//  Created by long on 1/19/16.
//  Copyright © 2016 hzins. All rights reserved.
//

#import "ProductTableHeaderView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIView-WhenTappedBlocks.h"

//imageView宽
#define kImgViewWidth self.bounds.size.width
//imageView高
#define kImgViewHeight self.bounds.size.height
//pageControl的Y
#define kPageControlY kImgViewHeight - 20
//pageControl的X
#define kPageControlX 0
//pageControl的宽
#define kPageControlWidth kImgViewWidth
//pageControl的高
#define kPageControlHeight 3

#define KDefaultImg  kImageDefault640x318

@interface ProductTableHeaderView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *picArray;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ProductTableHeaderView


- (NSArray *)picArray {
    if (!_picArray) {
        _picArray = [NSArray array];
    }
    return _picArray;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self initMainScrollView];
    
    if (self.picArray.count > 1) {
        [self addImageView];
        [self initPageControl];
        [self initTimer];
    }else{
        [self addBtnViewOne];  // 只有一张图片
    }

}


//初始化方法，将存照片名的数组传进来
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array  {
    self = [super initWithFrame:frame];
    if (self) {
        self.picArray = [NSArray arrayWithArray:array];
        self.timeInterval = 3.0;
    }
    return self;
}

#pragma mark -- MainScrollView
//初始化scrollView
- (void)initMainScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.contentOffset = CGPointMake(kImgViewWidth, 0);
    _mainScrollView.pagingEnabled = YES;
    [self addSubview:_mainScrollView];
}

#pragma mark -- ImageView

- (void)addBtnViewOne{
    _mainScrollView.contentSize = CGSizeMake(kImgViewWidth, 0);
    

    UIImageView *imgView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImgViewWidth, kImgViewHeight)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.picArray[0]]  placeholderImage:KDefaultImg];
    imgView.userInteractionEnabled = YES;
    [imgView whenTapped:^{
        if (self.productTableHeaderViewDelegate && [self.productTableHeaderViewDelegate respondsToSelector:@selector(productTableHeaderViewTouchInside:withIndex:)]) {
            [self.productTableHeaderViewDelegate productTableHeaderViewTouchInside:self withIndex:0];
        }
    }];
    
    [self.mainScrollView addSubview:imgView];
}

- (void)addImageView {
    if (self.picArray != nil) {
        _mainScrollView.contentSize = CGSizeMake( kImgViewWidth * (self.picArray.count + 1), 0);

        UIImageView *imgView;
        //创建imageView 比数组中的图片多一张
        for (int i = 0; i < self.picArray.count + 1 ; i++) {
            
            if (i == self.picArray.count) {
                //将最后一张图添加到第一张图的位置 整体为 3 1 2 3
             imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImgViewWidth, kImgViewHeight)];
              
               [imgView whenTapped:^{
                   if (self.productTableHeaderViewDelegate && [self.productTableHeaderViewDelegate respondsToSelector:@selector(productTableHeaderViewTouchInside:withIndex:)]) {
                       [self.productTableHeaderViewDelegate productTableHeaderViewTouchInside:self withIndex:0];
                   }
               }];
                
                if ([self verifyURL:self.picArray[i-1]]) {
                    
                    [imgView sd_setImageWithURL:[NSURL URLWithString:self.picArray[i-1]]  placeholderImage:KDefaultImg];
                    
                } else {
                    imgView.image = [UIImage imageNamed:self.picArray[i - 1]];
                }
                
            } else {
                
                imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kImgViewWidth * (i + 1), 0, kImgViewWidth, kImgViewHeight)];
                if ([self verifyURL:self.picArray[i]]) {
                     [imgView sd_setImageWithURL:[NSURL URLWithString:self.picArray[i]]  placeholderImage:KDefaultImg];
                } else {
                    imgView.image = [UIImage imageNamed:self.picArray[i]];
                }
                
                [imgView whenTapped:^{
                    if (self.productTableHeaderViewDelegate && [self.productTableHeaderViewDelegate respondsToSelector:@selector(productTableHeaderViewTouchInside:withIndex:)]) {
                        [self.productTableHeaderViewDelegate productTableHeaderViewTouchInside:self withIndex:i];
                    }
                }];
                
            }

            [self.mainScrollView addSubview:imgView];
            
        }
    }
}

#pragma mark btnEvent
- (void)btnViewTouchInside:(UIButton *)btn{
    if (self.productTableHeaderViewDelegate && [self.productTableHeaderViewDelegate respondsToSelector:@selector(productTableHeaderViewTouchInside:withIndex:)]) {
        [self.productTableHeaderViewDelegate productTableHeaderViewTouchInside:self withIndex:btn.tag - 100];
    }
}
#pragma mark -- pageControl
//初始化pageControl
- (void)initPageControl {
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kPageControlX, kPageControlY, kPageControlWidth , kPageControlHeight)];
    _pageControl.numberOfPages = self.picArray.count;
    //当前pageControl的位置
    NSInteger currentIndex = self.mainScrollView.contentOffset.x / kImgViewWidth - 1;
    if (currentIndex >= 0) {
        _pageControl.currentPage = currentIndex;
    } else {
        _pageControl.currentPage = self.picArray.count;
    }
    
    _pageControl.pageIndicatorTintColor = self.pageControlIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = self.currentPageColor;
    [self addSubview:_pageControl];
    
}

#pragma mark -- 定时器
//初始化定时器
- (void)initTimer {
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(autoPlay) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

//定时器回调方法
- (void)autoPlay {
    //获取当前偏移量
    CGFloat x = self.mainScrollView.contentOffset.x;
    CGFloat width = kImgViewWidth;
    //偏移量加上scrollview宽度超过scrollview的contentSize
    if (x + width >= self.mainScrollView.contentSize.width) {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
        [self.mainScrollView setContentOffset:CGPointMake(x + width, 0) animated:YES];
    }
    //获取当前pagecontrol的位置
    NSInteger index = x / width ;
    if (index < 0) {
        _pageControl.currentPage = self.picArray.count - 1;
    } else {
        _pageControl.currentPage = index;
    }
}

//开始滑动的时候定时器关闭
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

//滑动结束后定时器开始
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self initTimer];
}


#pragma mark -- scrollView代理
//实现手动循环滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = scrollView.bounds.size.width;
    if (x > self.picArray.count * width) {
        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if (x < 0) {
        [_mainScrollView setContentOffset:CGPointMake(self.picArray.count * width, 0) animated:NO];
    }
}

//滑动结束后计算pageControl的位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //获取当前偏移量
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = kImgViewWidth;
    NSInteger index = x / width - 1;
    if (index < 0) {
        _pageControl.currentPage = self.picArray.count - 1;
    } else {
        _pageControl.currentPage = index;
    }
    
}

//判断是否为url
- (BOOL)verifyURL:(NSString *)url{
    NSString *pattern = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}

@end
