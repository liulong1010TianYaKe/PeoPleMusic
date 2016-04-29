//
//  KyoDataCache.h
//  JuMi
//
//  Created by Kyo on 2/2/15.
//  Copyright (c) 2015 zhunit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KyoDataCacheTodayFolder(folder) [NSString stringWithFormat:@"%@%@",folder,[[NSDate date] strDate]]  //传入文件夹名，拼装今天的日期字符串到后面
#define KyoDataCacheTagFolder(folder, tag) [NSString stringWithFormat:@"%@%@",folder, tag]  //传入文件夹名和标示，拼装缓存文件夹名字

#define KyoDataCacheTagFolderWithUserId(folder, tag, userId) [NSString stringWithFormat:@"%@%@%@",folder,userId, tag]  //传入文件夹名和标示，拼装缓存文件夹名字

typedef enum {
  KyoDataCacheTypeTempPath = 0, //临时缓存
    KyoDataCacheTypePath = 1    //重要缓存（一般情况不删除的）
} KyoDataCacheType;

@interface KyoDataCache : NSObject

+ (nonnull KyoDataCache *)sharedWithType:(KyoDataCacheType)type;

@property (assign, nonatomic) NSUInteger totalCostLimit;    /**< 限制的nscache图片缓存data最大值，默认1*1024*1024 */
@property (assign, nonatomic) NSUInteger countLimit;    /**< 限制的nscache图片缓存的最大数量，默认10 */

//*****path
- (nonnull NSString *)getPath;  /**< 得到路径 */
- (nonnull NSString *)getWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId;    /**< 根据userId和对应类别的文件夹名称得到预约的路径(自动创建) */
- (nonnull NSString *)getWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId withSuffix:(nonnull NSString *)suffix;    /**< 根据userId和对应类别的文件夹名称和后缀得到预约的路径(自动创建) */
- (nonnull NSString *)getDonNotCreateWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId;    /**< 根据userId和对应类别的文件夹名称得到预约的路径(不自动创建) */
- (nonnull NSString *)getDonNotCreateWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId  withSuffix:(nonnull NSString *)suffix;    /**< 根据userId和对应类别的文件夹名称和后缀得到预约的路径(不自动创建) */

//*****get
- (nullable id)readDataWithFolderName:(nullable NSString *)folderName withUserID:(nullable NSString *)userId; /**< 根据文件夹名称和userid得到文件数据 */
- (nullable id)readDataWithFolderName:(nullable NSString *)folderName; /**< 根据文件夹名称得到文件数据 */

//*****set
- (BOOL)writeToDataWithFolderName:(nullable NSString *)folderName withUserId:(nullable NSString *)userId withData:(nonnull id)data;  /**< 根据根据文件夹名称和userid和数据写入文件中 */
- (BOOL)writeToDataWithFolderName:(nullable NSString *)folderName withData:(nonnull id)data;  /**< 根据根据文件夹名称和数据写入文件中 */

//*****delete
- (BOOL)deleteToDataWithFileName:(nullable NSString *)fileName withUserId:(nullable NSString *)userId; /**< 根据根据文件名称和userid删除缓存文件 */
- (BOOL)deleteToDataWithFileName:(nullable NSString *)fileName;   /**< 根据文件名称删除缓存文件 */
- (BOOL)deleteAllDataWithContainFolderName:(nullable NSString *)folderName;  /**< 删除包含文件夹关键字的缓存文件夹 */
- (BOOL)deleteAllData;  /**< 删除所有缓存的文件夹和文件 */

//图片缓存
- (nullable UIImage *)imageNamed:(nonnull NSString *)name;

- (nonnull NSString *)currentVersion;   /**< 获得当前版本号 */


@end
