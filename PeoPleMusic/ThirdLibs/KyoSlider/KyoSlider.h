//
//  KyoSlider.h
//  KyoSliderDemo
//
//  Created by Kyo on 25/9/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KyoSliderDelegate;

IB_DESIGNABLE

@interface KyoSlider : UIView

@property (weak, nonatomic) IBOutlet id<KyoSliderDelegate> kyoSliderDelegate;

@property (assign, nonatomic) IBInspectable CGFloat currentValue;   /**< 当前值 */
@property (assign, nonatomic) IBInspectable CGFloat maxValue;   /**< 最大值 */
@property (assign, nonatomic) IBInspectable CGFloat minValue;   /**< 最小值 */
@property (assign, nonatomic) IBInspectable NSInteger sectionCount; /**< 一共分为几段 */
@property (nonatomic, assign) IBInspectable CGSize sliderSize;  /**< 滑块大小 */
@property (nonatomic, assign) IBInspectable CGPoint sliderInset;  /**< 滑块偏移量 */
@property (strong, nonatomic) IBInspectable UIImage *imgDefaultSlider; /**< 滑块图片 */
@property (strong, nonatomic) IBInspectable UIImage *imgDefaultSelected;   /**< 滑块填充图 */
@property (strong, nonatomic) IBInspectable UIImage *imgBackground; /**< 滑块背景图 */
@property (nonatomic, assign) IBInspectable CGFloat radius; /**< 圆角大小 */
@property (strong, nonatomic) NSArray *arrayImageSection;   /**< 每一段对应的滑块和值value   元素为字典{"imgSlider" : value, "imgSelected" : value} */

@end

@protocol KyoSliderDelegate <NSObject>

- (void)kyoSliderValueChange:(KyoSlider *)kyoSlider;    /**< 值改变时触发 */
//- (void)kyoSliderSectionChange:(NSInteger)section;  /**< 段改变时触发 */

@end