//
//  JMTipsView.h
//  JuMi
//
//  Created by Kyo on 27/11/14.
//  Copyright (c) 2014 hzins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView-WhenTappedBlocks.h"

@interface KyoTipsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTips;

- (id)initWithTitle:(NSString *)title;

@end
