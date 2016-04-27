//
//  NSDate+Easy.h
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString * const kDateFormatISO8601 = @"yyyy-MM-dd'T'HH:mm:ssZ";
static NSString * const kDateFormat_yyyy_M_d_slash = @"yyyy/M/d";
static NSString * const kDateFormat_yyyy_MM_dd = @"yyyy-MM-dd";
static NSString * const kDateFormat_yyyy_MM_ddTHH_mm_ss = @"yyyy-MM-dd'T'HH:mm:ss";
static NSString * const kDateFormat_yyyy_MM_dd_HH_mm = @"yyyy-MM-dd HH:mm";
static NSString * const kDateFormat_yyyy_MM_dd_H_mm = @"yyyy-MM-dd H:mm";
static NSString * const kTimeFormat_H_mm = @"H:mm";
static NSString * const KtimeFormat_yyyy_MM_ddTHH_mm_ss_SSS = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
//Date format for date Display
static NSString * const kDateFormat_yyyy_M_d_HH_mm_Chinese = @"yyyy年M月d日 HH:mm";
static NSString * const kDateFormat_yyyy_M_d_Chinese = @"yyyy年M月d日";
static NSString * const kDateFormat_M_d = @"M-d";
static NSString * const kTimeFormat_HH_mm = @"HH:mm";
static NSString * const kTimeFormat_MM_DD_HH_mm = @"MM-dd  HH:mm";


@interface NSDate (Easy)

//+ (id)dateWithDate:(NSDate *)date time:(NSDate *)time;

- (NSString *)prettyDate;

- (NSDateComponents *)getDateComponents;
- (NSString *)stringValue;
- (NSString *)stringValueLong;
- (NSString *)iSO8601string;
- (NSString *)stringValueFromDateFormat:(NSString *)dateFormat;
- (NSString *)stringValueWithDateFormatStyle:(NSDateFormatterStyle)style;

/*
 NSDateFormatterShortStyle = kCFDateFormatterShortStyle,
 NSDateFormatterMediumStyle = kCFDateFormatterMediumStyle,
 NSDateFormatterLongStyle = kCFDateFormatterLongStyle,
 NSDateFormatterFullStyle = kCFDateFormatterFullStyle
 */

- (NSString *)stringValueWithStyleShort;
- (NSString *)stringValueWithStyleMedium;
- (NSString *)stringValueWithStyleLong;
- (NSString *)stringValueWithStyleFull;

- (NSString *)stringValueWithStylePrefered;
- (NSString *)stringValueWithStylePreferedDateOnly;
- (NSString *)stringValueWithStylePreferedTimeOnly;

- (NSDate *)noneDaylightSavingTimeDate;
- (NSDate *)noneDaylightSavingTimeDateForDateComponents;

- (BOOL)earlierThanDate:(NSDate *)anotherDate;
- (BOOL)laterThanDate:(NSDate *)anotherDate;

- (BOOL)earlierThanOrEqualToDate:(NSDate *)anotherDate;
- (BOOL)laterThanOrEqualToDate:(NSDate *)anotherDate;

- (NSDate *)theDayBeforeYesterday;
- (NSDate *)yesterday;
- (NSDate *)tomorrow;
- (NSDate *)theDayAfterTomorrow;
- (NSDate *)midnight;
- (NSDate *)midday;
- (NSDate *)dateBySettingHour:(NSInteger)hour;
- (BOOL) isToday;
//- (NSDate *) dateByAddingDays: (NSInteger) dDays;
//- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;

- (NSInteger)thisYear;
- (NSInteger)thisMonth;
- (NSInteger)thisDay;
- (NSInteger)thisHour;
- (NSInteger)thisMinute;
- (NSInteger)thisSecond;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;

@end
