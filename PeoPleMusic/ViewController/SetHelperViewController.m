//
//  SetHelperViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 zhuniT All rights reserved.
//

#import "SetHelperViewController.h"
#import "SDCycleScrollView.h"

@interface SetHelperViewController ()<SDCycleScrollViewDelegate>

@end

@implementation SetHelperViewController



+ (SetHelperViewController *)createSetHelperViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    SetHelperViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SetHelperViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *imageNames = @[@"icon_help_one",
                            @"icon_help_two",
                            @"icon_help_three",
                            @"icon_help_four",
                            ];
    

    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 20, kWindowWidth, kWindowHeight-20) imageNamesGroup:imageNames];
   
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll =  NO;
    cycleScrollView.infiniteLoop = NO;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.pageControlDotSize = CGSizeMake(15, 15);
    
    [self.view addSubview:cycleScrollView];

    
}

- (void)setupView{
    self.title = @"操作指南";
}

@end
