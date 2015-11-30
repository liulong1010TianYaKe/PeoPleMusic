//
//  NSDate+Convert.h
//  KidBookPhone
//
//  Created by Kyo on 5/15/14.
//  Copyright (c) 2014 Kyo. All rights reserved.
//

typedef enum
{
    DateTypeYear,
    DateTypeMonth,
    DateTypeDay,
    DateTypeWeek   //当前日期时一个星期中的星期几，1-7
}
DateType;

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

#import <Foundation/Foundation.h>

@interface NSDate (Convert)

//根据获取类型返回时间的数据
- (NSInteger)dateDataWithDateType:(DateType)dateType;
//返回时间的字典
- (NSMutableDictionary *)dateData;
- (NSString *)strDate;  //把日期转为字符串格式  2014-11-20
- (NSString *)strChineseDate;   //把日期转为字符串格式    yyyy年MM月dd日
- (NSString *)strLongDate;  //把日期转为字符串格式    yyyy-MM-dd HH:mm:ss
//根据传入的n天返回一个距离当前n天的NSDate
- (NSDate *)currentIntervalDateWithDay:(NSInteger)intervalDay;
//传入一个数字和类型，返回距离这个数字和类型的时间
- (NSDate *)dateAddNumber:(NSInteger)number withDateType:(DateType)dateType;
//根据传入的日期和指定类型，返回距离指定类型的时间 比如距离年数，举例年数后的月数，距离年数月数后的天数
- (NSInteger)getIntervalTime:(NSDate *)date withDateType:(DateType)dateType;
//字符串日期转为nsdate，输入的日期字符串形如：@"1992-05-21 13:08"
+ (NSDate *)dateFromString:(NSString *)dateString;
//字符串日期转为nsdate，输入的日期字符串形如：@"1992-05-21 13:08:00"
+ (NSDate *)dateFromStringWithTime:(NSString *)dateString;
//字符串日期转为nsdate，输入的日期字符串形如：@"1992年05月21日"
+ (NSDate *)dateFromStringCH:(NSString *)dateString;
//字符串日期转为，输入的日期字符串形如：@"1992-05-21"
+ (NSDate *)dateFromStringWithoutTime:(NSString *)dateString;
///判断传入的两个nadate是否处于同一天
+ (BOOL)isTheSameDayWithDay1:(NSDate *)day1 day2:(NSDate *)day2;


@end
