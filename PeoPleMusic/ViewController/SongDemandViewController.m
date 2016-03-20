//
//  SongDemandViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 kyo. All rights reserved.
//  歌曲点播

#import "SongDemandViewController.h"

@implementation SongDemandViewController

+ (SongDemandViewController *)createSongDemandViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    SongDemandViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SongDemandViewController class])];
    return controller;
}

- (void)setupView{
    self.title = @"歌曲点播";
}

@end
