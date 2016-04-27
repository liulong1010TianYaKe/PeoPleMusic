//
//  JMNewfeatureViewController.m
//

#import "NewfeatureViewController.h"
#import "UIDevice-Hardware.h"

#define JMNewfeatureImageCount 5

@interface NewfeatureViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;

- (void)setupScrollView;
- (void)setupPageControl;
- (void)setupLastImageView:(UIImageView *)imageView;
- (void)setupStartButton:(UIImageView *)imageView;

@end

@implementation NewfeatureViewController

#pragma mark ---------------------
#pragma mark - CycLife

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self setupScrollView]; // 添加UISrollView
    [self setupPageControl];    // 添加pageControl
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [UIApplication sharedApplication].statusBarHidden = YES;
}
#pragma mark ---------------------
#pragma mark - Methods

//添加UISrollView
- (void)setupScrollView
{
    // 添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 添加图片
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (int i = 0; i<JMNewfeatureImageCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name;
        if (kWindowHeight == 480) {
            name = [NSString stringWithFormat:@"banner%d_0.jpg", i + 1];
        }else
        {
            name = [NSString stringWithFormat:@"banner%d_1.jpg", i + 1];
        }
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 设置frame
        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i * imageW;
        
        // 给最后一个imageView添加按钮
        if (i == JMNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(JMNewfeatureImageCount * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = YYColor(246, 246, 246);
}

//添加pageControl
- (void)setupPageControl
{
    // 添加PageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = JMNewfeatureImageCount;
    pageControl.centerX = self.view.width * 0.5;
    pageControl.centerY = self.view.height - 20;
    [self.view addSubview:pageControl];
    
    // 设置圆点的颜色
    self.pageControl = pageControl;
    [self changePageControlImage:self.pageControl];
}


//设置最后一个UIImageView中的内容
- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    // 添加开始按钮
    [self setupStartButton:imageView];
}

//添加开始按钮
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:startButton];
    
    // 2.设置背景图片
    startButton.size = CGSizeMake(150, 39);
    [startButton setBackgroundImage:[UIImage imageNamed:@"nf_btn_use"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"nf_btn_use_selected"] forState:UIControlStateHighlighted];
    
    // 3.设置frame
 
    startButton.centerX = self.view.width * 0.5;
    startButton.centerY = self.view.height - 80;
    if (kWindowHeight == 480) {
        startButton.centerY = self.view.height - 55;
    }
    
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ---------------------
#pragma mark - Events

//立即体验
- (void)start
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    //判断类型
    if (self.newfeatureType == NewfeatureTypeFromeWelcom) {
        [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName: kUserDefaultKey_CFBundleShortVersionString withData:[KyoUtil getAppstoreVersion]];   //记录当前版本到缓存
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
        
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    
    // 设置页码
    self.pageControl.currentPage = intPage;
    [self changePageControlImage:self.pageControl];
}

@end
