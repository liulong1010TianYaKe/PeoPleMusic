//
//  NSObject+MJCoding.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSObject+MJCoding.h"
#import "NSObject+MJMember.h"

@implementation NSObject (MJCoding)

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [self init]) {
        [self decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [self encode:encoder];
}

/**
 *  编码（将对象写入文件中）
 */
- (void)encode:(NSCoder *)encoder
{
    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        [encoder encodeObject:ivar.value forKey:ivar.name];
    }];
}

/**
 *  解码（从文件中解析对象）
 */
- (void)decode:(NSCoder *)decoder
{
    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        id value = [decoder decodeObjectForKey:ivar.name];
        if (value) {
            ivar.value =  value;
        }
    }];
}
@end
