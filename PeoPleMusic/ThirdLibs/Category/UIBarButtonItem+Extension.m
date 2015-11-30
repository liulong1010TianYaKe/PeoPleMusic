//
//  UIBarButtonItem+Extension.m
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

#define kUIBarButtonItemExtensionLabelSize  (CGSizeMake(500,1000))

@implementation UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithImageName:(NSString *)ImageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    //自定义UIView
    UIButton *btn=[[UIButton alloc]init];
    
    //设置按钮的背景图片（默认/高亮）
    if (ImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:ImageName] forState:UIControlStateNormal];
    }
    if (highImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    }
    
    //设置按钮的尺寸和图片一样大，使用了UIImage的分类
    btn.size=btn.currentBackgroundImage.size;
    
    [btn addTarget:self action:@selector(btnTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
   
}

+(UIBarButtonItem *)itemWithImage:(UIImage *)img highImage:(UIImage *)highImg target:(id)target action:(SEL)action {
    //自定义UIView
    UIButton *btn=[[UIButton alloc]init];
    
    //设置按钮的背景图片（默认/高亮）
    if (img) {
        [btn setBackgroundImage:img forState:UIControlStateNormal];
    }
    if (highImg) {
        [btn setBackgroundImage:highImg forState:UIControlStateHighlighted];
    }
    
    //设置按钮的尺寸和图片一样大，使用了UIImage的分类
    btn.size=btn.currentBackgroundImage.size;
    
    [btn addTarget:self action:@selector(btnTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemSpaceButtonWithWidth:(NSInteger)width
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake(width, 1);
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [self itemWithTitle:title withFont:[UIFont systemFontOfSize:15] target:target action:action];
}

+ (instancetype)itemWithTitle:(NSString *)title withFont:(UIFont *)font target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:YYColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btn setTitleColor:YYColor(188.0, 188.0, 188.0) forState:UIControlStateHighlighted];
    [btn setTitleColor:YYColor(166, 166, 166) forState:UIControlStateDisabled];
    btn.titleLabel.font = font;
    btn.size = KyoBoundingRectWithSize(title, btn.titleLabel.font, kUIBarButtonItemExtensionLabelSize.width);
    [btn addTarget:self action:@selector(btnTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

#pragma mark ----------------------------
#pragma mark - Events

//每个按钮都触发这个时间，目的是让其点击后，过1秒后才能再次点击
+ (void)btnTouchIn:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
}

@end
