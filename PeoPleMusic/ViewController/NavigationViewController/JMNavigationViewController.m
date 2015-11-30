//
//  YYUINavigationViewController.m
//

#import "JMNavigationViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface JMNavigationViewController ()
{
    BOOL isPushing; //有push时控制0.5s内不让push
    BOOL isPoping;  //后面有问题再用
}

- (void)delayEnableWinodw;  //延迟使window可用

@end

@implementation JMNavigationViewController

/**
 *第一次调用类的时候会调用一次该方法
 */
+(void)initialize
{
    [self setupBarButtonItemTheme];
    [self setupNavigationBarTheme];
}

/**
 *设置UINavigationBar的主题
 */
+ (void)setupNavigationBarTheme
{
    /*
     *注释掉下面setbackgroundimage是因为它影响了发短信controller的top，出现了黑边，所以用这个方法
     */
//    UIImage *img = [UIImage createImageWithColor:kNavBarBGColor];
//    [[UINavigationBar appearanceWhenContainedIn:[JMNavigationViewController class], nil] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    if (kSystemVersionMoreThan7) {
        navBar.barTintColor = kNavigationBarTintColor;//根据背景色和毛玻璃的透明效果中和所以得到的主题颜色 //kNavBarBGColor;    //设置全局背景色
    }
    [navBar setTintColor:kGlobalStyleColor]; //设置全局left right按钮文字颜色
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    md[NSForegroundColorAttributeName]  = [UIColor whiteColor];
    md[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18.0f];
    
    [navBar setTitleTextAttributes:md];
    
    //取消阴影
    //    navBar.shadowImage = [[UIImage alloc] init];  //这种方法在设置了navigation背景图片才能用
    //    navBar.clipsToBounds = YES;   //这种方法可以剪接掉阴影
    
    navBar.shadowImage = kNavShadowColor;  //设置阴影颜色
}

/**
 *设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *appearance=[UIBarButtonItem appearance];
    
    //设置文字的属性
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    textAttrs[NSShadowAttributeName]=[[NSShadow alloc] init];
    textAttrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //    //设置高亮状态下文字的属性
    //    NSMutableDictionary *hightextAttrs=[NSMutableDictionary dictionaryWithDictionary:textAttrs];
    //    hightextAttrs[UITextAttributeTextColor]=[UIColor orangeColor];
    //    [appearance setTitleTextAttributes:hightextAttrs forState:UIControlStateHighlighted];
    
    
    //设置不可用状态下文字的属性
    NSMutableDictionary *disabletextAttrs=[NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disabletextAttrs[NSForegroundColorAttributeName]=[UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disabletextAttrs forState:UIControlStateDisabled];
}

/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = YES;
}

/**
 *  能够拦截所有push进来的子控制器
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (isPushing)
    {
        return;
    }
    isPushing = YES;
    //如果现在push的不是栈顶控制器，那么就隐藏tabbar工具条
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed=YES;
        
        //拦截push操作，设置导航栏的左上角和右上角按钮
        //        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"jiantou_01_23x39" highImageName:@"jiantou_01_23x39_selected" target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:[self getBackImage:NO] highImage:[self getBackImage:YES] target:self action:@selector(back)];
        
    }
    
    [self delayEnableWinodw];
    [super pushViewController:viewController animated:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isPushing = NO;
        
    });
    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (isPoping || isPushing)
    {
        return  nil;
    }
    isPoping = YES;
    //清空viewcontroller里面所有的operation
    UIViewController *viewController = self.viewControllers[self.viewControllers.count-1];
    [KyoUtil clearAllNetworkOperationWithProperty:viewController];
    
    [self delayEnableWinodw];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isPoping = NO;
        
    });
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (isPoping || isPushing)
    {
        return  nil;
    }
    isPoping = YES;
    //清空viewcontroller里面所有的operation
    UIViewController *tempViewController = self.viewControllers[self.viewControllers.count-1];
    [KyoUtil clearAllNetworkOperationWithProperty:tempViewController];
    
    [self delayEnableWinodw];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isPoping = NO;
        
    });
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    //清空viewcontroller里面所有的operation
    UIViewController *tempViewController = self.viewControllers[self.viewControllers.count-1];
    [KyoUtil clearAllNetworkOperationWithProperty:tempViewController];
    
    [self delayEnableWinodw];
    
    return [super popToRootViewControllerAnimated:animated];
}

-(void)back
{
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

-(void)more
{
    [self popToRootViewControllerAnimated:YES];
}

#pragma mark ---------------------------------
#pragma mark - Methods

//延迟使window可用
- (void)delayEnableWinodw
{
    [[[UIApplication sharedApplication] delegate] window].userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] delegate] window].userInteractionEnabled = YES;
        
    });
}

//得到返回barbuttonitem的图标
- (UIImage *)getBackImage:(BOOL)isHighlight {
    static UIImage *imgArrow = nil;
    static UIImage *imgArrowHighlight = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        UIImage *img = [UIImage createImageWithColor:[UIColor clearColor] withSize:CGSizeMake(kWindowWidth/10, 21)];
        imgArrow = [KyoUtil compoundImageWithSize:img.size withMainImage:img withMainImageRect:CGRectMake(0, 0, 60, 21) withSubImage:[UIImage imageNamed:@"nav_icon_back_normal"] withSubImageRect:CGRectMake(0, 0, 20, 20)];
        imgArrowHighlight = [KyoUtil compoundImageWithSize:img.size withMainImage:img withMainImageRect:CGRectMake(0, 0, 60, 21) withSubImage:[UIImage imageNamed:@"nav_icon_back_normal"] withSubImageRect:CGRectMake(0, 0, 20, 20)];

    });
    
    if (isHighlight) {
        return imgArrowHighlight;
    } else {
        return imgArrow;
    }
}

#pragma mark ----------------------------------
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    if (point.y > 60.0f || point.x < kWindowWidth - 60) {
        return NO;
    } else {
        return YES;
    }
}

@end
