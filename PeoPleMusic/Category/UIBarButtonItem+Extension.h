//
//  UIBarButtonItem+Extension.h
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithImageName:(NSString *)ImageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
+(UIBarButtonItem *)itemWithImage:(UIImage *)img highImage:(UIImage *)highImg target:(id)target action:(SEL)action;
+(UIBarButtonItem *)itemSpaceButtonWithWidth:(NSInteger)width;

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)itemWithTitle:(NSString *)title withFont:(UIFont *)font target:(id)target action:(SEL)action;

@end
