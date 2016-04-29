//
//  NSString+Validate.m
//  JuMi
//
//  Created by Yang Gaofeng on 15/1/8.
//  Copyright (c) 2015年 zhunit. All rights reserved.
//

#import "NSString+Validate.h"

@implementation NSString(Validate)

//验证11位手机号
- (BOOL)isValidateMobile
{
    @try {
        NSString *mobile = kRegex11Phone;
        if ([self rangeOfString:mobile options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}

//邮箱有效性验证验证
-(BOOL)isValidateEmail
{
    @try {
        NSString *emailRegex = kRegexEmail;
        if ([self rangeOfString:emailRegex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}

//密码规范验证（6-16位数字或字母）
-(BOOL)isValidatePassword
{
    @try {
        NSString *passwordRegex = kRegex6_20Any;
        if ([self rangeOfString:passwordRegex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}
// 姓名只能为2位以上汉字或英文字母
- (BOOL)isValidateCName{
    @try {
        NSString *regex = kRegex_CName;
        if ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}

- (BOOL)isValidateEName{
    @try {
        NSString *regex = kRegex_EName;
        if ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}
- (BOOL)isValidateAddress{
    @try {
        NSString *regex = kRegex_Address;
        if ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}
- (BOOL)isValidatePost{
    @try {
        NSString *regex = kRegex_Post;
        if ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}
//用户名验证（6-16位数字或字母，字母开头）
-(BOOL)isValidateUseName
{
    @try {
        NSString *regex = kRegex6_16EnglishOrNumber;
        if ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}


//用户名验证（6-16位数字或字母，字母开头）
-(BOOL)isValidateUseName2
{
    @try {
        NSString *regex = k1English;
        if ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}

//姓名
-(BOOL)isValidateFullName
{
    @try {
        NSString *regex = kRegex2_10Any;
        if ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}

//1到6位数字
-(BOOL)isValidateText
{
    @try {
        NSString *regex = kRegex1_6Number;
        if ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}

- (BOOL)isMatchedByRegex:(NSString *)pattern
{
    @try {
        NSString *regex = pattern;
        if ([self rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound &&
            [self rangeOfString:regex options:NSRegularExpressionSearch].length == self.length) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}

- (NSUInteger)indexOf:(NSString *)text {
    NSRange range = [self rangeOfString:text];
    if ( range.length > 0 ) {
        return range.location;
    } else {
        return NSNotFound;
    }
}


-(BOOL)verifyIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

//把str中跟正则相同的特殊字符加上\，变成正常字符
+ (NSString *)replaceRegexCharToNormal:(NSString *)str {
    //* . ? + $ ^ [ ] ( ) { } |
    str = [str stringByReplacingOccurrencesOfString:@"*" withString:@"\\*"];
    str = [str stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
    str = [str stringByReplacingOccurrencesOfString:@"?" withString:@"\\?"];
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"\\+"];
    str = [str stringByReplacingOccurrencesOfString:@"$" withString:@"\\$"];
    str = [str stringByReplacingOccurrencesOfString:@"^" withString:@"\\^"];
    str = [str stringByReplacingOccurrencesOfString:@"[" withString:@"\\["];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"];
    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
    str = [str stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
    str = [str stringByReplacingOccurrencesOfString:@"{" withString:@"\\{"];
    str = [str stringByReplacingOccurrencesOfString:@"}" withString:@"\\}"];
    str = [str stringByReplacingOccurrencesOfString:@"|" withString:@"\\|"];
    
    return str;
}

@end
