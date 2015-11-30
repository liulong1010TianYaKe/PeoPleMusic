//
//  KyoDataCache.h
//  JuMi
//
//  Created by Kyo on 2/2/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>

#define   UserId [@([UserInfo sharedUserInfo].Id) stringValue]
#define KyoDataCacheTodayFolder(folder) [NSString stringWithFormat:@"%@%@",folder,[[NSDate date] strDate]]  //传入文件夹名，拼装今天的日期字符串到后面
#define KyoDataCacheTagFolder(folder, tag) [NSString stringWithFormat:@"%@%@",folder, tag]  //传入文件夹名和标示，拼装缓存文件夹名字

#define KyoDataCacheTagFolderWithUserId(folder, tag) [NSString stringWithFormat:@"%@%@%@",folder,UserId, tag]  //传入文件夹名和标示，拼装缓存文件夹名字


@interface KyoDataCache : NSObject

+ (KyoDataCache *)shared;

//*****path
- (NSString *)getTempPath;  //得到temp路径
- (NSString *)getTempWithFolderName:(NSString *)folderName withUserID:(NSString *)userId;    //根据userId和对应类别的文件夹名称得到预约的路径(自动创建)
- (NSString *)getTempWithFolderName:(NSString *)folderName withUserID:(NSString *)userId withSuffix:(NSString *)suffix;    //根据userId和对应类别的文件夹名称和后缀得到预约的路径(自动创建)
- (NSString *)getTempDonNotCreateWithFolderName:(NSString *)folderName withUserID:(NSString *)userId;    //根据userId和对应类别的文件夹名称得到预约的路径(不自动创建)
- (NSString *)getTempDonNotCreateWithFolderName:(NSString *)folderName withUserID:(NSString *)userId  withSuffix:(NSString *)suffix;    //根据userId和对应类别的文件夹名称和后缀得到预约的路径(不自动创建)

//*****get
- (id)readTempDataWithFolderName:(NSString *)folderName withUserID:(NSString *)userId; //根据文件夹名称和userid得到文件数据
- (id)readTempDataWithFolderName:(NSString *)folderName; //根据文件夹名称得到文件数据

//*****set
- (BOOL)writeToTempDataWithFolderName:(NSString *)folderName withUserId:(NSString *)userId withData:(id)data;  //根据根据文件夹名称和userid和数据写入文件中
- (BOOL)writeToTempDataWithFolderName:(NSString *)folderName withData:(id)data;  //根据根据文件夹名称和数据写入文件中

//*****delete
- (BOOL)deleteToTempDataWithFolderName:(NSString *)folderName withUserId:(NSString *)userId; //根据根据文件夹名称和userid删除缓存文件
- (BOOL)deleteToTempDataWithFolderName:(NSString *)folderName;   //根据根据文件夹名称和数据删除缓存文件
- (BOOL)deleteAllTempData;  //删除所有缓存的文件夹和文件
- (BOOL)deleteAllTempDataWithContainFolderName:(NSString *)folderName;  //删除包含文件夹关键字的缓存文件夹

@end
