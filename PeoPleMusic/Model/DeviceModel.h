//
//  DeviceModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/17.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceInfor : NSObject
@property (nonatomic, strong) NSString *wifiPwd;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *wifiName;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *name;
@end

@interface DeviceModel : NSObject
@property (nonatomic, strong) NSString *deviceId;  //音响id，扫描音响二维码时获取
@property (nonatomic, strong) NSString *deviceVersion;  //音响系统的版本号

@property (nonatomic, assign) CGFloat maxVolume;
@property (nonatomic, assign) CGFloat volume;

@property (nonatomic, assign) NSInteger playState; //0, 播放；1，停止
+ (NSDictionary *)dictDeviceWithModel:(DeviceModel *)model;
@end
