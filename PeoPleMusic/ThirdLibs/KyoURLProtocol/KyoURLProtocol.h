//
//  KyoURLProtocol.h
//  test-57-AFNetwork2.0
//
//  Created by Kyo on 14-12-28.
//  Copyright (c) 2014年 Kyo. All rights reserved.
//

/*
 nsurlprotocol作用
 如何统一地添加全局的HTTP头(不仅仅是UA而已)
 如何优雅地进行流量统计
 对特定的地址进行CDN加速(URL到IP的替换)
 */

#define kNotificationName_NetworkDownTypePackage  @"NetowrkDownTypePackage"

#import <Foundation/Foundation.h>

@interface KyoURLProtocol : NSURLProtocol

@end
