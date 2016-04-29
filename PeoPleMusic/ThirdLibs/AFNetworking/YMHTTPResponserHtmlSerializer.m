//
//  YMHTTPResponserHtmlSerializer.m
//  PeoPleMusic
//
//  Created by long on 4/29/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "YMHTTPResponserHtmlSerializer.h"

@implementation YMHTTPResponserHtmlSerializer


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                            @"text/html",
                                                            @"text/json",
                                                            @"text/plain",
                                                            @"text/javascript",
                                                            @"text/xml",
                                                            @"image/*"]];
    }
    return self;
}
#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
//    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
//        KyoLog(@"YMHTTPResponserHtmlSerializer validateResponse error ");
//        return nil;
//    }
    
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
