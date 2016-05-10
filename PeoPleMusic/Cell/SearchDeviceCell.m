//
//  SearchDeviceCell.m
//  PeoPleMusic
//
//  Created by long on 5/5/16.
//  Copyright © 2016 zhuniT All rights reserved.
//

#import "SearchDeviceCell.h"

@implementation SearchDeviceCell



- (void)setModel:(DeviceVodBoxModel *)model{
    _model = model;
    if (model) {

        self.lblName.text = model.name;
        self.lblAddress.text = model.address;
        
        if (model.isNeedDevice) {
            self.lblName.textColor = YYColorFromRGB(0xFF993D);
            self.lblAddress.textColor = YYColorFromRGB(0xFF993D);
        }else{
            self.lblAddress.textColor = YYColorFromRGB(0x666666);
            self.lblName.textColor = YYColorFromRGB(0x666666);
        }
        
        self.imgSelect.hidden = !model.isConnectIP;
//        DeviceVodBoxModel *currModel =    [UserInfo sharedUserInfo].deviceVodBoxModel;
//        if ([model.ip isEqualToString:currModel.ip] && [model.wifiMac isEqualToString:currModel.wifiMac]) {
//            self.imgSelect.hidden = NO;
//        }else{
//            self.imgSelect.hidden = YES;
//        }
        
    }
}



@end
