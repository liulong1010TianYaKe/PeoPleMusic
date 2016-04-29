//
//  NSArray-Additions.h
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/14.
//  Copyright (c) 2014年 zhunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(Additions)

//通过;合并数组成string
- (NSString *)semicolonSeparatorString;
//通过|合并数组成string
- (NSString *)barSeparatorString;
//返回对应index的元素，但是加了try catch,避免越界
- (id)objectAtTheIndex:(NSUInteger)index;
- (id)theFirstObject;
- (id)theLastObject;

- (NSArray *)sortedArrayUsingIndexOfWeb;
- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path;
- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path ascending:(BOOL)ascending;

@end
