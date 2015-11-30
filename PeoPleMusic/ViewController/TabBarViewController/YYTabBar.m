//
//  YYTabBar.m
//

#import "YYTabBar.h"
#import "UIView+Extension.h"

@interface YYTabBar()
@property (nonatomic, weak) UIButton *plusButton;
@property(nonatomic,strong)UIImageView *view;
@end

@implementation YYTabBar

/**
 *第一次调用类的时候会调用一次该方法
 */
+(void)initialize
{
    UITabBar *tabBar = [UITabBar appearance];
    
    if (kSystemVersionMoreThan7) {
        tabBar.barTintColor = [UIColor whiteColor];    //设置全局背景色
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translucent = YES;
    }
    return self;
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置所有tabbarButton的frame
    [self setupAllTabBarButtonsFrame];
}

/**
 *  设置所有tabbarButton的frame
 */
- (void)setupAllTabBarButtonsFrame
{
//    int index = 0;
    
    // 遍历所有的button
    for (UIView *tabBarButton in self.subviews) {
        // 如果不是UITabBarButton， 直接跳过
        if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
//        // 根据索引调整位置
//        UIImageView *view=[[UIImageView alloc]init] ;
//        self.view=view;
//        view.frame=CGRectMake(0, 0, self.width/3-0.5, self.height);
//        [tabBarButton insertSubview:view atIndex:1];
//        [self setupTabBarButtonFrame:tabBarButton atIndex:index];
//        // 索引增加
//        index++;
        
        for (UIView *subView in tabBarButton.subviews) {
            if ([NSStringFromClass([subView class]) isEqualToString:@"UITabBarButtonLabel"]) {
                subView.frame = CGRectMake(0, 0, subView.bounds.size.width + 6, subView.bounds.size.height + 3);
                ((UILabel *)subView).font = [UIFont systemFontOfSize:11];
                ((UILabel *)subView).textAlignment = NSTextAlignmentCenter;
                break;
            }
        }
    }
}


/**
 *  设置某个按钮的frame
 *
 *  @param tabBarButton 需要设置的按钮
 *  @param index        按钮所在的索引
 */
- (void)setupTabBarButtonFrame:(UIView *)tabBarButton atIndex:(int)index
{
    // 计算button的尺寸
    CGFloat buttonW = self.width / self.items.count;
    CGFloat buttonH = self.height;
    
    tabBarButton.width = buttonW;
    tabBarButton.height = buttonH;
    tabBarButton.x = buttonW * index;
    tabBarButton.y = 0;
}
@end