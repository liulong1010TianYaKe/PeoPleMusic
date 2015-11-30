//
//  JMTipsView.m
//  JuMi
//
//  Created by Kyo on 27/11/14.
//  Copyright (c) 2014 hzins. All rights reserved.
//

#import "KyoTipsView.h"

@interface KyoTipsView()

@property (weak, nonatomic) IBOutlet UIImageView *imgvTips;

@end

@implementation KyoTipsView

#pragma mark -----------------------
#pragma mark - CycLife

- (id)initWithTitle:(NSString *)title
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"KyoTipsView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        
        if (kIsIphone6) {
            self.frame = CGRectMake(0, 0, 170 + 20, 195 + 20);   //IPHONE6加20
            self.imgvTips.frame = CGRectMake(18, 10, self.imgvTips.frame.size.width + 20, self.imgvTips.frame.size.height + 20);
            self.lblTips.font = [UIFont systemFontOfSize:12 + 1];
        } else if (kIsIphone6Plus) {
            self.frame = CGRectMake(0, 0, 170 + 40, 195 + 40);   //IPHONE6PLUS加40
            self.imgvTips.frame = CGRectMake(18, 10, self.imgvTips.frame.size.width + 40, self.imgvTips.frame.size.height + 40);
            self.lblTips.font = [UIFont systemFontOfSize:12 + 2];
        } else if (kIsIphone4 || kIsIphone5) {
            self.lblTips.y = self.lblTips.y - 10;
        }
        
        
        self.lblTips.text = title;
    }
    
    return self;
}

@end
