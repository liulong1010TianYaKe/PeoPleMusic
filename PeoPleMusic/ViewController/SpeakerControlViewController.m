//
//  SpeakerControlViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "SpeakerControlViewController.h"
#import "UIImage+Tint.h"

@interface SpeakerControlViewController (){
    
    BOOL _isPayer;
}
@property (weak, nonatomic) IBOutlet UISlider *sliderControl;

@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UIButton *btnPayer;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)sliderControlChange:(id)sender;
- (IBAction)btnPayerTouchInside:(UIButton *)sender;
- (IBAction)btnNextTouchInside:(id)sender;

@end

@implementation SpeakerControlViewController


+ (SpeakerControlViewController *)createSpeakerControlViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
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
    _isPayer = YES;
}

- (IBAction)sliderControlChange:(id)sender {

}

- (IBAction)btnPayerTouchInside:(UIButton *)sender {
    if (_isPayer) {
        [_btnPayer setTitle:@"停止" forState:UIControlStateNormal];
        _isPayer = NO;
        _lblState.text = @"停止播放";
    }else{
        [_btnPayer setTitle:@"播放" forState:UIControlStateNormal];
        _lblState.text = @"正在播放";
        _isPayer = YES;
    }
    
}

- (IBAction)btnNextTouchInside:(id)sender {
}
@end
