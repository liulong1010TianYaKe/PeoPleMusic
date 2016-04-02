//
//  AddDeviceViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/4/2.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "AddDeviceViewController.h"

// 正在自动扫描当前网络设备...
// 未扫描到设备，请切换其他网络设备重试

@interface AddDeviceCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblDevice;

@property (weak, nonatomic) IBOutlet UILabel *lblWiFiName;


@end
@implementation AddDeviceCell



@end

@interface AddDeviceViewController (){
    double  angle;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgCycle;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
- (IBAction)btnUpdateTouchInside:(id)sender;
- (IBAction)btnScanTouchInside:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblScanText;

@property (nonatomic, assign) BOOL isStopBtnUpdateAnimation;
- (IBAction)btnBackTouchInside:(id)sender;

@property (nonatomic,strong) NSArray *arr;
@end

@implementation AddDeviceViewController


+ (AddDeviceViewController *)createAddDeviceViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    AddDeviceViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([AddDeviceViewController class])];
    return controller;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    [UIApplication sharedApplication].
//    self.hidesBottomBarWhenPushed = YES;
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)setIsStopBtnUpdateAnimation:(BOOL)isStopBtnUpdateAnimation{
    _isStopBtnUpdateAnimation = isStopBtnUpdateAnimation;
}
-(void)startAnimation
{
    _isStopBtnUpdateAnimation = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.btnUpdate.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}
-(void)endAnimation
{
    angle += 5;
    if (!_isStopBtnUpdateAnimation) {
        [self startAnimation];
    }
    
}
#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AddDeviceCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDeviceCell"];
    cell.indexPath = indexPath;
    
   
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
}



- (IBAction)btnUpdateTouchInside:(id)sender {
    [self startAnimation];
    self.lblScanText.hidden = NO;
    self.lblScanText.text = @"在自动扫描当前网络设备...";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isStopBtnUpdateAnimation = YES;
        self.lblScanText.text = @"在未扫描到设备，请切换其他网络设备重试";
        
    });
}

- (IBAction)btnScanTouchInside:(id)sender {
    self.isStopBtnUpdateAnimation = YES;
}
- (IBAction)btnBackTouchInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
