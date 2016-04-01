//
//  PlayListView.h
//  PeoPleMusic
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListView : UIView



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottViewHeight;
+ (instancetype)createPlayListViewFromWindow;

- (void)show;
@property (nonatomic,copy) void(^reShowBlockOperation)();
- (void)close;

@end
