//
//  UIView+VisualEffectView.h
//  MainApp
//
//  Created by Kyo on 11/11/15.
//  Copyright © 2015 zhunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VisualEffectView)

- (void)enableVisualEffect;   /**< 开启毛玻璃效果 */
- (void)enableVisualEffectWithStyle:(UIBlurEffectStyle)style;   /**< 开启毛玻璃效果 */
- (void)enableVisualEffectWithStyle:(UIBlurEffectStyle)style withMaskColor:(UIColor *)color;   /**< 开启毛玻璃效果 */
- (void)disableVisualEffect;    /**< 关闭毛玻璃效果 */

@end
