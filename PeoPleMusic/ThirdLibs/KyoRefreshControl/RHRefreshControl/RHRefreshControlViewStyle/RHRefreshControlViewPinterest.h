//
//  RHRefreshControlViewPinterest.h
//  Example
//
//  Created by Ratha Hin on 2/2/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHRefreshControlView.h"

@interface RHRefreshControlViewPinterest : UIView <RHRefreshControlView>

@property (strong, nonatomic) UIColor *fillColor;   /**< 填充颜色 */
@property (strong, nonatomic) UIColor *strokeColor; /**< 边框颜色 */
@property (strong, nonatomic) UIImage *imgContent;  /**< 填充图片 */

- (void)reChangeSubViewOrgin;   //重置子视图的坐标

@end
