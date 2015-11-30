//
//  YYTabBarViewController.m
//

#import "JMTabBarViewController.h"
#import "YYTabBar.h"

@interface JMTabBarViewController ()<UITabBarControllerDelegate>

@property (strong, nonatomic) NSMutableArray *tabBarConfig;

@end

@implementation JMTabBarViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate=self;
}

#pragma mark-代理方法

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
        return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController
{
    UIViewController *vc = [viewController.viewControllers firstObject];
    self.lastSelectedViewContoller = vc;
}

-(void)addCustomTabBar
{
    YYTabBar *customTabBar = [[YYTabBar alloc] init];
    //设置代理
    customTabBar.delegate=self;
    // 更换系统自带的tabbar
    [self setValue:customTabBar forKeyPath:@"tabBar"];
    //取消阴影
//    customTabBar.clipsToBounds = YES;
    customTabBar.shadowImage = [UIImage createImageWithColor:YYColorRGBA(100, 100, 100,0.1)];   //阴影颜色
}


/**
 *  添加一个子控制器
 *
 *  @param childVC           子控制对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中时的图标
 */
-(JMNavigationViewController *)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.title=title;
    childVc.tabBarItem.image = imageName ? [UIImage imageNamed:imageName] : nil;
    UIImage *selectedImage = selectedImageName ? [UIImage imageNamed:selectedImageName] : nil;
    
    if (!self.tabBarConfig) {
        self.tabBarConfig = [NSMutableArray array];
    }
    NSDictionary *info = [NSDictionary dictionaryWithObjects:@[title,imageName,selectedImageName] forKeys:@[@"title",@"imageName",@"selectedImageName"]];
    [self.tabBarConfig addObject:info];
    
    //设置tabBarItem普通状态下文字的颜色
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YYColor(153, 153, 153);
    textAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:10];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置tabBarItem选中状态下文字的颜色
    NSMutableDictionary *selectedtextAttrs=[NSMutableDictionary dictionary];
    selectedtextAttrs[NSForegroundColorAttributeName] = YYColor(250, 76, 85);
    [childVc.tabBarItem setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    
    //不渲染
    if (kSystemVersionMoreThan7) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    childVc.tabBarItem.selectedImage = selectedImage;
    
     // 添加为tabbar控制器的子控制器
    JMNavigationViewController *nav=[[JMNavigationViewController alloc]initWithRootViewController:childVc];
    
    [self addChildViewController:nav];

    return nav;
}

#pragma mark - XYTabBarViewDelegate

-(void)tabBarDidFinishedTouch:(NSInteger)index
{
    [self setSelectedIndex:index];
    
}

-(void)tabBarTapSelectedItemWithIndex:(NSInteger)index
{
    JMNavigationViewController *nav = self.childViewControllers[index];
    XYLog(@"点击了当前页的TabbarItem -- %@",NSStringFromClass([nav.childViewControllers[0] class] ));
}

@end
