//
//  NSObject+Mapping.h
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

@interface NSObject (Mapping)

@property (readonly, copy, nonatomic) NSString *propertyIndex;

+ (NSSortDescriptor *)sortDescriptorForPropertyIndex;

- (NSDictionary *)propertyDictionary;
- (NSDictionary *)dictionaryValue;

/*
 JSON
 */
- (NSData *)JSONData;

- (NSString *)JSONString;

- (void)setClass:(Class)aClass ofObjectsInArrayForKeyPath:(NSString *)path;

- (void)makeMappingForKeyPath:(NSString *)path toKeyPath:(NSString *)toPath;

- (id)valueOfClass:(Class)aClass forJSONDictionary:(NSDictionary *)dictionary;

- (id)valueOfClass:(Class)aClass forJSONArray:(NSArray *)array;

@end;
