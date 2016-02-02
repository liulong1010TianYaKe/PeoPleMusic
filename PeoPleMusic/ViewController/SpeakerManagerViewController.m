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

@end

@implementation SpeakerManagerViewController


+ (SpeakerManagerViewController *)createMSpeakerManagerViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    SpeakerManagerViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SpeakerManagerViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textFieldName.layer.borderWidth = 1.5;
    _textFieldName.layer.borderColor = YYColor(199, 199, 199).CGColor;
    _textFieldName.layer.cornerRadius = 4;
    _textFieldName.layer.masksToBounds = YES;
    _textFieldName.text = @"人人点歌－2号音响";
    
    _textFieldNumb.layer.borderWidth = 1.5;
    _textFieldNumb.layer.borderColor = YYColor(199, 199, 199).CGColor;
    _textFieldNumb.layer.cornerRadius = 4;
    _textFieldNumb.layer.masksToBounds = YES;
    _textFieldNumb.text = @"c5c4d3d300d3d3";
    
    _textFieldWiFi.layer.borderWidth = 1.5;
    _textFieldWiFi.layer.borderColor = YYColor(199, 199, 199).CGColor;
    _textFieldWiFi.layer.cornerRadius = 4;
    _textFieldWiFi.layer.masksToBounds = YES;
    _textFieldWiFi.text = @"wifi-12345";
    
    _textFieldPassworld.layer.borderWidth = 1.5;
    _textFieldPassworld.layer.borderColor = YYColor(199, 199, 199).CGColor;
    _textFieldPassworld.layer.cornerRadius = 4;
    _textFieldPassworld.layer.masksToBounds = YES;
    
}

- (void)setupView{
    self.title = @"音响配置";
    _btnCommit.backgroundColor = YYColor(223, 81, 0);
    _btnCommit.layer.cornerRadius = 4;
    _btnCommit.clipsToBounds = YES;
    origColor = _textFieldName.layer.borderColor;
    
}
- (IBAction)btnTouchInside:(id)sender {
    
   
}

#pragma mark --
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    textField.layer.borderWidth = 2;
    textField.layer.borderColor = YYColor(218, 140, 80).CGColor;
    textField.layer.cornerRadius = 3;
    textField.layer.masksToBounds = YES;
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{           // became first responder
//    textField.layer.borderColor = [UIColor clearColor].CGColor;
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
@end
