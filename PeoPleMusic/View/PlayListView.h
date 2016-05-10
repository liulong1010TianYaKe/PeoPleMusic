//
//  PlayListView.h
//  PeoPleMusic
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 zhuniT All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottViewHeight;
+ (instancetype)createPlayListViewFromWindow;
@property (nonatomic, strong) NSMutableArray *songList;
- (void)show;
@property (nonatomic,copy) void(^reShowBlockOperation)();
- (void)close;

@end

