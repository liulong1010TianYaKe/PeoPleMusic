//
//  DeviceVodBoxModel.h
//  PeoPleMusic
//
//  Created by long on 5/4/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceVodBoxModel : NSObject

@property (nonatomic, strong) NSString *address; //设备当前所在的位置
@property (nonatomic, strong) NSString *code;  //音响在服务器上注册的id
@property (nonatomic, strong) NSString *geohash;
@property (nonatomic, assign) NSInteger Id;  //音响的唯一识别号
@property (nonatomic, strong) NSString *ip; //设备的id地址
@property (nonatomic, assign) CGFloat  latitude; //经度
@property (nonatomic, assign) CGFloat  longitude; //纬度
@property (nonatomic, strong) NSString *name;  //音响的名字
@property (nonatomic, strong) NSString *wifiMac;  //设备连接的wifi的mac地址，也就是设备的BSSID
@property (nonatomic, strong) NSString *wifiName;  //音响当前连接的wifi名称
@property (nonatomic, strong) NSString *wifiPassword;  //Wifi密码

@end
