//
//  NSDate+Easy.h
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>

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
