//
//  SpeakerControlViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "SpeakerControlViewController.h"

@interface SpeakerControlViewController ()

@end

@implementation SpeakerControlViewController


+ (SpeakerControlViewController *)createSpeakerControlViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    SpeakerControlViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SpeakerControlViewController class])];
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.title = @"音响控制";
}

@end
