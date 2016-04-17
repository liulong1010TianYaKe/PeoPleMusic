//
//  SongDemandViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 kyo. All rights reserved.
//  歌曲点播

#import "SongDemandViewController.h"

@interface SongDemandViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblAlbumName;
@property (weak, nonatomic) IBOutlet UILabel *lblCornNum;
@property (weak, nonatomic) IBOutlet UILabel *lblNeedCorn;
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnDianBo;

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
    
}

//- (void)

- (void)btnBackTouchIn:(UIButton *)btn{
  
    [self.navigationController popViewControllerAnimated:YES];
    if (self.btnBackBlockOperation) {
        self.btnBackBlockOperation();
    }
}
- (IBAction)btnDianBoTouchInside:(id)sender {
    
    self.songInfoModel.playMsg = self.textView.text;
    [self showLoadingHUD:@"点播歌曲"];
    [[YMTCPClient share] networkSendBookSongInfo:self.songInfoModel withPlayType:self.playStyle completionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
        
        if (result == 0) { // 点播成功
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideLoadingHUD];
                
                [self showMessageHUD:@"点播成功！" withTimeInterval:kShowMessageTime];
            });
            
            NSArray *teamArr = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:teamArr];
            [arr addObject:self.songInfoModel];
            
            [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG withData:arr];
           
        }else if(result==3){ // 重复点播
            
            dispatch_sync(dispatch_get_main_queue(), ^{
            [self hideLoadingHUD];
            [self showMessageHUD:@"重复点播！" withTimeInterval:kShowMessageTime];
                
                [self requestNetwork];
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

@end
