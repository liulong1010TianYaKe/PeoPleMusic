//
//  DeviceModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/17.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
@property (nonatomic, strong) NSString *deviceId;  //音响id，扫描音响二维码时获取
@property (nonatomic, strong) NSString *deviceVersion;  //音响系统的版本号

+ (NSDictionary *)dictDeviceWithModel:(DeviceModel *)model;
@end
