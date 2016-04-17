//
//  UserInfoModel.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/5.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "UserInfoModel.h"


@implementation UserInfoModel
+ (NSDictionary *)getUserInfoDict:(BOOL)isAdmin{
    UserInfoModel *model = [[UserInfoModel alloc] init];
    model.isAdmin = isAdmin;
    model.userIp = [NSString localWiFiIPAddressAndPort];
    model.userName = [NSString stringWithFormat:@"%@%@%@",[UIDevice currentDevice].name,[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    model.userId = [UIDevice getUUID];
    return [model keyValues];
}
@end
