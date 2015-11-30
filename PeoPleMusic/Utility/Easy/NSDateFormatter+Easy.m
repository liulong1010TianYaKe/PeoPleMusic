//
//  NSDateFormatter+Easy.m
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import "NSDateFormatter+Easy.h"

@implementation NSDateFormatter (Easy)

- (NSDateFormatter *)englishLocaleDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return dateFormatter;
}

@end
