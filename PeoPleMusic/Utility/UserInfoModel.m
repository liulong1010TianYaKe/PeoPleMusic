//
//  UserInfoModel.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/5.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "UserInfoModel.h"


@implementation UserInfoModel

+ (instancetype)shareUserInfo{
    static UserInfoModel *_share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[UserInfoModel alloc] init];
        _share.permission = 0;
    });
    return _share;
}
+ (NSDictionary *)getUserInfoDict:(BOOL)isAdmin{
    UserInfoModel *model = [[UserInfoModel alloc] init];
    model.isAdmin = isAdmin;
    model.userIp = [NSString localWiFiIPAddressAndPort];
    model.userName = [NSString stringWithFormat:@"%@%@%@",[UIDevice currentDevice].name,[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    model.userId = [UIDevice getUUID];
    return [model keyValues];
}
@end
