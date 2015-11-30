//
//  NSString+Convert.h
//  test-59-KeyChar
//
//  Created by Kyo on 5/9/14.
//  Copyright (c) 2014 Kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Convert)

- (NSString *)changeToHexFromString;  //从普通字符串转换为16进制
- (NSString *)changeToStringFromHex;    //从16进制转化为普通字符串

- (NSString *)changeToDecimalFromHex;  //从16进制转换为10进制



@end
