//
//  RegisterSerivceModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/5.
//  Copyright © 2016年 kyo. All rights reserved.
//

// 手机客户端连接音响成功后先在所连接的音响上注册，注册后会返回音响的相关信息

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface RegisterSerivceModel : NSObject

@property (nonatomic, strong) UserInfoModel *userInfor; // 每一个数据包都需要带上用户相关信息 必须

@property (nonatomic, strong) NSString *deviceId; //音响id，扫描音响二维码时获取 非必须
@property (nonatomic, strong) NSString *deviceVersion; // 音响系统的版本号  非必须

@end
