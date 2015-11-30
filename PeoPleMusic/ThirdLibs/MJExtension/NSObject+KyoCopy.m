//
//  NSObject+KyoCopy.m
//  JuMi
//
//  Created by Kyo on 14/1/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "NSObject+KyoCopy.h"
#import "NSObject+MJMember.h"

@implementation NSObject (KyoCopy)

- (id)copyWithZone:(NSZone *)zone
{
    if ([NSStringFromClass([self class]) isEqualToString:@"__NSCFType"]) {
        return self;
    } else {
        return [self copyZone:zone];
    }
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self mutableCopyZone:zone];
}

- (id)copyZone:(NSZone *)zone
{
    id copy = [[[self class] allocWithZone:zone] init];
    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        
        if ([[self valueForKey:ivar.propertyName] isKindOfClass:[NSArray class]]) { //深拷贝支持array
            NSMutableArray *arrayTemp = [NSMutableArray array];
            for (NSInteger i = 0; i < ((NSArray *)[self valueForKey:ivar.propertyName]).count; i++) {
                [arrayTemp addObject:[((NSArray *)[self valueForKey:ivar.propertyName])[i] copy]];
            }
            [copy setValue:arrayTemp forKey:ivar.propertyName];
        } else if ([[self valueForKey:ivar.propertyName] isKindOfClass:[NSDictionary class]]) { //深拷贝支持dictionary
            NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
            for (NSInteger i = 0; i < ((NSDictionary *)[self valueForKey:ivar.propertyName]).allKeys.count; i++) {
                id key = ((NSDictionary *)[self valueForKey:ivar.propertyName]).allKeys[i];
                [dictTemp setObject:[((NSDictionary *)[self valueForKey:ivar.propertyName]) objectForKey:key] forKey:key];
            }
            [copy setValue:dictTemp forKey:ivar.propertyName];
        } else {    //正常copy
            [copy setValue:[[self valueForKey:ivar.propertyName] copyWithZone:zone] forKey:ivar.propertyName];
        }
    }];
    
    return copy;
}

- (id)mutableCopyZone:(NSZone *)zone
{
    id copy = [[[self class] allocWithZone:zone] init];
    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        [copy setValue:[[self valueForKey:ivar.propertyName] copyWithZone:zone] forKey:ivar.propertyName];
    }];
    
    return copy;
}


@end
