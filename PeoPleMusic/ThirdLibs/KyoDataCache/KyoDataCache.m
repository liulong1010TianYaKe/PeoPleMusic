//
//  KyoDataCache.m
//  JuMi
//
//  Created by Kyo on 2/2/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "KyoDataCache.h"
#import "NSData+DES.h"

#define kKyoSerialize @"kyoSerialize"
#define KDESPW  @"kyoDataCache"

@implementation KyoDataCache

#pragma mark ----------------------
#pragma mark - Static And CycLife

+ (KyoDataCache *)shared
{
    static KyoDataCache *share = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    
    return share;
}

#pragma mark ----------------------
#pragma mark - Methods

//得到temp路径
- (NSString *)getTempPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *tempPath = [cachesDirectory stringByAppendingPathComponent:@"KyoDataCache"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tempPath])    //如果不存在文件夹则创建
    {
        [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tempPath;
}

//根据userId和对应类别的文件夹名称得到预约的路径
- (NSString *)getTempWithFolderName:(NSString *)folderName withUserID:(NSString *)userId
{
    return [self getTempWithFolderName:folderName withUserID:userId withSuffix:@"Kyo"];
}

//根据userId和对应类别的文件夹名称和后缀得到预约的路径(自动创建)
- (NSString *)getTempWithFolderName:(NSString *)folderName withUserID:(NSString *)userId withSuffix:(NSString *)suffix {
    if (!folderName || [folderName isEqualToString:@""]) {  //如果目录没传，则默认为default文件夹
        folderName = @"default";
    }
    if (!userId) {  //如果userid没传，默认为空字符串
        userId = @"";
    }
    
    NSString *path = folderName ? [[self getTempPath] stringByAppendingPathComponent:folderName] : [self getTempPath];
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
- (NSString *)getTempDonNotCreateWithFolderName:(NSString *)folderName withUserID:(NSString *)userId {
    return [self getTempDonNotCreateWithFolderName:folderName withUserID:userId withSuffix:@"Kyo"];
}

//根据userId和对应类别的文件夹名称和后缀得到预约的路径(不自动创建)
- (NSString *)getTempDonNotCreateWithFolderName:(NSString *)folderName withUserID:(NSString *)userId  withSuffix:(NSString *)suffix {
    if (!folderName || [folderName isEqualToString:@""]) {  //如果目录没传，则默认为default文件夹
        folderName = @"default";
    }
    if (!userId) {  //如果userid没传，默认为空字符串
        userId = @"";
    }
    NSString *path = folderName ? [[self getTempPath] stringByAppendingPathComponent:folderName] : [self getTempPath];
    NSString  *pathJsonData = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.%@",folderName,userId,suffix]];
    return pathJsonData;
}

//根据文件夹名称和userid得到文件数据
- (id)readTempDataWithFolderName:(NSString *)folderName withUserID:(NSString *)userId
{
    //反序列化后读取文件
    NSString *path = [self getTempWithFolderName:folderName withUserID:userId];
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
- (id)readTempDataWithFolderName:(NSString *)folderName
{
    return [self readTempDataWithFolderName:folderName withUserID:nil];
}

//根据根据文件夹名称和userid和数据写入文件中
- (BOOL)writeToTempDataWithFolderName:(NSString *)folderName withUserId:(NSString *)userId withData:(id)data
{
    if (!data) {
        return NO;
    }
    
    //序列化后写入文件
    NSString *path = [self getTempWithFolderName:folderName withUserID:userId];
    NSMutableData *dataArchiver = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArchiver];
    [archiver encodeObject:data forKey:kKyoSerialize];
    [archiver finishEncoding];
    dataArchiver = [[dataArchiver encryptUseDES:KDESPW] mutableCopy]; //加密
    BOOL result = [dataArchiver writeToFile:path atomically:YES];

    return result;
}

//根据根据文件夹名称和数据写入文件中
- (BOOL)writeToTempDataWithFolderName:(NSString *)folderName withData:(id)data
{
    return [self writeToTempDataWithFolderName:folderName withUserId:nil withData:data];
}

//根据根据文件夹名称和userid删除缓存文件
- (BOOL)deleteToTempDataWithFolderName:(NSString *)folderName withUserId:(NSString *)userId {
    
    //删除文件
    NSString *path = [self getTempWithFolderName:folderName withUserID:userId];
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL result = [mgr removeItemAtPath:path error:nil];
    
    return result;
}

//根据根据文件夹名称和数据删除缓存文件
- (BOOL)deleteToTempDataWithFolderName:(NSString *)folderName {
    return [self deleteToTempDataWithFolderName:folderName withUserId:nil];
}

//删除所有缓存的文件夹和文件
- (BOOL)deleteAllTempData {
    NSFileManager *mgr = [NSFileManager defaultManager];
    return [mgr removeItemAtPath:[self getTempPath] error:nil];
}

//删除包含文件夹关键字的缓存文件夹
- (BOOL)deleteAllTempDataWithContainFolderName:(NSString *)folderName {
    if (!folderName || [folderName isEqualToString:@""]) {
        return [self deleteAllTempData];
    } else {
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSArray *arrayFolderName = [mgr contentsOfDirectoryAtPath:[self getTempPath] error:nil];
        for (NSString *tempFolderName in arrayFolderName) {
            if ([tempFolderName rangeOfString:folderName].location != NSNotFound) {
                BOOL result = [mgr removeItemAtPath:[[self getTempPath] stringByAppendingPathComponent:tempFolderName] error:nil];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    }
}

@end
