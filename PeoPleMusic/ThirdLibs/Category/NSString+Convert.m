//
//  NSString+Convert.m
//  test-59-KeyChar
//
//  Created by Kyo on 5/9/14.
//  Copyright (c) 2014 Kyo. All rights reserved.
//

#import "NSString+Convert.h"
#include <stdlib.h>

@implementation NSString (Convert)

//从普通字符串转换为16进制
- (NSString *)changeToHexFromString
{
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    } 
    return hexStr;
    
}

//从16进制转化为普通字符串
- (NSString *)changeToStringFromHex
{
    char *myBuffer = (char *)malloc((int)[self length] / 2 + 1);
    bzero(myBuffer, [self length] / 2 + 1);
    for (int i = 0; i < [self length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [self substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];

    return unicodeString;
}

//从普通字符串转换为2进制
- (NSString *)changeToDecimalFromHex
{
    return [NSString stringWithFormat:@"%lld",strtoull([self UTF8String],0,16)]; ;   //16进制转换成10进制
}

@end
