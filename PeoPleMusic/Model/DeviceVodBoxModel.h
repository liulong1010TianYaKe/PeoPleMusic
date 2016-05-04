//
//  DeviceVodBoxModel.h
//  PeoPleMusic
//
//  Created by long on 5/4/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceVodBoxModel : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *geohash;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, assign) CGFloat  latitude;
@property (nonatomic, assign) CGFloat  longitude;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *wifiMac;
@property (nonatomic, strong) NSString *wifiName;
@property (nonatomic, strong) NSString *wifiPassword;

@end
