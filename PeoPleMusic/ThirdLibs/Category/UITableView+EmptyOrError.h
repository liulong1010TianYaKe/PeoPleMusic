//
//  UITableView+EmptyOrError.h
//  YWCat
//
//  Created by Kyo on 6/6/15.
//  Copyright (c) 2015 zhuniT All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyOrError)

- (void)showEmptyOrError:(NSString *)tips;
- (void)showEmptyOrError:(NSString *)tips withTop:(NSInteger)top;
- (void)hideEmptyOrError;

@end
