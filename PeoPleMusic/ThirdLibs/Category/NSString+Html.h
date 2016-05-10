//
//  NSString+Html.h
//  KidBookPhone
//
//  Created by Kyo on 7/2/14.
//  Copyright (c) 2014 zhuniT All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Html)

- (NSString *)matchHtmlToClearWithtrimWhiteSpace:(BOOL)trim;    //把html的标签去掉

- (NSString *)encodeToPercentEscapeString;  //url的 encode
- (NSString *)decodeFromPercentEscapeString;    //url的 解码

@end
