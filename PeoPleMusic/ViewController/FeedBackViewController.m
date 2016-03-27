//
//  FeedBackViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "FeedBackViewController.h"


@interface FeedBackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblPlaceHolde;
@property (weak, nonatomic) IBOutlet UITextView *textViewFeed;

@property (weak, nonatomic) IBOutlet UITextField *textFieldContact;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;

- (IBAction)btnCommitTouchInside:(id)sender;
@end

@implementation FeedBackViewController


+ (FeedBackViewController *)createSFeedBackViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    FeedBackViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([FeedBackViewController class])];
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.title = @"用户反馈";
    
    _btnCommit.backgroundColor = YYColor(223, 81, 0);
    _btnCommit.layer.cornerRadius = 4;
    _btnCommit.clipsToBounds = YES;
    
    _textViewFeed.layer.borderWidth = 1.5;
    _textViewFeed.layer.borderColor = YYColor(199, 199, 199).CGColor;
    _textViewFeed.layer.cornerRadius = 4;
    _textViewFeed.layer.masksToBounds = YES;
    
   
  
}

- (IBAction)btnCommitTouchInside:(id)sender {
//    STKAudioPlayer *play = [[KyoStreamKitHelper share] player];
//    [play play:@" http://other.web.ra01.sycdn.kuwo.cn/885f6780b5335393d0f9d94a6875e60f/56b0587c/resource/n1/128/72/84/2040807972.mp3"];
//    [play play:@"http://other.web.re01.sycdn.kuwo.cn/0e06620df2cb68aab17b5544af3e4e11/56b04611/resource/n3/14/72/1978377000.mp3"];
//    [play playURL:[NSURL URLWithString:@"http://other.web.re01.sycdn.kuwo.cn/0e06620df2cb68aab17b5544af3e4e11/56b04611/resource/n3/14/72/1978377000.mp3"]]; 
   
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.lblPlaceHolde.hidden = YES;
    textView.layer.borderWidth = 2;
    textView.layer.borderColor = YYColor(218, 140, 80).CGColor;
    textView.layer.cornerRadius = 3;
    textView.layer.masksToBounds = YES;
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        self.lblPlaceHolde.hidden = NO;
    }
    
    textView.layer.borderWidth = 1.5;
    textView.layer.borderColor = YYColor(199, 199, 199).CGColor;
    textView.layer.cornerRadius = 4;
    textView.layer.masksToBounds = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    textField.layer.borderWidth = 2;
    textField.layer.borderColor = YYColor(218, 140, 80).CGColor;
    textField.layer.cornerRadius = 3;
    textField.layer.masksToBounds = YES;
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1.5;
    textField.layer.borderColor = YYColor(199, 199, 199).CGColor;
    textField.layer.cornerRadius = 4;
    textField.layer.masksToBounds = YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
