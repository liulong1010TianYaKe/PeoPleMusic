//
//  FeedBackView.h
//  PeoPleMusic
//
//  Created by apple on 15/12/25.
//  Copyright © 2015年 zhuniT All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackView : UIView

+ (instancetype)createFeedBackViewFromWindow;
- (void)show;
@property (nonatomic, copy) void(^btnSubmitBlockOperation)();
- (void)close;
@end
