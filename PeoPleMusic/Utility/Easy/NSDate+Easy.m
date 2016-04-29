//
//  NSDate+Easy.m
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 zhunit. All rights reserved.
//

#import "NSDate+Easy.h"
#import "NSString+Easy.h"
#import "NSDateFormatter+Easy.h"
#import "NSLocale+Easy.h"
#import "NSTimeZone+Easy.h"
//#import "NSCalendar+Easy.h"
//#import "LocalizationSystem.h"
#import "NSObject+Easy.h"

#import "ApplicationInfo.h"

@implementation NSDate (Easy)

- (NSString *)prettyDate
{
    NSDateComponents *comps = [self getDateComponents];
    if (comps.day > 0) {
        // HANDLE DAYS
        if (comps.day == 1 || comps.day == 2) {
            return [NSString stringWithFormat:NSLocalizedString(@"%d days ago", nil), comps.day];
        }
        return [self stringValue];
    } else if (comps.hour > 0) {
        // HANDLE HOURS
//        if (comps.hour == 1) return NSLocalizedString(@"last hour", nil);
        return [NSString stringWithFormat:NSLocalizedString(@"%d hours ago", nil), comps.hour];
    } else {
        // HANDLE SECONDS
        return comps.second < 0 ? NSLocalizedString(@"future date", nil) : NSLocalizedString(@"just now", nil);
    }
    return [self stringValue];
}

- (NSDateComponents *)getDateComponents
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSSecondCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSWeekCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    return [sysCalendar components:unitFlags fromDate:self toDate:[NSDate date] options:0];
}

//+ (id)dateWithDate:(NSDate *)date time:(NSDate *)time
//{
//    NSTimeZone *timeZone = [NSTimeZone noneDaylightSavingTimeTimeZone];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    //    NSDateComponents *dayComponents = [calendar dayComponentsFromDate:day];
//    //    dayComponents.timeZone = timeZone;
//    //    NSDate *day = [calendar dateFromComponents:dayComponents];
//    
//    NSDateComponents *timeComponents = [calendar timeComponentsFromDate:time];
//    timeComponents.timeZone = timeZone;
//    NSDate *result = [calendar dateByAddingComponents:timeComponents toDate:date options:NSCalendarWrapComponents];
//    
//    return result;
//}
//
- (NSString *)stringValue
{
    return [self stringValueFromDateFormat:kDateFormat_yyyy_M_d_Chinese];
}

- (NSString *)stringValueLong
{
    return [self stringValueFromDateFormat:kDateFormat_yyyy_M_d_HH_mm_Chinese];
}

- (NSString *)iSO8601string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:kDateFormatISO8601];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringValueFromDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    if ([dateFormat isKindOfClass:[NSString class]]) {
        [dateFormatter setDateFormat:dateFormat];
    }
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringValueWithDateFormatStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = style;
    dateFormatter.timeStyle = style;
    dateFormatter.locale = [NSLocale preferredLocale];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringValueWithStyleShort
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterShortStyle];
}

- (NSString *)stringValueWithStyleMedium
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterMediumStyle];
}

- (NSString *)stringValueWithStyleLong
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterLongStyle];
}

- (NSString *)stringValueWithStyleFull
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterFullStyle];
}


- (NSString *)stringValueWithStylePrefered
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterShortStyle];
}

- (NSString *)stringValueWithStylePreferedDateOnly
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [NSLocale preferredLocale];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringValueWithStylePreferedTimeOnly
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [NSLocale preferredLocale];
    return [dateFormatter stringFromDate:self];
}

- (NSDate *)noneDaylightSavingTimeDate
{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval daylightSavingTimeOffset = [timeZone daylightSavingTimeOffset];
    return [self dateByAddingTimeInterval:- daylightSavingTimeOffset];
}

- (NSDate *)noneDaylightSavingTimeDateForDateComponents
{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval daylightSavingTimeOffset = [timeZone daylightSavingTimeOffset];
    return [self dateByAddingTimeInterval:daylightSavingTimeOffset];
}

- (BOOL)earlierThanDate:(NSDate *)anotherDate
{
    BOOL result = NO;
    if ([anotherDate isKindOfClass:[NSDate class]]) {
        if ([self compare:anotherDate] == NSOrderedAscending) {
            result = YES;
        }
    }
    
    return result;
}

- (BOOL)laterThanDate:(NSDate *)anotherDate
{
    BOOL result = NO;
    if ([anotherDate isKindOfClass:[NSDate class]]) {
        if ([self compare:anotherDate] == NSOrderedDescending) {
            result = YES;
        }
    }
    
    return result;
}

- (BOOL)earlierThanOrEqualToDate:(NSDate *)anotherDate
{
    BOOL result = NO;
    if ([anotherDate isKindOfClass:[NSDate class]]) {
        if ([self compare:anotherDate] != NSOrderedDescending) {
            result = YES;
        }
    }
    
    return result;
}

- (BOOL)laterThanOrEqualToDate:(NSDate *)anotherDate
{
    BOOL result = NO;
    if ([anotherDate isKindOfClass:[NSDate class]]) {
        if ([self compare:anotherDate] != NSOrderedAscending) {
            result = YES;
        }
    }
    
    return result;
}

- (NSDate *)theDayBeforeYesterday
{
    return [self dateByAddingDays:-2];
}

- (NSDate *)yesterday
{
    return [self dateByAddingDays:-1];
}

- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

- (NSDate *)tomorrow
{
    return [self dateByAddingDays:1];
}

- (NSDate *)theDayAfterTomorrow
{
    return [self dateByAddingDays:2];
}

- (NSDate *)midnight
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    NSDate *date = [calendar dateFromComponents:dateComponents];
    return date;
}

- (NSDate *)midday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [dateComponents setHour:12];
    NSDate *date = [calendar dateFromComponents:dateComponents];
    return date;
}

- (NSDate *)dateBySettingHour:(NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [dateComponents setHour:hour];
    NSDate *date = [calendar dateFromComponents:dateComponents];
    return date;
}

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSInteger)thisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    return [dateComponents year];
}

- (NSInteger)thisMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    return [dateComponents month];
}

- (NSInteger)thisDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit fromDate:[NSDate date]];
    return [dateComponents day];
}

- (NSInteger)thisHour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSHourCalendarUnit fromDate:[NSDate date]];
    return [dateComponents hour];
}

- (NSInteger)thisMinute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:[NSDate date]];
    return [dateComponents minute];
}

- (NSInteger)thisSecond
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSSecondCalendarUnit fromDate:[NSDate date]];
    return [dateComponents second];
}

- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:self];
    return [dateComponents year];
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit fromDate:self];
    return [dateComponents month];
}

- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit fromDate:self];
    return [dateComponents day];
}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSHourCalendarUnit fromDate:self];
    return [dateComponents hour];
}

- (NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:self];
    return [dateComponents minute];
}

- (NSInteger)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSSecondCalendarUnit fromDate:self];
    return [dateComponents second];
}

@end