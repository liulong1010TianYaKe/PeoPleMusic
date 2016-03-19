//
//  NSProgress+KyoDownload.m
//  test-57-AFNetwork2.0
//
//  Created by Kyo on 23/11/15.
//  Copyright © 2015 Kyo. All rights reserved.
//

#import "NSProgress+KyoDownload.h"
#import <objc/runtime.h>

@implementation NSProgress (KyoDownload)

- (NSString *)kyo_url {
    NSString *url = objc_getAssociatedObject(self, _cmd);
    return url;
}

- (void)setKyo_url:(NSString *)kyo_url {
    SEL key = @selector(kyo_url);
    objc_setAssociatedObject(self, key, kyo_url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(long long countByte, long long currentByte))kyo_progressBlock {
    void (^block)(long long countByte, long long currentByte) = objc_getAssociatedObject(self, _cmd);
    return block;
}

- (void)setKyo_progressBlock:(void (^)(long long, long long))kyo_progressBlock {
    SEL key = @selector(kyo_progressBlock);
    objc_setAssociatedObject(self, key, kyo_progressBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
