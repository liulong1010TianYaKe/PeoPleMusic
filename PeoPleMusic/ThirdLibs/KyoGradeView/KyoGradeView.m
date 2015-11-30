//
//  GradeView.m
//  XFLH
//
//  Created by Kyo on 7/19/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoGradeView.h"
#include <objc/runtime.h>

@interface KyoGradeView()


- (NSDictionary *)getPropertyNameList;  //获取所有属性
- (void)observeAllProperty; //监听所有属性变化
- (void)removeObserveAllProperty;   //移除监听所有属性变化

@end

@implementation KyoGradeView

#pragma mark ----------------
#pragma mark - Cyclife

- (id)init {
    self = [super init];
    if (self) {
        _fullScore = 10.0;
        _currentScore = 0;
        _numberOfStart = 5;
        [self observeAllProperty];  //监听所有属性变化
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self observeAllProperty];  //监听所有属性变化
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserveAllProperty];    //移除监听所有属性变化
}

- (void)drawRect:(CGRect)rect {
    CGFloat sectionHalf = _fullScore / _numberOfStart / 2.0;  //每半颗星的区间值
    CGFloat sectionFull = _fullScore / _numberOfStart;  //每半颗星的区间值
    CGFloat y = self.height / 2.0;
    CGFloat x = self.width / _numberOfStart;
    
    for (NSInteger i = 1; i <= _numberOfStart; i++) {
        if (_currentScore >= i * sectionFull) {  //满星
            [_fullStart drawAtPoint:CGPointMake((x - _fullStart.size.width / 2) * i, y - _fullStart.size.height / 2)];
        } else if (_currentScore >= ((i - 1) * sectionFull) + sectionHalf) {  //半星
            [_halfStart drawAtPoint:CGPointMake((x - _halfStart.size.width / 2) * i, y - _halfStart.size.height / 2)];
        } else {  //空星
            [_emptyStart drawAtPoint:CGPointMake((x - _emptyStart.size.width / 2) * i, y - _emptyStart.size.height / 2)];
        }
    }
}

#pragma mark ----------------
#pragma mark - Methods

//获取所有属性
- (NSDictionary *)getPropertyNameList {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *propertyNameDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *propertyAttributes = property_getAttributes(properties[i]);
        const char *propertyName = property_getName(properties[i]);
        [propertyNameDictionary setObject:[NSString stringWithUTF8String: propertyAttributes] forKey:[NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertyNameDictionary;
}

//监听所有属性变化
- (void)observeAllProperty {
    NSDictionary *dictProperty = [self getPropertyNameList];
    for (NSInteger i = 0; i < dictProperty.allKeys.count; i++) {
        [self addObserver:self forKeyPath:dictProperty.allKeys[i] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
}

//移除监听所有属性变化
- (void)removeObserveAllProperty {
    NSDictionary *dictProperty = [self getPropertyNameList];
    for (NSInteger i = 0; i < dictProperty.allKeys.count; i++) {
        [self removeObserver:self forKeyPath:dictProperty.allKeys[i]];
    }
    
}

#pragma mark ----------------
#pragma mark - KVC/KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}

@end
