/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)

+ (NSString *) platform;    //平台，通过此检测设备的型号，比如iphone3gs,itouch3等等
+ (NSUInteger) cpuFrequency;
+ (NSUInteger) busFrequency;
+ (NSUInteger) totalMemory;
+ (NSUInteger) userMemory;
+ (NSString *) getUUID;
@end