//
//  UserInfoModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/5.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDevice-Hardware.h"
#import "NSString+IPAddress.h"

@interface UserInfoModel : NSObject

+ (instancetype)shareUserInfo;
@property (nonatomic, assign) BOOL isAdmin; // 管理员权限 必须
@property (nonatomic, strong) NSString* userIp;  // 用户id, 手机 mac 地址  必须
@property (nonatomic, strong) NSString* userName; // 用户昵称，手机设备名称   必须
@property (nonatomic, strong) NSString* userId; // 用户昵称，手机设备名称   必须 874f72020afeb7f8


@property (nonatomic,assign) NSInteger permission; 
/**
 *  返回用户手机信息
 *
 *  @param isAdmin  是否是管理员权限
 *
 *  @return {"admin":false,"userId":"26e6e131a64ff212","userName":"DG-HUAWEI P6-T00"}
 */
+ (NSDictionary *)getUserInfoDict:(BOOL)isAdmin;

@end
