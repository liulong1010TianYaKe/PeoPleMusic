//
//  DeviceModel.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/17.
//  Copyright © 2016年 zhuniT All rights reserved.
//

#import "DeviceModel.h"


@implementation DeviceInfor




@end
@implementation DeviceModel
+ (NSDictionary *)dictDeviceWithModel:(DeviceModel *)model{
    if (!model) {
        model = [[DeviceModel alloc] init];
        model.deviceId = @"";
        model.deviceVersion = @"";
    }
    return [model keyValues];
}
@end
