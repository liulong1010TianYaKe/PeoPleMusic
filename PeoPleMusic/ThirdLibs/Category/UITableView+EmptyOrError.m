//
//  UITableView+EmptyOrError.m
//  YWCat
//
//  Created by Kyo on 6/6/15.
//  Copyright (c) 2015 zhuniT All rights reserved.
//

#import "UITableView+EmptyOrError.h"
#import <objc/runtime.h>

static char kUITableViewEmptyOrErrorKey;

@implementation UITableView (EmptyOrError)

- (void)showEmptyOrError:(NSString *)tips {
    [self showEmptyOrError:tips withTop:4];
}

- (void)showEmptyOrError:(NSString *)tips withTop:(NSInteger)top {
    UILabel *lblTips = (UILabel *)objc_getAssociatedObject(self, &kUITableViewEmptyOrErrorKey);
    if (!lblTips) {
        lblTips = [self createTipsLabel:top];
    }
    lblTips.text = tips;
    lblTips.hidden = NO;
}

- (void)hideEmptyOrError {
    UILabel *lblTips = (UILabel *)objc_getAssociatedObject(self, &kUITableViewEmptyOrErrorKey);
    if (!lblTips) {
        lblTips = [self createTipsLabel:4];
    }
    lblTips.hidden = YES;
}

- (UILabel *)createTipsLabel:(NSInteger)top {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    lbl.textColor = YYColor(200, 200, 200);
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.center = CGPointMake(self.width / 2, lbl.frame.size.height/2 + top);
    lbl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    lbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lbl];
    objc_setAssociatedObject(self, &kUITableViewEmptyOrErrorKey, lbl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return lbl;
}

@end
