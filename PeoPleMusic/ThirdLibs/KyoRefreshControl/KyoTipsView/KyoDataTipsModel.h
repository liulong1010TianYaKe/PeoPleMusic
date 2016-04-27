//
//  KyoDataTipsModel.h
//  MainApp
//
//  Created by Kyo on 19/10/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ReloadDataBlock)();
typedef void (^OperationBlock)();

@interface KyoDataTipsModel : NSObject

@property (assign, nonatomic) BOOL isShowBGButton;  /**< 是否显示背景按钮 默认不显示 */
@property (nonatomic, strong) ReloadDataBlock reloadDataBlock;  /**< 点击背景重新加载的block */
@property (strong, nonatomic) UIImage *img; /**< 显示的图片 */
@property (strong, nonatomic) id tip;   /**< 提示文字，可以是富文本 */
@property (assign, nonatomic) BOOL isShowOperationButton;    /**< 是否显示按钮 默认不显示*/
@property (strong, nonatomic) id buttonText;    /**< 按钮的提示文字，可以是富文本 */
@property (strong, nonatomic) UIColor *buttonBackgroundColor;/**< 按钮的背景颜色颜色，默认红色,如果同时设置了按钮背景图片，此属性设置无效*/
@property (strong, nonatomic) UIColor *buttonTextColor; /**< 按钮的文字颜色，默认白色，富文本时无效 */
@property (assign, nonatomic) CGFloat buttonTextSize;   /**< 按钮字体大小，默认15 */
@property (assign, nonatomic) CGFloat operationButtonTop;  /**< 按钮距离上面的间距 默认16 */
@property (assign, nonatomic) CGFloat operationButtonWidth;  /**< 按钮宽度 默认kwindowwidth － 32 */
@property (assign, nonatomic) CGFloat operationButtonHeight; /**< 按钮高度 默认44 */
@property (strong, nonatomic) UIImage *imgOperationButtonNormal; /**< 按钮背景图片，正常情况 */
@property (strong, nonatomic) UIImage *imgOperationButtonHighight; /**< 按钮鳖精图片，高亮情况 */
@property (nonatomic, strong) OperationBlock operationBlock;   /**< 按钮点击的事件 */
@property (assign, nonatomic) CGFloat yScale;   /**< 整个tipsview对于scrollerview的y比例 默认1:1 */
@property (assign, nonatomic) CGFloat yOffset;   /**< 整个tipsview对于scrollview的y偏移 */

@end
