//
//  NSString+Easy.h
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Easy)

- (NSNumber *)numberValue;
- (NSString *)noneNullStringValue;
- (NSString *)clearNullStringValueOfServer;
- (NSString *)clearPlaceholderStringValueOfServer;
- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withTheString:(NSString *)replacement;
- (NSDate *)dateValueFromDateFormat:(NSString *)dateFormat;

- (BOOL)notEmpty;
- (NSString *)trim;

- (NSString *)encodedURLString;

//- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
//- (CGFloat)heightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

+ (NSString *)getNotNilTrueString:(NSString *)string;

@end