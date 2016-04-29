//
//  NSManagedObject+Mapping.m
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 zhunit. All rights reserved.
//

#import "NSManagedObject+Mapping.h"

#import <objc/runtime.h>

#import "NSManagedObject+Mapping.h"

#import "NSObject+Mapping.h"
#import "NSManagedObjectContext+Easy.h"

//#import "Image.h"
#import "NSString+Easy.h"

//static char SortIDKey;
static char PropertyNamesMappingKey;

@interface NSManagedObject ()

@property (strong, nonatomic) NSMutableDictionary *propertyNamesMapping;

@end

@implementation NSManagedObject (Mapping)

#pragma mark - Private

- (NSMutableDictionary *)propertyNamesMapping
{
    return objc_getAssociatedObject(self, &PropertyNamesMappingKey);
}

- (void)setPropertyNamesMapping:(NSMutableDictionary *)propertyNamesMapping
{
    [self willChangeValueForKey:@"propertyNamesMapping"];
    objc_setAssociatedObject(self, &PropertyNamesMappingKey, propertyNamesMapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"propertyNamesMapping"];
}

#pragma mark - Public

//- (NSString *)sortID
//{
//    return objc_getAssociatedObject(self, &SortIDKey);
//}
//
//- (void)setSortID:(NSString *)sortID
//{
//    [self willChangeValueForKey:@"sortID"];
//    objc_setAssociatedObject(self, &SortIDKey, sortID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:@"sortID"];
//}

