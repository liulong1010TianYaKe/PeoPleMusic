//
//  NSLocale+Easy.m
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import "NSLocale+Easy.h"


#import "NSObject+Easy.h"
#import "ApplicationInfo.h"

@implementation NSLocale (Easy)

//+ (NSString *)localeIdentifierFromOldLanguage:(NSString *)language
//{
//    //    KyoLog(@"%@", [NSLocale availableLocaleIdentifiers]);
//    NSString *result = @"en";
//    
//    if ([language isEqualToString:@"en_US"]) {
//        result = @"en";
//    } else if ([language isEqualToString:@"es_ES"]) {
//        result = @"en-ES";
//    } else if ([language isEqualToString:@"zh_CN"]) {
//        result = @"zh-Hans";
//    } else if ([language isEqualToString:@"zh_TW"]) {
//        result = @"zh-Hant";
//    } else if ([language isEqualToString:@"ja_JP"]) {
//        result = @"ja-JP";
//    } else if ([language isEqualToString:@"ko_KR"]) {
//        result = @"ko-KR";
//    } else if ([language isEqualToString:@"pt_PT"]) {
//        result = @"pt-PT";
//    } else if ([language isEqualToString:@"th_TH"]) {
//        result = @"th-TH";
//    } else if ([language isEqualToString:@"vi_VN"]) {
//        result = @"vi-VN";
//    }
//    
//    return result;
//}

+ (NSLocale *)preferredLocale
{
    NSLocale *locale = [NSLocale currentLocale];
//    NSString *languageID = [ApplicationInfo sharedInfo].languageID;
//    if (languageID) {
//        locale = [[NSLocale alloc] initWithLocaleIdentifier:[self localeIdentifierFromOldLanguage:languageID]];
//    }
    
    return locale;
}

@end