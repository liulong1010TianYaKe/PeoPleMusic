//
//  KyoDataCache.m
//  JuMi
//
//  Created by Kyo on 2/2/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "KyoDataCache.h"
#import "NSData+DES.h"

#define kKyoSerialize @"kyoSerialize"   //序列化标识
#define KDESPW  @"kyoDataCache" //des加解密密码
#define kTempFilePath   @"KyoDataCacheTemp" //文件缓存文件夹（temp，可删除的）
#define kFilePath   @"KyoDataCache" //文件缓存文件夹（重要的，一般情况不删的）

@interface KyoDataCache()

@property (assign, nonatomic) KyoDataCacheType type;
@property (strong, nonatomic) NSCache *kyoCache;

@end

@implementation KyoDataCache

#pragma mark ----------------------
#pragma mark - Static And CycLife

+ (nonnull KyoDataCache *)sharedWithType:(KyoDataCacheType)type;
{
    static KyoDataCache *share = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
        share.kyoCache = [[NSCache alloc] init];
        share.kyoCache.totalCostLimit = 1 * 1024 * 1024;
        share.kyoCache.countLimit = 10;
    });
    share.type = type;
    
    return share;
}

#pragma mark --------------------
#pragma mark - Gettings, Settings

- (void)setTotalCostLimit:(NSUInteger)totalCostLimit {
    self.kyoCache.totalCostLimit = totalCostLimit;
}

- (NSUInteger)totalCostLimit {
    return self.kyoCache.totalCostLimit;
}

- (void)setCountLimit:(NSUInteger)countLimit {
    self.kyoCache.countLimit = countLimit;
}

- (NSUInteger)countLimit {
    return self.kyoCache.countLimit;
}

#pragma mark ----------------------
#pragma mark - Methods

//得到路径
- (nonnull NSString *)getPath {
    NSString *directory = nil;
    if (self.type == KyoDataCacheTypeTempPath) {
        directory = kTempFilePath;
    } else if (self.type == KyoDataCacheTypePath) {
        directory = kFilePath;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *Path = [cachesDirectory stringByAppendingPathComponent:directory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:Path])    //如果不存在文件夹则创建
    {
        [fileManager createDirectoryAtPath:Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return Path;
}

//根据userId和对应类别的文件夹名称得到预约的路径
- (nonnull NSString *)getWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId
{
    return [self getWithFolderName:folderName withUserID:userId withSuffix:@"Kyo"];
}

//根据userId和对应类别的文件夹名称和后缀得到预约的路径(自动创建)
- (nonnull NSString *)getWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId withSuffix:(nonnull NSString *)suffix {
    if (!folderName || [folderName isEqualToString:@""]) {  //如果目录没传，则默认为default文件夹
        folderName = @"default";
    }
    if (!userId) {  //如果userid没传，默认为空字符串
        userId = @"";
    }
    
    NSString *path = folderName ? [[self getPath] stringByAppendingPathComponent:folderName] : [self getPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])    //如果不存在文件夹则创建
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString  *pathJsonData = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.%@",folderName,userId,suffix]];
    if (![fileManager fileExistsAtPath:pathJsonData])    ////如果不存在则创建
    {
        [fileManager createFileAtPath:pathJsonData contents:nil attributes:nil];
    }
    return pathJsonData;
}

//根据userId和对应类别的文件夹名称得到预约的路径(不自动创建)
- (nonnull NSString *)getDonNotCreateWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId {
    return [self getDonNotCreateWithFolderName:folderName withUserID:userId withSuffix:@"Kyo"];
}

//根据userId和对应类别的文件夹名称和后缀得到预约的路径(不自动创建)
- (NSString *)getDonNotCreateWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId  withSuffix:(nonnull NSString *)suffix {
    if (!folderName || [folderName isEqualToString:@""]) {  //如果目录没传，则默认为default文件夹
        folderName = @"default";
    }
    if (!userId) {  //如果userid没传，默认为空字符串
        userId = @"";
    }
    NSString *path = folderName ? [[self getPath] stringByAppendingPathComponent:folderName] : [self getPath];
    NSString  *pathJsonData = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.%@",folderName,userId,suffix]];
    return pathJsonData;
}

//根据文件夹名称和userid得到文件数据
- (nullable id)readDataWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId {
    //反序列化后读取文件
    NSString *path = [self getWithFolderName:folderName withUserID:userId];
    NSData *dataUnarchiver = [NSData dataWithContentsOfFile:path];
    if (dataUnarchiver && [dataUnarchiver isKindOfClass:[NSData class]] && dataUnarchiver.length > 0) {
        dataUnarchiver = [dataUnarchiver decryptUseDES:KDESPW]; //解密
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataUnarchiver];
        id data = [unarchiver decodeObjectForKey:kKyoSerialize];
        [unarchiver finishDecoding];
        
        return data;
    } else {
        return nil;
    }
}