+ (instancetype)managedObjectForDictionary:(NSDictionary *)dictionary updateManagedObjectContext:(NSManagedObjectContext *)context
                                     klass:(Class)managedObjectClass predicate:(NSPredicate *)predicate{
    if ([dictionary objectForKey:@"Description"]) {
        NSMutableDictionary *dictionaryTemp = [dictionary mutableCopy];
        dictionaryTemp[@"desc"] = dictionaryTemp[@"Description"];
        dictionary = dictionaryTemp;
    }
    
    NSArray *resultArray = nil;
    
    if (managedObjectClass && [managedObjectClass isSubclassOfClass:[NSManagedObject class]]) {
        NSError *error = nil;
        
        NSString *entityName = NSStringFromClass(managedObjectClass);
        if (entityName.length > 0 && [NSEntityDescription entityForName:entityName inManagedObjectContext:context]) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
            if (predicate) {
                fetchRequest.predicate = predicate;
            }
            @try {
                resultArray = [context executeFetchRequest:fetchRequest error:&error];
            }
            @catch (NSException *exception) {
                KyoLog(@"%@",exception.reason);
            }
            @finally {
                
            }
            
            if (error != nil) {
                resultArray = [NSArray array];
                KyoLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        } else {
            resultArray = [NSArray array];
            KyoLog(@"Entity %@ does not exist.", entityName);
        }
    }
    NSManagedObject *result = nil;
    if ([resultArray count] > 0) {
        result = resultArray[0];
    } else {
        return nil;
    }
    
    @try {
        NSDictionary *properties = [[result entity] propertiesByName];
        for (NSString *key in properties) {
            @try {
                id property = [properties objectForKey:key];
                NSString *sourceKey = [[result propertyNamesMapping] objectForKey:key];
                if (![sourceKey isKindOfClass:[NSString class]] || sourceKey.length == 0) {
                    sourceKey = key;
                }
                if ([property isKindOfClass:[NSAttributeDescription class]]) {
                    NSAttributeType attributeType = [[properties objectForKey:key] attributeType];
                    
                    id value = [dictionary objectForKey:[NSString stringWithFormat:@"%@%@", [[sourceKey substringToIndex:1] uppercaseString], [sourceKey substringFromIndex:1]]];
                    if ([sourceKey isEqualToString:@"oid"]) {
                        value = [dictionary objectForKey:@"Id"];
                    }
                    
                    if (value == nil) {
                        value = [dictionary objectForKey:sourceKey];
                        if (value == nil) {
                            continue;
                        }
                    }
                    
                    if (![value isKindOfClass:[NSNull class]]) {
                        
                        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
                            value = [value stringValue];
                            //                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
                            //                    value = [value dateValueForServer];
                            //                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSNumber class]])){
                            //#warning TODO
                            //
                            //                    value = [NSDate dateWithTimeIntervalSince1970:[value longValue]/1000];
                        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
                            value = [NSNumber numberWithInteger:[value  integerValue]];
                        } else if ((attributeType == NSFloatAttributeType) && ([value isKindOfClass:[NSString class]])) {
                            value = [NSNumber numberWithDouble:[value doubleValue]];
                            //                } else if ((attributeType == NSTransformableAttributeType) && ([value isKindOfClass:[NSDictionary class]])) {
                            //                    value = [property valueOfClass:[Image class] forJSONDictionary:value];
                        }
                    } else {
                        if (attributeType == NSStringAttributeType) {
                            value = @"";
                            //                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
                            //                    value = [value dateValueForServer];
                            //                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSNumber class]])){
                            //#warning TODO
                            //
                            //                    value = [NSDate dateWithTimeIntervalSince1970:[value longValue]/1000];
                        } else if ((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) {
                            value = @0;
                        } else if (attributeType == NSFloatAttributeType) {
                            value = @0;
                        }
                    }
                    [result setValue:value forKey:key];
                } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                    NSRelationshipDescription *relationshipDescription = property;
                    NSEntityDescription *destinationEntity = [relationshipDescription destinationEntity];
                    NSString *destinationEntityName = [destinationEntity name];
                    id value = [dictionary objectForKey:sourceKey];
                    if ([relationshipDescription isToMany]) {
                        if ([value isKindOfClass:[NSArray class]]) {
                            NSSet *set = [self managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
                            [result setValue:set forKey:key];
                        } else if ([value isKindOfClass:[NSDictionary class]]) {
                            NSSet *set = [self managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:@[value] insertIntoManagedObjectContext:context];
                            [result setValue:set forKey:key];
                        }
                    } else {
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value insertIntoManagedObjectContext:context];
                            [result setValue:managedObject forKey:key];
                        } else if ([value isKindOfClass:[NSArray class]]) {
                            NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value[0] insertIntoManagedObjectContext:context];
                            [result setValue:managedObject forKey:key];
                        }
                    }
                }//end-for
            } @catch (NSException *exception) {
                KyoLog(@"%@", exception.reason);
            } @finally {
                
            }
        }
        
        NSError *error = nil;
        [context save:&error];
        if (error) {
            KyoLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    } @catch (NSException *exception) {
        KyoLog(@"%@", exception.reason);
    } @finally {
        return result;
    }
}

