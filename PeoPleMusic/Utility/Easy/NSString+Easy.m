//
//  NSString+Easy.m
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import "NSString+Easy.h"

#import "NSDate+Easy.h"
#import "NSDateFormatter+Easy.h"
#import "ApplicationInfo.h"
#import "NSLocale+Easy.h"

@implementation NSString (Easy)

#pragma mark - Public

- (NSNumber *)numberValue
{
    if ([self isKindOfClass:[NSString class]]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [numberFormatter numberFromString:self];
    } else {
        return nil;
    }
}

- (NSString *)noneNullStringValue
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"(null)" withString:[NSString string]];
    //    result = [self stringByReplacingOccurrencesOfString:@"null" withString:[NSString string]];
    //    if ([result length] == 0) {
    //        result = [NSString string];
    //    }
    
    return result;
}

- (NSString *)clearNullStringValueOfServer
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"null" withString:[NSString string]];
    
    return result;
}

- (NSString *)clearPlaceholderStringValueOfServer
{
    NSString *result = [NSString string];
    if (self.length > 0) {
        NSString *pattern = @"<\\[<[\\w]*>\\]>";
        NSError *error = nil;
        NSRange range = NSMakeRange(0, self.length - 1);
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        //        NSArray *maches = [regularExpression matchesInString:self options:NSMatchingReportProgress range:range];
        //        for (NSTextCheckingResult *result in maches) {
        //            KyoLog(@"%@",[self substringWithRange:result.range]);
        //        }
        
        result = [regularExpression stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:range withTemplate:[NSString string]];
    }
    
    return result;
}

- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withTheString:(NSString *)replacement
{
    NSString *string = nil;
    @try {
        string = [self stringByReplacingOccurrencesOfString:target withString:replacement];
    }
    @catch (NSException *exception) {
        KyoLog(@"%@", exception.reason);
        string = self;
    }
    @finally {
        return string;
    }
}

///*
// @"yyyy-MM-dd HH:mm:ss"
// @"HH:mm:ss"
// */
//
//- (NSDate *)dateValueForServer
//{
//    NSDate *date = [self dateValueFromDateFormat:[ApplicationInfo sharedInfo].dateFormatForServer];
//    if (date == nil) {
//        KyoLog(@"Using date format without time zone.");
//        date = [self dateValueFromDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        if (date == nil) {
//            date = [self dateValueFromDateFormat:@"yyyy-MM-dd'T'HH:mmZ"];
//        }
//    }
//    return date;
//}

- (NSDate *)dateValueFromDateFormat:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:self];
}

- (NSDate *)dateValueWithDateFormatStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = style;
    dateFormatter.timeStyle = style;
    dateFormatter.locale = [NSLocale preferredLocale];
    return [dateFormatter dateFromString:self];
}

- (NSDate *)dateValueWithStyleShort
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterShortStyle];
}

- (NSDate *)dateValueWithStyleMedium
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterMediumStyle];
}

- (NSDate *)dateValueWithStyleLong
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterLongStyle];
}

- (NSDate *)dateValueWithStyleFull
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterFullStyle];
}

- (NSDate *)dateValueWithStylePrefered
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterShortStyle];
}

- (NSDate *)dateValueWithStylePreferedDateOnly
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [NSLocale preferredLocale];
    return [dateFormatter dateFromString:self];
}

- (NSDate *)dateValueWithStylePreferedTimeOnly
{
    NSDate *result = nil;
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.locale = [NSLocale preferredLocale];
        result = [dateFormatter dateFromString:self];
    }
    @catch (NSException *exception) {
        KyoLog(@"%@", exception.reason);
        result = [NSDate date];
    }
    @finally {
        return result;
    }
}

- (BOOL)notEmpty
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)encodedURLString
{
    return encodedURLStringWithEncoding(self, NSUTF8StringEncoding);
}

+ (NSString *)getNotNilTrueString:(NSString *)string
{
    if (string && string.length > 0) {
        return string;
    } else return @"";
}
#pragma mark - Private

- (BOOL)matchWithPattern:(NSString *)pattern {
    @try {
        if ([self rangeOfString:pattern options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}

static NSString * encodedURLStringWithEncoding(NSString *string, NSStringEncoding encoding)
{
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()',*";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