//根据文件夹名称得到文件数据
- (nullable id)readDataWithFolderName:(nullable NSString *)folderName {
    return [self readDataWithFolderName:folderName withUserID:nil];
}

//根据根据文件夹名称和userid和数据写入文件中
- (BOOL)writeToDataWithFolderName:(nullable NSString *)folderName withUserId:(nullable NSString *)userId withData:(nonnull id)data {
    if (!data) {
        return NO;
    }
    
    //序列化后写入文件
    NSString *path = [self getWithFolderName:folderName withUserID:userId];
    NSMutableData *dataArchiver = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArchiver];
    [archiver encodeObject:data forKey:kKyoSerialize];
    [archiver finishEncoding];
    dataArchiver = [[dataArchiver encryptUseDES:KDESPW] mutableCopy]; //加密
    BOOL result = [dataArchiver writeToFile:path atomically:YES];

    return result;
}

//根据根据文件夹名称和数据写入文件中
- (BOOL)writeToDataWithFolderName:(nullable NSString *)folderName withData:(nonnull id)data {
    return [self writeToDataWithFolderName:folderName withUserId:nil withData:data];
}

/**< 根据根据文件名称和userid删除缓存文件 */
- (BOOL)deleteToDataWithFileName:(nullable NSString *)fileName withUserId:(nullable NSString *)userId {
    //删除文件
    NSString *path = [self getWithFolderName:fileName withUserID:userId];
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL result = [mgr removeItemAtPath:path error:nil];
    
    return result;
}

/**< 根据文件名称删除缓存文件 */
- (BOOL)deleteToDataWithFileName:(nullable NSString *)fileName {
    return [self deleteToDataWithFileName:fileName withUserId:nil];
}

//删除所有缓存的文件夹和文件
- (BOOL)deleteAllData {
    NSFileManager *mgr = [NSFileManager defaultManager];
    return [mgr removeItemAtPath:[self getPath] error:nil];
}

//删除包含文件夹关键字的缓存文件夹
- (BOOL)deleteAllDataWithContainFolderName:(nullable NSString *)folderName {
    if (!folderName || [folderName isEqualToString:@""]) {
        return [self deleteAllData];
    } else {
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSArray *arrayFolderName = [mgr contentsOfDirectoryAtPath:[self getPath] error:nil];
        for (NSString *folderName in arrayFolderName) {
            if ([folderName rangeOfString:folderName].location != NSNotFound) {
                BOOL result = [mgr removeItemAtPath:[[self getPath] stringByAppendingPathComponent:folderName] error:nil];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    }
}

//图片缓存
- (nullable UIImage *)imageNamed:(nonnull NSString *)name {
    if (!name) return nil;
    
    if ([self.kyoCache objectForKey:name]) {
        return [self.kyoCache objectForKey:name];
    } else {
        UIImage *img = [UIImage imageNamed:name];
        if (img) {
            [self.kyoCache setObject:img forKey:name cost:UIImagePNGRepresentation(img).length];
        }
        
        return img;
    }
}

/**< 获得当前版本号 */
- (nonnull NSString *)currentVersion {
    return @"v2.0.0";
}

@end