+ (instancetype)managedObjectForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    if ([dictionary objectForKey:@"Description"]) {
        NSMutableDictionary *dictionaryTemp = [dictionary mutableCopy];
        dictionaryTemp[@"desc"] = dictionaryTemp[@"Description"];
        dictionary = dictionaryTemp;
    }
    
    NSManagedObject *result = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    @try {
        NSDictionary *properties = [[result entity] propertiesByName];
        for (NSString *key in properties) {
            
            @try {
                id property = [properties objectForKey:key];
                NSString *sourceKey = [[result propertyNamesMapping] objectForKey:key];
                if (![sourceKey isKindOfClass:[NSString class]] || sourceKey.length == 0) {
                    sourceKey = key;
                }
                if ([property isKindOfClass:[NSAttributeDescription class]]) {
                    NSAttributeType attributeType = [[properties objectForKey:key] attributeType];

                    id value = [dictionary objectForKey:[NSString stringWithFormat:@"%@%@", [[sourceKey substringToIndex:1] uppercaseString], [sourceKey substringFromIndex:1]]];
                    if ([sourceKey isEqualToString:@"oid"]) {
                        value = [dictionary objectForKey:@"Id"];
                    }
                    
                    if (value == nil) {
                        value = [dictionary objectForKey:sourceKey];
                        if (value == nil) {
                            continue;
                        }
                    }

                    if (![value isKindOfClass:[NSNull class]]) {

                        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
                            value = [value stringValue];
                            //                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
                            //                    value = [value dateValueForServer];
                            //                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSNumber class]])){
                            //#warning TODO
                            //
                            //                    value = [NSDate dateWithTimeIntervalSince1970:[value longValue]/1000];
                        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
                            value = [NSNumber numberWithInteger:[value  integerValue]];
                        } else if ((attributeType == NSFloatAttributeType) && ([value isKindOfClass:[NSString class]])) {
                            value = [NSNumber numberWithDouble:[value doubleValue]];
                            //                } else if ((attributeType == NSTransformableAttributeType) && ([value isKindOfClass:[NSDictionary class]])) {
                            //                    value = [property valueOfClass:[Image class] forJSONDictionary:value];
                        }
                    } else {
                        if (attributeType == NSStringAttributeType) {
                            value = @"";
                            //                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
                            //                    value = [value dateValueForServer];
                            //                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSNumber class]])){
                            //#warning TODO
                            //
                            //                    value = [NSDate dateWithTimeIntervalSince1970:[value longValue]/1000];
                        } else if ((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) {
                            value = @0;
                        } else if (attributeType == NSFloatAttributeType) {
                            value = @0;
                        }
                    }
                    [result setValue:value forKey:key];
                } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                    NSRelationshipDescription *relationshipDescription = property;
                    NSEntityDescription *destinationEntity = [relationshipDescription destinationEntity];
                    NSString *destinationEntityName = [destinationEntity name];
                    id value = [dictionary objectForKey:sourceKey];
                    if ([relationshipDescription isToMany]) {
                        if ([value isKindOfClass:[NSArray class]]) {
                            NSSet *set = [self managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
                            [result setValue:set forKey:key];
                        } else if ([value isKindOfClass:[NSDictionary class]]) {
                            NSSet *set = [self managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:@[value] insertIntoManagedObjectContext:context];
                            [result setValue:set forKey:key];
                        }
                    } else {
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value insertIntoManagedObjectContext:context];
                            [result setValue:managedObject forKey:key];
                        } else if ([value isKindOfClass:[NSArray class]]) {
                            NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value[0] insertIntoManagedObjectContext:context];
                            [result setValue:managedObject forKey:key];
                        }
                    }
                }//end-for
            } @catch (NSException *exception) {
                KyoLog(@"%@", exception.reason);
            } @finally {

            }
        }
        
        NSError *error = nil;
        [context save:&error];
        if (error) {
            KyoLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    } @catch (NSException *exception) {
        KyoLog(@"%@", exception.reason);
    } @finally {
        return result;
    }
}

+ (NSSet *)managedObjectsOfClass:(Class)aClass forArray:(NSArray *)array insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableArray *managedObjects = [NSMutableArray array];
    
    @try {
        NSUInteger count = [array count];
        for (NSUInteger counter = 0; counter < count; counter ++) {
            id object = [array objectAtIndex:counter];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSManagedObject *managedObject = [aClass managedObjectForDictionary:object insertIntoManagedObjectContext:context];
                if (managedObject) {
                    [managedObjects addObject:managedObject];
                }
            }
        }
    }
    @catch (NSException *exception) {
        KyoLog(@"%@", exception.reason);
    }
    @finally {
        return [NSSet setWithArray:managedObjects];
    }
}

- (void)makePropertyNamesMappingForKey:(NSString *)key sourceKey:(NSString *)sourceKey
{
    if (self.propertyNamesMapping == nil) {
        self.propertyNamesMapping = [NSMutableDictionary dictionary];
    }
    
    [self.propertyNamesMapping setValue:sourceKey forKey:key];
}

