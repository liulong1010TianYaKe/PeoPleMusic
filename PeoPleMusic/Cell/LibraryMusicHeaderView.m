//
//  LibraryMusicHeaderView.m
//  PeoPleMusic
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 zhuniT All rights reserved.
//

#import "LibraryMusicHeaderView.h"
#import "YMTCPClient.h"
#import "YMBonjourHelp.h"
#import "DeviceMusicViewController.h"
#import "SeachSongViewController.h"
#import "SearchDeviceViewController.h"
#import "MusicListViewController.h"


@interface LibraryMusicHeaderView ()<UISearchBarDelegate,UIAlertViewDelegate>
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



 //音响在线音乐
- (IBAction)btnLoadTouchInside:(id)sender {
    if ([YMTCPClient share].isConnect) {
        MusicListViewController *musicPlayerVC = [MusicListViewController createMusicListViewController];
        musicPlayerVC.style = MusiclistViewStyleDeviceOnline;
        musicPlayerVC.title = @"音响在线";
        [[KyoUtil getCurrentNavigationViewController]  pushViewController:musicPlayerVC animated:YES];;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未连接音响设备，确定添加吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

// 音响本地
- (IBAction)btnSpeakerTouchInside:(id)sender {
    
    if ([YMTCPClient share].isConnect) {
         DeviceMusicViewController *controller = [DeviceMusicViewController createDeviceMusicViewController];
         controller.title = @"音响本地";
        [[KyoUtil getCurrentNavigationViewController] pushViewController:controller animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未连接音响设备，确定添加吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SeachSongViewController *controller = [SeachSongViewController createSeachSongViewController];
    controller.title = @"搜索歌曲";
    [[KyoUtil getCurrentNavigationViewController] pushViewController:controller animated:YES];
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        SearchDeviceViewController *searchVC = [SearchDeviceViewController createSearchDeviceViewController];
        [[KyoUtil getCurrentNavigationViewController] pushViewController:searchVC animated:YES];
    }
}

@end
