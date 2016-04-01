//
//  ChaboView.m
//  PeoPleMusic
//
//  Created by apple on 15/12/26.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "ChaboView.h"


@interface ChaboView ()
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UILabel *lblJbNumb;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSeg1;
@property (weak, nonatomic) IBOutlet UIImageView *imgSeg2;

@end
@implementation ChaboView

+ (instancetype)createChaboViewFromWindow{
    
    ChaboView *feedBackView = [[[NSBundle mainBundle] loadNibNamed:@"ChaboView" owner:self options:nil] firstObject];
    
    
    return feedBackView;
}
- (void)awakeFromNib{
    _txtField.layer.borderWidth = 1.5;
    _txtField.layer.borderColor = YYColor(199, 199, 199).CGColor;
    _txtField.layer.cornerRadius = 4;
    _txtField.layer.masksToBounds = YES;
    
    [self bringSubviewToFront:self.imgSeg1];
    [self bringSubviewToFront:self.imgSeg2];
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
    
    [self.txtField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (IBAction)btnCommitTouchInside:(id)sender {
//    [self close];
    if (self.btnSubmitBlockOperation) {
        self.btnSubmitBlockOperation();
    }
}

- (IBAction)btnCancelTouchInside:(id)sender {
    [self close];
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