+ (void)logAllInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *existed = [context executeFetchEntityForManagedObjectClass:self];
    NSUInteger counter = 0;
    KyoLog(@"Found %@ items of %@ in total:", @(existed.count), NSStringFromClass([self class]));
    for (NSManagedObject __unused *object in existed) {
        KyoLog(@"%@:\t%@", @(counter), object);
        counter ++ ;
    }
}

- (void)logAll
{
    [[self class] logAllInManagedObjectContext:self.managedObjectContext];
}

- (NSDictionary *)dictionaryValue
{
    NSArray *allKeys = [[[self entity] propertiesByName] allKeys];
    return [self dictionaryWithValuesForKeys:allKeys];
    
    //    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    //
    //    for (id property in [[self entity] properties]) {
    //        if ([property isKindOfClass:[NSAttributeDescription class]]) {
    //            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)property;
    //            NSString *name = [attributeDescription name];
    //            [properties setValue:[self valueForKey:name] forKey:name];
    //        } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
    //            NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *)property;
    //            NSString *name = [relationshipDescription name];
    //            KyoLog(@"%@", name);
    //            if ([relationshipDescription isToMany]) {
    //                NSMutableArray *values = [properties valueForKey:name];
    //                if (values == nil) {
    //                    values = [NSMutableArray array];
    //                }
    //                NSMutableSet *set = [self mutableSetValueForKey:name];
    //                for (NSManagedObject *managedObject in set) {
    //                    [values addObject:[managedObject dictionaryValueWithoutRelationshipNamed:name]];
    //                }
    //                [properties setValue:values forKey:name];
    //            } else {
    //                NSManagedObject *managedObject = [self valueForKey:name];
    //                if (managedObject) {
    //                    [properties setValue:[managedObject dictionaryValueWithoutRelationshipNamed:name] forKey:name];
    //                }
    //            }
    //        }
    //    }
    //
    //    return properties;
}

//- (NSDictionary *)dictionaryValueWithoutRelationshipNamed:(NSString *)relationshipName
//{
//    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
//
//    for (id property in [[self entity] properties]) {
//        if ([property isKindOfClass:[NSAttributeDescription class]]) {
//            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)property;
//            NSString *name = [attributeDescription name];
//            [properties setValue:[self valueForKey:name] forKey:name];
//        } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
//            NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *)property;
//            NSString *name = [relationshipDescription name];
//            KyoLog(@"%@", name);
//            if ([name isEqualToString:relationshipName]) {
//                continue;
//            }
//            if ([relationshipDescription isToMany]) {
//                NSMutableArray *values = [properties valueForKey:name];
//                if (values == nil) {
//                    values = [NSMutableArray array];
//                }
//                NSMutableSet *set = [self mutableSetValueForKey:name];
//                for (NSManagedObject *managedObject in set) {
//                    [values addObject:[managedObject dictionaryValue]];
//                }
//                [properties setValue:values forKey:name];
//            } else {
//                NSManagedObject *managedObject = [self valueForKey:name];
//                if (managedObject) {
//                    [properties setValue:[managedObject dictionaryValue] forKey:name];
//                }
//            }
//        }
//    }
//
//    return properties;
//}

//            if ([value isKindOfClass:[NSDictionary class]]) {
//                NSManagedObject *managedObject = [self managedObjectOfClass:NSClassFromString(destinationEntityName) forDictionary:value insertIntoManagedObjectContext:context];
//                [result setValue:managedObject forKey:key];
//            } else if ([value isKindOfClass:[NSArray class]]) {
////                NSString *firstChar = [key substringToIndex:1];
////                NSString *selectorName = [[[@"add" stringByAppendingString:[firstChar uppercaseString]] stringByAppendingString:[key substringFromIndex:1]] stringByAppendingString:@":"];
////                SEL selector = NSSelectorFromString(selectorName);
//                NSSet *set = [self managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
////                if ([result respondsToSelector:selector]) {
////                    id noUse = [result performSelector:selector withObject:set];
////                    KyoLog(@"%@", noUse);
////                }
//            }

@end
