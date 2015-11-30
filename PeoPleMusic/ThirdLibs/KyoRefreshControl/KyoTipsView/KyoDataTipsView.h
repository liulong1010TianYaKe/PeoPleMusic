//
//  KyoDataTipsView.h
//  MainApp
//
//  Created by Kyo on 19/10/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KyoDataTipsModel.h"

@interface KyoDataTipsView : UIView

@property (assign, nonatomic) UIEdgeInsets scrollViewDefaultInsets;
@property (strong, nonatomic) KyoDataTipsModel *kyoDataTipsModel;

- (id)initWithScrollView:(UIScrollView *)scrollView;

@end
