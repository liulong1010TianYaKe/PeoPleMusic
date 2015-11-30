//
//  NSDate+Convert.m
//  KidBookPhone
//
//  Created by Kyo on 5/15/14.
//  Copyright (c) 2014 Kyo. All rights reserved.
//

#import "NSDate+Convert.h"

@implementation NSDate (Convert)

//根据获取类型返回传入的时间的数据
- (NSInteger)dateDataWithDateType:(DateType)dateType
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter;
    static NSCalendar *calendar;
    static NSDateComponents *comps;
    static NSInteger unitFlags;
    dispatch_once(&onceToken, ^{
        formatter =[[NSDateFormatter alloc] init];
        //NSDate *date_ = [NSDate date];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        comps = [[NSDateComponents alloc] init];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
    });
    
    
    //int week=0;week1是星期天,week7是星期六;
    
    comps = [calendar components:unitFlags fromDate:self];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //This sets the label with the updated time.
//    NSInteger hour = [comps hour];
//    NSInteger min = [comps minute];
//    NSInteger sec = [comps second];
//    KyoLog(@"week%ld",(long)week);
//    KyoLog(@"year%ld",(long)year);
//    KyoLog(@"month%ld",(long)month);
//    KyoLog(@"day%ld",(long)day);
//    KyoLog(@"hour%ld",(long)hour);
//    KyoLog(@"min%ld",(long)min);
//    KyoLog(@"sec%ld",(long)sec);
    
    switch (dateType)
    {
        case DateTypeYear:
        {
            return year;
            break;
        }
        case DateTypeDay:
        {
            return day;
            break;
        }
        case DateTypeMonth:
        {
            return month;
            break;
        }
        case DateTypeWeek:
        {
            week = week - 1;
            if (week == 0)  //根据上面的 1是星期天 7是星期六 所以 －1后等于0的是星期天
            {
                week = 7;
            }
            return week;
            break;
        }
        default:
            break;
    }
}

//返回时间的字典
- (NSMutableDictionary *)dateData
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter;
    static NSCalendar *calendar;
    static NSDateComponents *comps;
    static NSInteger unitFlags;
    dispatch_once(&onceToken, ^{
        formatter =[[NSDateFormatter alloc] init];
        //NSDate *date_ = [NSDate date];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        comps = [[NSDateComponents alloc] init];
        unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
    });
    
    
    //int week=0;week1是星期天,week7是星期六;
    
    comps = [calendar components:unitFlags fromDate:self];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //This sets the label with the updated time.
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
//    KyoLog(@"week%ld",(long)week);
//    KyoLog(@"year%ld",(long)year);
//    KyoLog(@"month%ld",(long)month);
//    KyoLog(@"day%ld",(long)day);
//    KyoLog(@"hour%ld",(long)hour);
//    KyoLog(@"min%ld",(long)min);
//    KyoLog(@"sec%ld",(long)sec);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:7];
    [dict setObject:@(year) forKey:@"year"];
    [dict setObject:@(month) forKey:@"month"];
    [dict setObject:@(day) forKey:@"day"];
    [dict setObject:@(week) forKey:@"week"];
    [dict setObject:@(hour) forKey:@"hour"];
    [dict setObject:@(min) forKey:@"min"];
    [dict setObject:@(sec) forKey:@"sec"];
    
    return dict;
}

//把日期转为字符串格式  2014-11-20
- (NSString *)strDate
{
    static dispatch_once_t onceToken;
    static  NSDateFormatter *dateFormatter = nil;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}

//把日期转为字符串格式    yyyy年MM月dd日
- (NSString *)strChineseDate {
    static dispatch_once_t onceToken;
    static  NSDateFormatter *dateFormatter = nil;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    });
    
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}

//把日期转为字符串格式    yyyy-MM-dd HH:mm:ss
- (NSString *)strLongDate {
    static dispatch_once_t onceToken;
    static  NSDateFormatter *dateFormatter = nil;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}

//根据传入的n天返回一个距离当前n天的NSDate
- (NSDate *)currentIntervalDateWithDay:(NSInteger)intervalDay
{
//    NSDate *currentDate = [NSDate date];
    NSInteger interval = intervalDay * 60 * 60 * 24;
    return [self dateByAddingTimeInterval:interval];
}

//传入一个数字和类型，返回距离这个数字和类型的时间
- (NSDate *)dateAddNumber:(NSInteger)number withDateType:(DateType)dateType
{
    static dispatch_once_t onceToken;
    static NSCalendar *calendar;
    static NSDateComponents *adcomps = nil;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        adcomps = [[NSDateComponents alloc] init];
    });
    
//    NSDateComponents *comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    
    adcomps.year = dateType == DateTypeYear ? number : 0;
    adcomps.month = dateType == DateTypeMonth ? number : 0;
    adcomps.day = dateType == DateTypeDay ? number : 0;
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    
    return newdate;
}

//根据传入的日期和指定类型，返回距离指定类型的时间 比如距离年数，举例年数后的月数，距离年数月数后的天数
- (NSInteger)getIntervalTime:(NSDate *)date withDateType:(DateType)dateType
{
    static dispatch_once_t onceToken;
    static NSCalendar *calendar;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    });
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    
    KyoLog(@"Difference in date components: %ld/%ld/%ld", (long)components.day, (long)components.month, (long)components.year);
    
    if (dateType == DateTypeYear) {
        return components.year;
    } else if (dateType == DateTypeMonth) {
        return components.month;
    } else if (dateType == DateTypeDay) {
        return components.day;
    } else {
        return components.year;
    }
}

//字符串日期转为nsdate，输入的日期字符串形如：@"1992-05-21 13:08"
+ (NSDate *)dateFromString:(NSString *)dateString
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    });
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//字符串日期转为nsdate，输入的日期字符串形如：@"1992-05-21 13:08:00"
+ (NSDate *)dateFromStringWithTime:(NSString *)dateString
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    });
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//字符串日期转为nsdate，输入的日期字符串形如：@"1992年05月21日"
+ (NSDate *)dateFromStringCH:(NSString *)dateString
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
    });
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//字符串日期转为nsdate，输入的日期字符串形如：@"1992-05-21"
+ (NSDate *)dateFromStringWithoutTime:(NSString *)dateString
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    });
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//判断传入的两个nadate是否处于同一天
+ (BOOL)isTheSameDayWithDay1:(NSDate *)day1 day2:(NSDate *)day2
{
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    if (
        (int)(([day1 timeIntervalSince1970] + timezoneFix)/(24*3600)) -
        (int)(([day2 timeIntervalSince1970] + timezoneFix)/(24*3600))
        == 0)
    {
        return YES;
    }
    return NO;
}

@end
