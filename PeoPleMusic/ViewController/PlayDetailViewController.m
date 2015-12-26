//
//  PlayDetailViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/26.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "PlayDetailViewController.h"

@interface PlayDetailViewController ()

@end

@implementation PlayDetailViewController

+ (PlayDetailViewController *)createViewController{
    PlayDetailViewController *VC = [[PlayDetailViewController alloc] initWithNibName:NSStringFromClass([PlayDetailViewController class]) bundle:nil];
    return VC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的点播";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
