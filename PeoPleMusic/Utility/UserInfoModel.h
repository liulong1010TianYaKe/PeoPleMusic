//
//  UserInfoModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/5.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic, assign) BOOL admin; // 管理员权限 必须
@property (nonatomic, strong) NSString* userId;  // 用户id, 手机 mac 地址  必须
@property (nonatomic, strong) NSString* userName; // 用户昵称，手机设备名称   必须
@end
