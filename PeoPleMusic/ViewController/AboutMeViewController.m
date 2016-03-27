//
//  AboutMeViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/27.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()
- (IBAction)btnCallTouchInside:(id)sender;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnCallTouchInside:(id)sender {
    
    [KyoUtil callPhoneWithNumber:@"18682429955"];
}
@end
