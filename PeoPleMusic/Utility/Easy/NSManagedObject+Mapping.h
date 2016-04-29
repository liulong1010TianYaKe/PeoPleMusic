//
//  NSManagedObject+Mapping.h
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 zhunit. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Mapping)

//@property (strong, nonatomic) NSNumber *sortID;

+ (instancetype)managedObjectForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (NSDictionary *)dictionaryValue;

- (void)makePropertyNamesMappingForKey:(NSString *)key sourceKey:(NSString *)sourceKey;

+ (void)logAllInManagedObjectContext:(NSManagedObjectContext *)context;
- (void)logAll;

@end
