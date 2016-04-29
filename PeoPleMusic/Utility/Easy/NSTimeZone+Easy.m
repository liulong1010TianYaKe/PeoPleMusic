//
//  NSTimeZone+Easy.m
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 zhunit. All rights reserved.
//

#import "NSTimeZone+Easy.h"

@implementation NSTimeZone (Easy)

+ (NSTimeZone *)noneDaylightSavingTimeTimeZone
{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    if ([timeZone isDaylightSavingTime]) {
        NSTimeInterval secondsFromGMT = [timeZone secondsFromGMT] - [timeZone daylightSavingTimeOffset];
        return [NSTimeZone timeZoneForSecondsFromGMT:secondsFromGMT];
    } else {
        return timeZone;
    }
}

@end
