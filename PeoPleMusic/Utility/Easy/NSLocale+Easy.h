//
//  NSLocale+Easy.h
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLocale (Easy)

//+ (NSString *)localeIdentifierFromOldLanguage:(NSString *)language;
+ (NSLocale *)preferredLocale;

@end
