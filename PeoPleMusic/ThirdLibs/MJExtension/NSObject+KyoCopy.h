//
//  NSObject+KyoCopy.h
//  JuMi
//
//  Created by Kyo on 14/1/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KyoCopy)

- (id)copyZone:(NSZone *)zone;

/**
 复制的实现
 */
//#define KyoCopyImplementation \
//- (id)copyWithZone:(NSZone *)zone \
//{ \
//return [self copyZone:zone]; \
//}

@end
