//
//  ChaboView.h
//  PeoPleMusic
//
//  Created by apple on 15/12/26.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChaboView : UIView
+ (instancetype)createChaboViewFromWindow;
- (void)show;
@property (nonatomic, copy) void (^btnSubmitBlockOperation)();
- (void)close;
@end
