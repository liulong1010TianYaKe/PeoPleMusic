//
//  DeviceMusicViewController.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/31.
//  Copyright © 2016年 zhuniT All rights reserved.
//  音响本地

#import "BasicsViewController.h"

typedef enum : NSUInteger {
    DeviceMusicViewControllerLoc,
    DeviceMusicViewControllerOnline,
} DeviceMusicViewControllerType;

@interface DeviceMusicViewController : BasicsViewController

@property (nonatomic,assign) DeviceMusicViewControllerType type;
+ (DeviceMusicViewController *)createDeviceMusicViewController;
@end
