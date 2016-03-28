//
//  SpeakerManagerViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "SpeakerManagerViewController.h"

@interface SpeakerManagerViewController ()<UITextFieldDelegate>{
    CGColorRef origColor;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;

@property (weak, nonatomic) IBOutlet UITextField *textFieldNumb;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWiFi;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPassworld;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;

@property (nonatomic, strong) DeviceInfor *deviceInfo;
@end

@implementation SpeakerManagerViewController


+ (SpeakerManagerViewController *)createMSpeakerManagerViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    SpeakerManagerViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SpeakerManagerViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _textFieldName.layer.borderWidth = 1.5;
//    _textFieldName.layer.borderColor = YYColor(199, 199, 199).CGColor;
//    _textFieldName.layer.cornerRadius = 4;
//    _textFieldName.layer.masksToBounds = YES;
//    _textFieldName.text = @"人人点歌－2号音响";
    
//    _textFieldNumb.layer.borderWidth = 1.5;
//    _textFieldNumb.layer.borderColor = YYColor(199, 199, 199).CGColor;
//    _textFieldNumb.layer.cornerRadius = 4;
//    _textFieldNumb.layer.masksToBounds = YES;
//    _textFieldNumb.text = @"c5c4d3d300d3d3";
    
//    _textFieldWiFi.layer.borderWidth = 1.5;
//    _textFieldWiFi.layer.borderColor = YYColor(199, 199, 199).CGColor;
//    _textFieldWiFi.layer.cornerRadius = 4;
//    _textFieldWiFi.layer.masksToBounds = YES;
//    _textFieldWiFi.text = @"wifi-12345";
    
//    _textFieldPassworld.layer.borderWidth = 1.5;
//    _textFieldPassworld.layer.borderColor = YYColor(199, 199, 199).CGColor;
//    _textFieldPassworld.layer.cornerRadius = 4;
//    _textFieldPassworld.layer.masksToBounds = YES;
    
}

- (void)setupTextFieldStyle:(UITextField *)textField{
    textField.layer.borderWidth = 1.5;
    textField.layer.borderColor = YYColor(199, 199, 199).CGColor;
    textField.layer.cornerRadius = 4;
    textField.layer.masksToBounds = YES;
}

- (void)setupView{
    self.title = @"音响配置";
    _btnCommit.backgroundColor = YYColor(223, 81, 0);
    _btnCommit.layer.cornerRadius = 4;
    _btnCommit.clipsToBounds = YES;
    origColor = _textFieldName.layer.borderColor;
    
    [self setupTextFieldStyle:_textFieldName];
    [self setupTextFieldStyle:_textFieldNumb];
    [self setupTextFieldStyle:_textFieldWiFi];
    [self setupTextFieldStyle:_textFieldPassworld];
}

- (void)setupData{
    
    
 
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDeviceInfofor:) name:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];  //连接音响通知
//    
    self.deviceInfo = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK];
    [self refreshSubViews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requstNetwork];
    });
    
}

- (IBAction)btnTouchInside:(id)sender {
    
   
}


- (void)refreshSubViews{
    
    _textFieldName.text = self.deviceInfo.name;
    _textFieldNumb.text = self.deviceInfo.Id;
    _textFieldWiFi.text = self.deviceInfo.wifiName;
    _textFieldPassworld.text = self.deviceInfo.wifiPwd;
}

- (void)requstNetwork{
    
    [self showLoadingInNavigation];
    __weak typeof(self) weakSelf = self;
    [[YMTCPClient share] networkSendDeviceForRegisterWithCompletionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
        if (result == 0) {
            NSDictionary *tempDict  = [dict objectForKey:@"deviceInfor"];
            self.deviceInfo =  [DeviceInfor objectWithKeyValues:tempDict];
            [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK withData:self.deviceInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoadingInNavigation];
                [weakSelf refreshSubViews];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideLoadingInNavigation];
            });
        }
    }];
}
#pragma mark --



- (void)textFieldDidBeginEditing:(UITextField *)textField{           // became first responder
    textField.layer.borderWidth = 2;
    textField.layer.borderColor = YYColor(218, 140, 80).CGColor;
    textField.layer.cornerRadius = 3;
    textField.layer.masksToBounds = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1.5;
    textField.layer.borderColor = YYColor(199, 199, 199).CGColor;
    textField.layer.cornerRadius = 4;
    textField.layer.masksToBounds = YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _textFieldName) {
        [_textFieldNumb becomeFirstResponder];
    }else if (textField == _textFieldNumb){
        [_textFieldWiFi becomeFirstResponder];
    }else if (textField == _textFieldWiFi){
        [_textFieldPassworld becomeFirstResponder];
    }else if (textField == _textFieldPassworld){
        [_textFieldPassworld resignFirstResponder];
    }
    return YES;
}

#pragma mark --------------------
#pragma mark - NSNotification
- (void)receiveDeviceInfofor:(NSNotification *)noti{
    
}

@end
