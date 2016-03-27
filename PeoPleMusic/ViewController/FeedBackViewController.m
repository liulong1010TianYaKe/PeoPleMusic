//
//  FeedBackViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "FeedBackViewController.h"
#import "NSString+Easy.h"



@interface FeedBackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblPlaceHolde;
@property (weak, nonatomic) IBOutlet UITextView *textViewFeed;

@property (weak, nonatomic) IBOutlet UITextField *textFieldContact;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;

@property (nonatomic, strong)KyoKeyboardReturnKeyHandler *returnKeyHandler;

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
    
   
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 30;
    [IQKeyboardManager sharedManager].canAdjustTextView = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.returnKeyHandler = [[KyoKeyboardReturnKeyHandler alloc] initWithViewController:self];
        [self.returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    });
    
    [self.textViewFeed addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(preAction) nextAction:@selector(nextAction) doneAction:@selector(doneAction)];
     [self.textFieldContact addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(preAction) nextAction:@selector(nextAction) doneAction:@selector(doneAction)];
    
    [self.textViewFeed setEnablePrevious:NO next:YES];
    [self.textFieldContact setEnablePrevious:YES next:NO];
  
}

- (void)preAction{
    
    [self.textViewFeed becomeFirstResponder];
}

- (void)nextAction{
    [self.textFieldContact becomeFirstResponder];
}

- (void)doneAction{
    [self.view endEditing:YES];
}

- (IBAction)btnCommitTouchInside:(id)sender {
    if (![[self.textViewFeed.text trim] isMatchedByRegex:kRegex_NotEmpty] ) {
        [self showMessageHUD:@"亲，反馈信息不为空哦~" withTimeInterval:kShowMessageTimeOne];
        return ;
    }
    
    if(![[self.textFieldContact.text trim] isMatchedByRegex:kRegex11Phone]){
        [self showMessageHUD:@"请输入有效的手机号" withTimeInterval:kShowMessageTimeOne];
        return;
    }
   
    [self showLoadingHUD:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoadingHUD];
        [self showMessageHUD:@"亲，感谢宝贵的反馈信息!" withTimeInterval:kShowMessageTimeOne];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    });
}




- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.layer.borderWidth = 2;
    textView.layer.borderColor = YYColor(218, 140, 80).CGColor;
    textView.layer.cornerRadius = 3;
    textView.layer.masksToBounds = YES;
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



- (void)textFieldDidBeginEditing:(UITextField *)textField{
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
    [textField resignFirstResponder];
    return YES;
}

@end
