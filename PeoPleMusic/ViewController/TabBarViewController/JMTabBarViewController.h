//
//  YYTabBarViewController.h
//

#import <UIKit/UIKit.h>
#import "JMNavigationViewController.h"

@interface JMTabBarViewController : UITabBarController


@property (nonatomic, weak) UIViewController *lastSelectedViewContoller;

/**
 *  添加一个子控制器
 *
 *  @param childVC           子控制对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中时的图标
 */
- (JMNavigationViewController *)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

- (void)addCustomTabBar;

@end
