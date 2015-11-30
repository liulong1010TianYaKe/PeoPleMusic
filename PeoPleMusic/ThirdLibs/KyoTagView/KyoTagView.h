//
//  KyoTagView.h
//  XFLH
//
//  Created by Kyo on 7/23/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KyoTagViewIconDirectionLeft = 0 ,   //默认在左边
    KyoTagViewIconDirectionRight = 1    //在右边
} KyoTagViewIconDirection;

@protocol KyoTagViewDelegate;

IB_DESIGNABLE

@interface KyoTagView : UIView

@property (weak, nonatomic) IBOutlet id<KyoTagViewDelegate> kyoTagViewDelegate;

@property (strong, nonatomic) IBInspectable UIImage *imageIcon; /**< 图标 */
@property (assign, nonatomic) IBInspectable NSInteger direction;    /**< 图标方向， 设置图标时有用 */
@property (nonatomic, assign) IBInspectable CGFloat iconYInset;    /**< 图标与标题之间的 y轴inset，默认为0 */
@property (nonatomic, assign) IBInspectable CGFloat space;    /**< 图标与标题的间距，默认为2 */
@property (nonatomic, strong) IBInspectable NSString *title;    /**< 标题 */
@property (nonatomic, strong) IBInspectable NSMutableAttributedString *attributedTitle;    /**< 富文本标题 */
@property (nonatomic, assign) IBInspectable CGFloat fontSize;   /**< 字体大小 */
@property (nonatomic, strong) IBInspectable UIColor *color; /**< 字体和边框颜色（iamge为空时对边框有效） */
@property (nonatomic, assign) IBInspectable BOOL isShowBorder; /**< 是否显示边框，默认显示 */
@property (nonatomic, strong) IBInspectable UIImage *imageBorder; /**< image边框（优先使用image做边框） */
@property (nonatomic, assign) IBInspectable CGFloat radius; /**< 圆角大小（在image为空时有效） */
@property (strong, nonatomic) IBInspectable UIColor *touchColor;    /**< 点击后的颜色,默认没有颜色 */
@property (strong, nonatomic) IBInspectable UIColor *disableColor;    /**< 不能点击时的颜色,默认没有颜色 */
@property (assign, nonatomic) BOOL enable; /**< 是否开启，默认开启 */

- (id)initWithTitle:(id)title withPoint:(CGPoint)point withMargin:(CGSize)marginSize withIcon:(UIImage *)imageIcon withFontSize:(CGFloat)fontSize;
- (id)initWithTitle:(id)title withPoint:(CGPoint)point withMargin:(CGSize)marginSize withIcon:(UIImage *)imageIcon;
- (id)initWithTitle:(id)title withPoint:(CGPoint)point withMargin:(CGSize)marginSize;
- (id)initWithTitle:(id)title withFrame:(CGRect)frame withIcon:(UIImage *)imageIcon;
- (id)initWithTitle:(id)title withFrame:(CGRect)frame;

@end

@protocol KyoTagViewDelegate <NSObject>

@optional
- (void)kyoTagViewTouchIn:(KyoTagView *)kyoTagView;

@end