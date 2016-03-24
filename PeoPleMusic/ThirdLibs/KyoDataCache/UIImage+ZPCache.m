//
//  UIImage+ZPCache.m
//  Demo
//
//  Created by Leo_zzp on 16/1/29.
//  Copyright © 2016年 hzins. All rights reserved.
//

#import "UIImage+ZPCache.h"
#import "KyoDataCache.h"

@implementation UIImage (ZPCache)

+ (UIImage *)zp_imageCacheNamed:(NSString *)name
{
    if (name.length <= 0) return nil;
    NSCache *cache = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] valueForKey:@"kyoCache"];
    if ([cache objectForKey:name])
    { 
        return [cache objectForKey:name];
    }
    else
    {
        if ([self imageNamed:name])
        {
            [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] imageNamed:name];
            return [self imageNamed:name];
        }
    }
    return nil;
}

@end
