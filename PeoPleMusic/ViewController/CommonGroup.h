//
// JMCommonGroup.h
//  聚米
//
//  Created by hzins on 14-11-02.
//  Copyright (c) 2014年 hzins. All rights reserved.
//
//  用一个JMCommonGroup模型来描述每组的信息：组头、组尾、这组的所有行模型

#import <Foundation/Foundation.h>

@interface CommonGroup : NSObject
/** 组头 */
@property (nonatomic, copy) NSString *header;
/** 组尾 */
@property (nonatomic, copy) NSString *footer;
/** 这组的所有行模型(数组中存放的都是JMCommonItem模型) */
@property (nonatomic, strong) NSArray *items;

+ (instancetype)group;
@end
