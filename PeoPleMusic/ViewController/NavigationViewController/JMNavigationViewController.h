//
//  YYUINavigationViewController.h
//

#import <UIKit/UIKit.h>

#define kNavigationBarTintColor YYColor(223, 81, 1)

@interface JMNavigationViewController : UINavigationController

- (UIImage *)getBackImage:(BOOL)isHighlight;    //得到返回barbuttonitem的图标

@end
