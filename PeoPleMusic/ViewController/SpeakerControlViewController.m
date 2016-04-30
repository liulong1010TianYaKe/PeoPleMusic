//
//  SpeakerControlViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "SpeakerControlViewController.h"
#import "UIImage+Tint.h"
#import "DeviceModel.h"

@interface SpeakerControlViewController ()
@property (weak, nonatomic) IBOutlet UISlider *sliderControl;

@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UIButton *btnPayer;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (nonatomic, strong) DeviceModel *deviceModel;
- (IBAction)sliderControlChange:(id)sender;
- (IBAction)btnPayerTouchInside:(UIButton *)sender;
- (IBAction)btnNextTouchInside:(id)sender;



@end

@implementation SpeakerControlViewController


+ (SpeakerControlViewController *)createSpeakerControlViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    SpeakerControlViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SpeakerControlViewController class])];
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.title = @"音响控制";
    
    self.btnPayer.layer.cornerRadius = 5;
    self.btnPayer.layer.borderColor = YYColor(236, 202, 172).CGColor;
    self.btnPayer.layer.borderWidth = 2;
    self.btnPayer.clipsToBounds = YES;
    UIImage *img = [UIImage imageWithGradientTintColor:YYColor(250, 250, 255) withSize:CGSizeMake(kWindowHeight-60, 44)];
    
    [self.btnPayer setBackgroundImage:img forState:UIControlStateNormal];
    
    self.btnNext.layer.cornerRadius = 5;
    self.btnNext.layer.borderColor = YYColor(236, 202, 172).CGColor;
    self.btnNext.layer.borderWidth = 2;
    self.btnNext.clipsToBounds = YES;
    [self.btnNext setBackgroundImage:img forState:UIControlStateNormal];
    
    self.deviceModel = [[DeviceModel alloc] init];
    self.deviceModel.playState = 0;
    
    [self requstNetworkGetVolume];
    [self requstNetworkGetVolume];
}


#pragma mark -- 获取音响的音量

- (void)requstNetworkGetVolume{
    
    [self showLoadingInNavigation];
    __weak typeof(self) weakSelf = self;
    [[YMTCPClient share] networkSendDeviceForGetDeviceVolume:^(NSInteger result, NSDictionary *dict, NSError *err) {
        if (result == 0) {
            self.deviceModel.maxVolume = [dict[@"maxVolume"] integerValue];
            self.deviceModel.volume = [dict[@"volume"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoadingInNavigation];
                self.sliderControl.value = (CGFloat)self.deviceModel.volume/self.deviceModel.maxVolume;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoadingInNavigation];
            });
        }
    }];
    
 
}

- (void)requstNetworkPlayState{
    
    [self showLoadingInNavigation];
    __weak typeof(self) weakSelf = self;
    
   
    [[YMTCPClient share] networkSendDeviceForSetDevicePlayState:^(NSInteger result, NSDictionary *dict, NSError *err) {
        if (result == 0) {
            self.deviceModel.playState = [dict[@"playState"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoadingInNavigation];
                [weakSelf refreshSubView];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoadingInNavigation];
            });
        }
    }];
}

- (IBAction)sliderControlChange:(id)sender {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupDeviceVolume];
    });
}
- (void)setupDeviceVolume{
    __weak typeof(self) weakSelf = self;
    
   
    
        NSInteger volume = self.sliderControl.value * self.deviceModel.maxVolume;
        [[YMTCPClient share] networkSendSetDeviceVolumeWithVolume:volume completionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
            if (result == 0) {
                self.deviceModel.volume = [dict[@"volume"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideLoadingInNavigation];
                    self.sliderControl.value = (CGFloat)self.deviceModel.volume/self.deviceModel.maxVolume;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideLoadingInNavigation];
                });
            }
        }];
}

- (void)refreshSubView{

    if (self.deviceModel.playState  == 0) {
        [_btnPayer setTitle:@"播放" forState:UIControlStateNormal];
        _lblState.text = @"停止播放";
        self.deviceModel.playState = 1;
    }else{
        [_btnPayer setTitle:@"停止" forState:UIControlStateNormal];
        
        _lblState.text = @"正在播放";
        self.deviceModel.playState = 0;
    }
}

- (IBAction)btnPayerTouchInside:(UIButton *)sender {
    [self refreshSubView];
    
    __weak typeof(self) weakSelf = self;
//    NSLog(@"playState %ld",(long)self.deviceModel.playState);
    [[YMTCPClient share] networkSendDeviceForSetDevicePlayState:self.deviceModel.playState completionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
        if (result == 0) {
            self.deviceModel.volume = [dict[@"volume"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoadingInNavigation];
                [weakSelf refreshSubView];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoadingInNavigation];
            });
        }
    }];
}

- (IBAction)btnNextTouchInside:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    [[YMTCPClient share] networkSendDeviceForSetDevicePlayNextSongCompletionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
        if (result == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showMessageHUD:@"播放下一首成功!" withTimeInterval:kShowMessageTime];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showMessageHUD:@"播放下一首失败!" withTimeInterval:kShowMessageTime];
            });
        }
    }];
    
}
@end
