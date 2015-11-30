//
//  NSString+Html.m
//  KidBookPhone
//
//  Created by Kyo on 7/2/14.
//  Copyright (c) 2014 Kyo. All rights reserved.
//

#import "NSString+Html.h"

@implementation NSString (Html)

- (NSString *)matchHtmlToClearWithtrimWhiteSpace:(BOOL)trim
{
    NSString *str = [self copy];
    NSScanner *theScanner = [NSScanner scannerWithString:str];
    NSString *text = nil;
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        str = [str stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
    
    return trim ? [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : str;
}

//url的 encode
- (NSString *)encodeToPercentEscapeString {
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)self,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    return
    outputStr;
}

//url的 解码
- (NSString *)decodeFromPercentEscapeString
{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, outputStr.length)];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
