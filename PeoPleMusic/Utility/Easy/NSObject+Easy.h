//
//  NSObject+Easy.h
//  3wyc
//
//  Created by Yang Gaofeng on 14/11/10.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

static CGFloat const kSafeHandlerDefaultDuration = 3.f;

//static NSUInteger const kFractionDigitsDefault = 2;
//NSString * valueWithFixedFractionDigits(CGFloat value, NSUInteger fractionDigits);
//NSString * valueWithFractionDigitsOnTheServer(CGFloat value);
BOOL systemVersionGreaterThan(CGFloat value);
BOOL systemVersionGreaterThanOrEqualTo(CGFloat value);

inline NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate);
inline NSString *NSStringFromMKCoordinateSpan(MKCoordinateSpan span);
inline NSString *NSStringFromMKCoordinateRegion(MKCoordinateRegion region);
inline NSString *NSStringFromCGSize(CGSize size);

@interface NSObject (Easy)

/*
 Value
 */
//+ (NSInteger)integerValueFromValue:(id)value;
//+ (BOOL)boolValueFromValue:(id)value;
//+ (NSString *)stringValueFromValue:(id)value;
//+ (NSDictionary *)dictionaryValueFromValue:(id)value;
//
//- (NSInteger)integerValueFromValue:(id)value;
//- (BOOL)boolValueFromValue:(id)value;
//- (NSString *)stringValueFromValue:(id)value;
//- (NSDictionary *)dictionaryValueFromValue:(id)value;

- (NSInteger)theIntegerValue;   //Return - 1 if cann't respond
- (BOOL)theBoolValue;   //Return NO if cann't respond
- (NSString *)theStringValue;   //Return [NSString string] if cann't respond
- (NSDictionary *)theDictionaryValue;   //Return [NSDictionary dictionary] if cann't respond
- (NSArray *)theArrayValue;   //Return [NSArray array] if cann't respond

/*
 Directory
 */
- (NSString *)cachePath;
- (NSString *)documentsPath;
- (NSURL *)cacheURL;
- (NSURL *)documentsURL;

/*
 info
 */

+ (NSString *)bundleVersion;
+ (NSString *)bundleName;
+ (NSString *)bundleDisplayName;
+ (NSString *)bundleIdentifier;
+ (NSString *)countryCode;
+ (NSString *)launchImageName;

- (NSString *)bundleVersion;
- (NSString *)bundleName;
- (NSString *)bundleDisplayName;
- (NSString *)bundleIdentifier;
- (NSString *)countryCode;
- (NSString *)launchImageName;

+ (UINavigationController *)currentNavigationController;
- (UINavigationController *)currentNavigationController;

- (void)performWithSafeHandler:(void (^)(void))handler;
- (void)performWithSafeHandler:(void (^)(void))handler duration:(NSTimeInterval)duration;
//+ (void)dispatch_async_in_main_queue:(dispatch_block_t)block;
//+ (void)dispatch_sync_in_main_queue:(dispatch_block_t)block;
//- (void)dispatch_async_in_main_queue:(dispatch_block_t)block;
//- (void)dispatch_sync_in_main_queue:(dispatch_block_t)block;

@end