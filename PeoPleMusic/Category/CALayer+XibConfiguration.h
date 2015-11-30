//
//  CALayer+XibConfiguration.h
//  MainApp
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 hzins. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (XibConfiguration)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;
@end
