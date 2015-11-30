//
//  NSData+DES.h
//  JuMi
//
//  Created by Kyo on 2/2/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DES)

//加密
- (NSData *)encryptUseDES:(NSString *)key;
//解密
- (NSData *)decryptUseDES:(NSString*)key;

@end
