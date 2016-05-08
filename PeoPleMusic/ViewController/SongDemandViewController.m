//
//  SongDemandViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 zhuniT All rights reserved.
//  歌曲点播

#import "SongDemandViewController.h"
#import "NSString+Easy.h"
#import "AddDeviceViewController.h"

@interface SongDemandViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblAlbumName;
@property (weak, nonatomic) IBOutlet UILabel *lblCornNum;
@property (weak, nonatomic) IBOutlet UILabel *lblNeedCorn;
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnDianBo;
@property (weak, nonatomic) IBOutlet IQTextView *txtlblCornNumb;

@end
@implementation SongDemandViewController


+ (SongDemandViewController *)createSongDemandViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    SongDemandViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SongDemandViewController class])];
    return controller;
}

- (void)setupView{
    
    self.lblSongName.text = self.songInfoModel.mediaName;
    self.lblAlbumName.text = self.songInfoModel.albumName;
    self.btnDianBo.layer.cornerRadius = 4;
//    self.btnDianBo.layer.borderColor = kNavigationBarTintColor.CGColor;
    self.btnDianBo.layer.borderColor = [UIColor redColor].CGColor;
    self.btnDianBo.layer.borderWidth = 1;
    self.btnDianBo.layer.masksToBounds = YES;
    self.textView.placeholder = @"说点什么呢～";
    
    [self reSetBackButtonMethod:@selector(btnBackTouchIn:)];
    NSInteger durSec = (NSInteger)self.duration / 60;//总秒
    NSInteger durMin = (NSInteger)self.duration % 60;//总分钟
    
    self.lblSongDuration.text = [NSString stringWithFormat:@"当前歌曲时长:%ld分%ld秒",(long)durSec,(long)durMin];
}

- (void)setupData{
    
}

- (void)btnBackTouchIn:(UIButton *)btn{
  
    [self.navigationController popViewControllerAnimated:YES];
    if (self.btnBackBlockOperation) {
        self.btnBackBlockOperation();
    }
}
- (IBAction)btnDianBoTouchInside:(id)sender {
    
    if (![YMTCPClient share].isConnect) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未连接音响设备，确定添加吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        [alertView show];
        return;
    }
    NSInteger durMin = (NSInteger)self.duration / 60;//总分钟
    if (durMin > 9) {
        [self showMessageHUD:@"亲，当前歌曲不符合要求!" withTimeInterval:kShowMessageTime];
        return;
    }
//    if (self.type == MusiclistViewStyleNetwork && [UserInfoModel shareUserInfo].permission == 1) {
//    
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"播放权限提示" message:@"当前音响只能播放音响内置歌曲,如需要播放第三方歌曲，请联系管理员" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
//        alertView.tag = 1000;
//        [alertView show];
//        return;
//    }
    
    self.songInfoModel.coin = [self.txtlblCornNumb.text trim];
    self.songInfoModel.playMsg = [self.textView.text trim];
    [self showLoadingHUD:@"点播歌曲"];
    
//    [self requestNetwork];
    [[YMTCPClient share] networkSendBookSongInfo:self.songInfoModel withPlayType:self.playStyle completionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
        
        if (result == 0) { // 点播成功
            
         
            
            NSArray *teamArr = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:teamArr];
            [arr addObject:self.songInfoModel];
            
            [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG withData:arr];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideLoadingHUD];
                
                [self showMessageHUD:@"点播成功！" withTimeInterval:kShowMessageTime];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
           
        }else if(result==3){ // 重复点播
            
            dispatch_sync(dispatch_get_main_queue(), ^{
            [self hideLoadingHUD];
            [self showMessageHUD:@"重复点播！" withTimeInterval:kShowMessageTime];
                
//                [self requestNetwork];
            });

        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideLoadingHUD];
                [self showMessageHUD:@"点播失败！" withTimeInterval:kShowMessageTime];
            });
        }
    }];
}

- (void)requestNetwork{
    [[YMTCPClient share] networkSendBookSongInfo:self.songInfoModel withPlayType:2 completionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
        if (result == 0) { // 点播成功
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideLoadingHUD];
                [self showMessageHUD:@"点播成功！" withTimeInterval:kShowMessageTime];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
            
            
        }else if(result==3){ // 重复点播
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideLoadingHUD];
                [self showMessageHUD:@"重复点播！" withTimeInterval:kShowMessageTime];
                
                
            });
            
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideLoadingHUD];
                [self showMessageHUD:@"点播失败！" withTimeInterval:kShowMessageTime];
            });
        }
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            AddDeviceViewController *addVC = [AddDeviceViewController createAddDeviceViewController];
            [[KyoUtil getCurrentNavigationViewController] pushViewController:addVC animated:YES];
        }
    }
 
}

@end
