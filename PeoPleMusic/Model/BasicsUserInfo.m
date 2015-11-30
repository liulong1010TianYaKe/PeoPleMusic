//
//  UserInfo.m
//  KidsBook
//
//  Created by Lukes Lu on 10/21/13.
//  Copyright (c) 2013 KidsBook Office. All rights reserved.
//

#import "BasicsUserInfo.h"
#import "MJConst.h"
#import "NSData+DES.h"

#define kUserInfoSerialize  @"UserInfoSerialize"
#define kUserInfoDESPW  @"userInfoDesPW"

@interface BasicsUserInfo()

@property (assign, nonatomic) BOOL kyoBasicsUserInfoRecord; /**< 是否监听并自动写入用户信息 */

- (void)setDefaultKeyValues;    //设置默认值
- (void)addObserverWithAllProterty; //监听所有属性值变化
- (void)removeObserverWithAllProterty; //移除所有属性值变化

@end

@implementation BasicsUserInfo

- (id)init {
    self = [super init];
    if (self) {
        self.kyoBasicsUserInfoRecord = YES;
        [self setDefaultKeyValues]; //设置存储的默认值
        [self addObserverWithAllProterty];  //监听所有属性值变化
    }
    
    return self;
}

/**< 初始化，不监听值 */
- (id)initWithOutRecord {
    self = [super init];
    if (self) {
        self.kyoBasicsUserInfoRecord = NO;
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserverWithAllProterty];   //移除所有属性值变化
}

#pragma mark -----------------------
#pragma mark - Methods

//设置默认值
- (void)setDefaultKeyValues {
    if (!self.kyoBasicsUserInfoRecord) {
        return;
    }
    
    NSDictionary *dictAllProperty = [KyoUtil getPropertyNameList:[self class]];
    if (!dictAllProperty && dictAllProperty.allKeys.count <= 0) {
        return;
    }
    
    NSMutableDictionary *dictKeyValues = [NSMutableDictionary dictionary];
    for (NSString *proterty in dictAllProperty.allKeys) {
        id value = [KyoUtil getUserDefaultValue:proterty];
        if (value) {
            //反序列化读取数据
            NSData *dataUnarchiver = value;
            if (dataUnarchiver && [dataUnarchiver isKindOfClass:[NSData class]] && dataUnarchiver.length > 0) {
                dataUnarchiver = [dataUnarchiver decryptUseDES:kUserInfoDESPW]; //解密
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataUnarchiver];
                value = [unarchiver decodeObjectForKey:kUserInfoSerialize];
                [unarchiver finishDecoding];
                
                [dictKeyValues setObject:value forKey:proterty];
            }
        }
    }
    
    [self setKeyValues:dictKeyValues];
}

//监听所有属性值变化
- (void)addObserverWithAllProterty {
    if (!self.kyoBasicsUserInfoRecord) {
        return;
    }
    
    NSDictionary *dictAllProperty = [KyoUtil getPropertyNameList:[self class]];
    if (!dictAllProperty && dictAllProperty.allKeys.count <= 0) {
        return;
    }
    
    for (NSString *proterty in dictAllProperty.allKeys) {
        [self addObserver:self forKeyPath:proterty options:NSKeyValueObservingOptionNew context:NULL];
    }
}

//移除所有属性值变化
- (void)removeObserverWithAllProterty {
    if (!self.kyoBasicsUserInfoRecord) {
        return;
    }
    
    NSDictionary *dictAllProperty = [KyoUtil getPropertyNameList:[self class]];
    if (!dictAllProperty && dictAllProperty.allKeys.count <= 0) {
        return;
    }
    
    for (NSString *proterty in dictAllProperty.allKeys) {
        [self removeObserver:self forKeyPath:proterty];
    }
}

- (void)setKeyValues:(NSDictionary *)keyValues {
    NSString *desc = [NSString stringWithFormat:@"keyValues is not a NSDictionary - keyValues参数不是一个字典, keyValues is a %@ - keyValues参数是一个%@", keyValues.class, keyValues.class];
    MJAssert2([keyValues isKindOfClass:[NSDictionary class]], desc, );
    
    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
        // 来自Foundation框架的成员变量，直接返回
        if (ivar.isSrcClassFromFoundation) return;
        
        // 1.取出属性值
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        key = [KyoUtil getModelKey:key withUppercase:YES];   //尝试把首字母转化为大写
        id value = keyValues[key];
        if (!value) {   //如果没有这个属性值，尝试把首字母转化为小写
            key = [KyoUtil getModelKey:key withUppercase:NO];
            value = keyValues[key];
            if (!value) return; //如果转化为小写还是没有找到，则跳出
        }
        
        // 2.如果是模型属性
        if (ivar.type.typeClass && !ivar.type.isFromFoundation) {
            value = [ivar.type.typeClass objectWithKeyValues:value];
        } else if (ivar.type.typeClass == [NSString class] && [value isKindOfClass:[NSNumber class]]) {
            // NSNumber -> NSString
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            value = [fmt stringFromNumber:value];
        } else if (ivar.type.typeClass == [NSNumber class] && [value isKindOfClass:[NSString class]]) {
            // NSString -> NSNumber
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            value = [fmt numberFromString:value];
        } else if (ivar.type.typeClass == [NSURL class] && [value isKindOfClass:[NSString class]]) {
            // NSString -> NSURL
            value = [NSURL URLWithString:value];
        } else if (ivar.type.typeClass == [NSString class] && [value isKindOfClass:[NSURL class]]) {
            // NSURL -> NSString
            value = [value absoluteString];
        } else if (ivar.type.typeClass == [NSString class] && [value isKindOfClass:[NSNull class]]) {
            // NSNull -> NSString
            value = nil;
        } else if ([self respondsToSelector:@selector(objectClassInArray)]) {
            // 3.字典数组-->模型数组
            Class objectClass = self.objectClassInArray[ivar.propertyName];
            if (objectClass) {
                value = [objectClass objectArrayWithKeyValuesArray:value];
            }
        }
        
        // 4.赋值
        ivar.value = value;
    }];
    
    // 转换完毕
    if ([self respondsToSelector:@selector(keyValuesDidFinishConvertingToObject)]) {
        [self keyValuesDidFinishConvertingToObject];
    }
}

#pragma mark -----------------------
#pragma mark - KVC/KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //如果是不需要写入缓存的值，跳出
    if (self.arrayNoWrite &&
        [self.arrayNoWrite containsObject:keyPath]) {
        return;
    }
    
    id value = nil;
    if (change[@"new"] != [NSNull null]) {
        //序列化后写入UserDefault
        value = change[@"new"];
        NSMutableData *dataArchiver = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArchiver];
        [archiver encodeObject:value forKey:kUserInfoSerialize];
        [archiver finishEncoding];
        dataArchiver = [[dataArchiver encryptUseDES:kUserInfoDESPW] mutableCopy]; //加密
        value = dataArchiver;
    }
    
    [KyoUtil addUserDefault:keyPath value:value];
}

@end
