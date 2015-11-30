//
//  UINavigationItem+Spacing.m
//  iHomeMiGu
//
//  Created by Kyo on 8/14/14.
//  Copyright (c) 2014 深圳市启智有声科技有限公司. All rights reserved.
//

#import "UINavigationItem+Spacing.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UINavigationItem (Spacing)

// load 在初始化类时调用，每个类都有一个load 方法，
// 类的初始化先于对象
+(void)load
{
    //以下方法告诉系统用后面的方法替换前面的
    method_exchangeImplementations(
                                   class_getInstanceMethod(self, @selector(setLeftBarButtonItem:)),
                                   class_getInstanceMethod(self, @selector(mySetLeftBarButtonItem:)));
}
- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil action:nil];
    space.width = -5.0f;
    return space ;
}
-(void)mySetLeftBarButtonItem:(UIBarButtonItem*)barButton
{
    NSArray* barButtons = nil;
    barButtons = [NSArray arrayWithObjects: [self spacer], barButton,nil ];
    [self setLeftBarButtonItems: barButtons];
}

+ (UIBarButtonItem *)createSpaceBarButton:(NSInteger)spaceNumber
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil action:nil];
    space.width = spaceNumber;
    return space;
}

@end
