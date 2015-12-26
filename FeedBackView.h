//
//  FeedBackView.h
//  PeoPleMusic
//
//  Created by apple on 15/12/25.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackView : UIView

+ (instancetype)createFeedBackViewFromWindow;
- (void)show;

- (void)close;
@end
