//
//  NSData+DES.m
//  JuMi
//
//  Created by Kyo on 2/2/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "NSData+DES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (DES)

//加密
- (NSData *)encryptUseDES:(NSString *)key
{
    NSData *data = self;
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //确定加密过后的字符串在内存中存放的大小，根据文档，对于块密码方式（这个库还包括流密码方式）
    //加密过后的字符串大小总是小于或等于加密之前数据的大小加上对应加密算法的块大小
    //但看到一些大牛还这样一下 & ~(kCCBlockSizeDES - 1) 目前不知道为嘛
    size_t bufferSize = ([data length] + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    uint8_t *bufferPtr = NULL;
    bufferPtr = malloc( bufferSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferSize);
    size_t numBytesEncrypted = 0;    //输出加密串的字节数
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,    //加密方式，kCCEncrypt加密  kCCDecrypt解密
                                          kCCAlgorithmDES, //采用的加密算法，内置包含AES、DES、
                                          //3DES、其他还有四个，不知道是什么
                                          //后续讨论
                                          //加密额外参数，注意此处各个平台之间指定的时候要记得一样
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], //加密密匙 UTF8的字符串
                                          kCCKeySizeDES,  //密匙长度字节 各算法有对应的长度宏
                                          nil,     //随机字符，可指定也可不指定，各平台之间不绝对
                                          [data bytes], //待加密串的字节长度
                                          [data length], //待加密串的长度
                                          (void *)bufferPtr,        //输出已加密串的内存地址
                                          bufferSize,    //已加密串的大小
                                          &numBytesEncrypted);
    
    NSData* plainData = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *dataTemp = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)numBytesEncrypted];
        plainData = dataTemp;
    }else{
        NSLog(@"DES加密失败");
    }
    if (bufferPtr != NULL) {
        free((void *)bufferPtr);
    }
    return plainData;
}
//解密
- (NSData *)decryptUseDES:(NSString*)key
{
    NSData* cipherData = self;
    size_t bufferSize = ([cipherData length] + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    uint8_t *bufferPtr = NULL;
    bufferPtr = malloc( bufferSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferSize);
    size_t numBytesDecrypted = 0;
    
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [cipherData bytes],
                                          [cipherData length],
                                          (void *)bufferPtr,
                                          bufferSize,//1024,
                                          &numBytesDecrypted);
    NSData* plainData = nil;
    if (cryptStatus == kCCSuccess) {
        NSData * data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)numBytesDecrypted];
        plainData = data;
    }
    if (bufferPtr != NULL) {
        free((void *)bufferPtr);
    }
    return plainData;
}

@end
