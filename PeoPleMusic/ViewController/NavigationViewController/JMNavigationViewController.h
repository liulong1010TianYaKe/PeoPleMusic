//
//  YYUINavigationViewController.h
//

#import <UIKit/UIKit.h>

#define kNavigationBarTintColor YYColor(253, 43, 43)

@interface JMNavigationViewController : UINavigationController

- (UIImage *)getBackImage:(BOOL)isHighlight;    //得到返回barbuttonitem的图标

@end
