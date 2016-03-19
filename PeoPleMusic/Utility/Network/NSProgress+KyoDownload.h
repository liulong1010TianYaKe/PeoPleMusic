//
//  NSProgress+KyoDownload.h
//  test-57-AFNetwork2.0
//
//  Created by Kyo on 23/11/15.
//  Copyright © 2015 Kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSProgress (KyoDownload)

@property (strong, nonatomic) NSString *kyo_url;
@property (copy, nonatomic) void (^ kyo_progressBlock)(long long countByte, long long currentByte);

@end
