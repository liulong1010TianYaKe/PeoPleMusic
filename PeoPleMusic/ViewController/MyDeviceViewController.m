//
//  MyDeviceViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "MyDeviceViewController.h"

@interface MyDeviceViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgScan;

@property (weak, nonatomic) IBOutlet UILabel *lblAssist;
@end

@implementation MyDeviceViewController

+ (MyDeviceViewController *)createMyDeviceViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    MyDeviceViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MyDeviceViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setupView{
    self.title = @"我的音响";
    self.lblTitle.font = [UIFont boldSystemFontOfSize:15];
    self.lblTitle.text = @"人人点歌－2号音响";
    self.imgScan.image = [UIImage imageNamed:@"logo_76"];
    
}


@end
