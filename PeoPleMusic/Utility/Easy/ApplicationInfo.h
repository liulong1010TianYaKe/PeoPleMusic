//
//  ApplicationInfo.h
//  JuMi
//
//  Created by Yang Gaofeng on 15/1/13.
//  Copyright (c) 2015年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface ApplicationInfo : NSObject

+ (instancetype)sharedInfo;

/*
 Holds in memory
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (nonatomic) BOOL versionCheckShowed;
@property (nonatomic) BOOL networkIsNotWifiShowed;     //当前非WiFi网络是不是提示过
@property (nonatomic) BOOL networkLostShowed;   //当前没有网络是不是提示过

@end
