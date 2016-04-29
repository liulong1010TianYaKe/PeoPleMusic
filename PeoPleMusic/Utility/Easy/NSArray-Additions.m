//
//  NSArray-Additions.m
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/14.
//  Copyright (c) 2014年 zhunit. All rights reserved.
//

#import "NSArray-Additions.h"
#import "NSString+Easy.h"
@import CoreData;

@implementation NSArray(Additions)

- (NSString *)semicolonSeparatorString{
    return [self componentsJoinedByString:@";"];
}

- (NSString *)barSeparatorString{
    return [self componentsJoinedByString:@"|"];
}

- (id)objectAtTheIndex:(NSUInteger)index
{
    id result = nil;
    @try {
        result = [self objectAtIndex:index];
    }
    @catch (NSException *exception) {
        KyoLog(@"%@",exception.reason);
    }
    @finally {
        return result;
    }
}

- (id)theFirstObject
{
    return [self objectAtTheIndex:0];
}

- (id)theLastObject
{
    if (self.count >= 1) {
        return [self objectAtTheIndex:self.count - 1];
    } else {
        return [self objectAtTheIndex:0];
    }
}

- (NSArray *)sortedArrayUsingIndexOfWeb
{
    NSArray *result = nil;
    @try {
        result = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSManagedObject *object = obj1;
            NSManagedObject *objectAnother = obj2;
            NSNumber *objectIDNumber = [[[[[[[object objectID] URIRepresentation] absoluteString] componentsSeparatedByString:@"/"] lastObject] substringFromIndex:1] numberValue];
            NSNumber *objectIDNumberAnother = [[[[[[[objectAnother objectID] URIRepresentation] absoluteString] componentsSeparatedByString:@"/"] lastObject] substringFromIndex:1] numberValue];
            return [objectIDNumber compare:objectIDNumberAnother];
        }];
    }
    @catch (NSException *exception) {
        KyoLog(@"%@", exception.reason);
    }
    @finally {
        if (result.count == 0) {
            result = self;
        }
        return result;
    }
}

- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path
{
    return [self sortedArrayUsingKeyPath:path ascending:NO];
}

- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path ascending:(BOOL)ascending
{
    NSArray *result = nil;
    @try {
        result = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSManagedObject *object = obj1;
            NSManagedObject *objectAnother = obj2;
            NSNumber *number = [[object valueForKeyPath:path] numberValue];
            NSNumber *numberAnother = [[objectAnother valueForKeyPath:path] numberValue];
            if (ascending) {
                return [number compare:numberAnother];
            } else {
                return [numberAnother compare:number];
            }
        }];
    }
    @catch (NSException *exception) {
        KyoLog(@"%@", exception.reason);
    }
    @finally {
        if (result.count == 0) {
            result = self;
        }
        return result;
    }
}

@end
