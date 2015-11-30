//
//  ApplicationInfo.m
//  JuMi
//
//  Created by Yang Gaofeng on 15/1/13.
//  Copyright (c) 2015年 hzins. All rights reserved.
//

#import "ApplicationInfo.h"

@implementation ApplicationInfo

+ (instancetype)sharedInfo{
    static ApplicationInfo *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end