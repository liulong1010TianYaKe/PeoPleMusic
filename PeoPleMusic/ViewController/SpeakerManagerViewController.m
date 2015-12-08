//
//  SpeakerManagerViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "SpeakerManagerViewController.h"

@interface SpeakerManagerViewController ()

@end

@implementation SpeakerManagerViewController


+ (SpeakerManagerViewController *)createMSpeakerManagerViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    SpeakerManagerViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SpeakerManagerViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.title = @"音响配置";
}

@end
