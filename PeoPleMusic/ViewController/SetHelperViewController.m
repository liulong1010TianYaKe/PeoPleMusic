//
//  SetHelperViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "SetHelperViewController.h"

@interface SetHelperViewController ()

@end

@implementation SetHelperViewController



+ (SetHelperViewController *)createSetHelperViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    SetHelperViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SetHelperViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.title = @"操作指南";
}

@end
