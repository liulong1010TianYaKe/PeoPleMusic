//
//  LinkDeviceViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/5.
//  Copyright © 2016年 zhuniT All rights reserved.
//

#import "LinkDeviceViewController.h"


@interface LinkDeviceViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblWiFi;
@end

@implementation LinkDeviceViewController

+ (LinkDeviceViewController *)createLinkDeviceViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    LinkDeviceViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([LinkDeviceViewController class])];
    return controller;
}
- (void)viewDidLoad{
    [super viewDidLoad];
     self.title = @"连接设备";
//     self.lblWiFi.text = [KyoSocketHelper fetchCurrentWiFiName];
}
@end
