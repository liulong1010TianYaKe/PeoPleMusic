//
//  LibraryMusicHeaderView.m
//  PeoPleMusic
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "LibraryMusicHeaderView.h"
#import "YMTCPClient.h"
#import "YMBonjourHelp.h"
#import "DeviceMusicViewController.h"
#import "SeachSongViewController.h"


@interface LibraryMusicHeaderView ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searBar;

//@property (weak, nonatomic) IBOutlet UITextField *txtInput;
- (IBAction)btnLoadTouchInside:(id)sender;

- (IBAction)btnSpeakerTouchInside:(id)sender;
@end
@implementation LibraryMusicHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.searBar.delegate = self;

}



// 本地下载
- (IBAction)btnLoadTouchInside:(id)sender {
 
//    [[YMTCPClient share] connectServer:<#(NSString *)#> port:<#(long)#>]
}

// 音响本地
- (IBAction)btnSpeakerTouchInside:(id)sender {
    
    DeviceMusicViewController *controller = [DeviceMusicViewController createDeviceMusicViewController];
    [[KyoUtil getCurrentNavigationViewController] pushViewController:controller animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SeachSongViewController *controller = [SeachSongViewController createSeachSongViewController];
    controller.title = @"搜索歌曲";
    [[KyoUtil getCurrentNavigationViewController] pushViewController:controller animated:YES];
    return NO;
}

@end
