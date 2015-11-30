//
//  NSMutableArray-Additions.m
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/15.
//  Copyright (c) 2014年 hzins. All rights reserved.
//
#import "NSMutableArray-Additions.h"

@implementation NSMutableArray (Additions)

- (void)addTheObject:(id)anObject
{
    @try {
        [self addObject:anObject];
    }
    @catch (NSException *exception) {
        KyoLog(@"%@",exception.reason);
    }
    @finally {
        
    }
}

- (void)addTheObjectsFromArray:(NSArray *)array
{
    @try {
        [self addObjectsFromArray:array];
    }
    @catch (NSException *exception) {
        KyoLog(@"%@",exception.reason);
    }
    @finally {
        
    }
}

@end

