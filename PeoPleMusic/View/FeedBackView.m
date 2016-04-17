//
//  FeedBackView.m
//  PeoPleMusic
//
//  Created by apple on 15/12/25.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "FeedBackView.h"


@interface FeedBackView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
@implementation FeedBackView

+ (instancetype)createFeedBackViewFromWindow{
    
    FeedBackView *feedBackView = [[[NSBundle mainBundle] loadNibNamed:@"FeedBackView" owner:self options:nil] firstObject];
    
    
    return feedBackView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
   
    _textView.layer.borderWidth = 1.5;
    _textView.layer.borderColor = YYColor(199, 199, 199).CGColor;
    _textView.layer.cornerRadius = 4;
    _textView.layer.masksToBounds = YES;
    
    _textView.layer.borderWidth = 1.5;
    _textView.layer.borderColor = YYColor(199, 199, 199).CGColor;
    _textView.layer.cornerRadius = 4;
    _textView.layer.masksToBounds = YES;
    
    self.textView.placeholder = @"说点什么吧~";
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecoginzer:)];
    [self.backView addGestureRecognizer:tapGR];
}

- (void)tapGestureRecoginzer:(UITapGestureRecognizer *)GR{
    
    [self close];
}

- (void)show{
    
    if (self == nil) {
        return;
    }
    self.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight);
   
    [[KyoUtil getRootViewController].view addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    }];
    
    
}

- (void)close{
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (IBAction)btnCancelTouchInside:(id)sender {
    [self  close];
}

- (IBAction)btnCommitTouchInside:(id)sender {
//    [self  close];
    if (self.btnSubmitBlockOperation) {
        self.btnSubmitBlockOperation();
    }
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    self.lblPlaceHolder.hidden = YES;
    textView.layer.borderWidth = 2;
    textView.layer.borderColor = YYColor(218, 140, 80).CGColor;
    textView.layer.cornerRadius = 3;
    textView.layer.masksToBounds = YES;
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
//
    
    textView.layer.borderWidth = 1.5;
    textView.layer.borderColor = YYColor(199, 199, 199).CGColor;
    textView.layer.cornerRadius = 4;
    textView.layer.masksToBounds = YES;
}

@end
