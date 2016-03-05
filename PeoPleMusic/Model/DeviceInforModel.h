//
//  DeviceInforModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/5.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInforModel : NSObject
@property (nonatomic, strong) NSString *Id; // 必须
@property (nonatomic, strong) NSString* name; //必须
@property (nonatomic, strong) NSString* version;
@property (nonatomic, strong) NSString* wifiName; //必须
@property (nonatomic, strong) NSString* wifiPwd; // 必须

@end
