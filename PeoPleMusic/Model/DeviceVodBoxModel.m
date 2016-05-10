//
//  DeviceVodBoxModel.m
//  PeoPleMusic
//
//  Created by long on 5/4/16.
//  Copyright © 2016 zhuniT All rights reserved.
//

#import "DeviceVodBoxModel.h"

@implementation DeviceVodBoxModel

- (BOOL)isConnectIP{
    DeviceVodBoxModel *currModel =    [UserInfo sharedUserInfo].deviceVodBoxModel;
    if ([self.ip isEqualToString:currModel.ip] && [self.wifiMac isEqualToString:currModel.wifiMac]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isNeedDevice{
    if ([self.wifiName isEqualToString:[NSString getWiFiName]] && [self.wifiMac isEqualToString:[NSString getWIFIBSSID]]) {
        return YES;
    }else{
        return NO;
    }
}
@end
