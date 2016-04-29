//
//  CALayer+XibConfiguration.m
//  MainApp
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 zhunit. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
