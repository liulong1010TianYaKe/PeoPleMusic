//
//  UserCenterViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/27.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "UserCenterViewController.h"
#import "AddDeviceViewController.h"



@interface UserCenterSectionHeaderView : UIView
@property (nonatomic, strong) NSString *title;



@end


@interface UserCenterViewController ()<UIAlertViewDelegate>{
    BOOL _isConnect;
}


- (void)socketDidConnect:(NSNotification *)noti;
- (void)socketDidDisconnect:(NSNotification *)noti;
@end
@implementation UserCenterSectionHeaderView{
    UILabel *_label;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.textColor = YYColorFromRGB(0x666666);
        _label.font = [UIFont systemFontOfSize:13];
        _label.textAlignment = NSTextAlignmentLeft;
        self.backgroundColor = kTableViewbackgroundColor;
        [self addSubview:_label];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    _label.text = title;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_label]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    
}


@end
@import StoreKit;
@interface UserCenterViewController ()<SKStoreProductViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblCoreNumb; // 金币
@property (weak, nonatomic) IBOutlet UILabel *lblMyDev;  // 我的音响
@property (weak, nonatomic) IBOutlet UILabel *lblManager;  // 音响配置
@property (weak, nonatomic) IBOutlet UILabel *lblControl;  // 音响控制

- (IBAction)switchChangeValue:(UISwitch *)sender;

@end

@implementation UserCenterViewController


+ (UserCenterViewController *)createUserCenterViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    UserCenterViewController *controller = [sb instantiateInitialViewController];
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.title = @"个人中心";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
  
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshViews];
}
- (void)openAppWithIndentifier:(NSString *)appId{
    BOOL openInApp = NO;
    if (openInApp) {
        [self showLoadingHUD:nil];
        SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
        storeProductVC.delegate = self;
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
        [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError * _Nullable error) {
            if (result) {
                [self presentViewController:storeProductVC animated:YES completion:nil];
            }
        }];
        
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appId];
        NSURL *url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (void)setupData{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidConnect:) name:YNotificationName_SOCKETDIDCONNECT object:nil];  //连接音响通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidDisconnect:) name:YNotificationName_SOCKETDIDDISCONNECT object:nil];  //断开音响连接通知
}
#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender{
    
    if ([identifier isEqualToString:@"SegueMyDevice"] ||
        [identifier isEqualToString:@"SegueManage"]||
        [identifier isEqualToString:@"SegueControl"]) {
        if (![YMTCPClient share].isConnect) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未连接音响设备，确定添加吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return NO;
        }else{
            return YES;
        }
        
    }else{
        return YES;
    }
    
}


#pragma mark -------------------
#pragma mark - Method
- (void)refreshViews{
    
    if (![YMTCPClient share].isConnect) {
        self.lblMyDev.text = @"未连接设备";
    }else{
        DeviceInfor *deviceInfo = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK];
        self.lblMyDev.text = deviceInfo.name;
    }
}

#pragma mark -------------------
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UserCenterSectionHeaderView *headerView = [[UserCenterSectionHeaderView alloc] init];
    if (section == 0) {
        headerView.title = @"用户信息";
    }else if(section == 1){
        headerView.title = @"管理员";
    }else if (section == 2){
        headerView.title = @"系统设置";
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0) { // 给我打分
         [self openAppWithIndentifier:@"1038333077"];
    }
    
}
- (IBAction)switchChangeValue:(UISwitch *)sender {

    if (sender.on) {
        KyoLog(@"开启");
    }else{
        KyoLog(@"关闭");
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        AddDeviceViewController *addVC = [AddDeviceViewController createAddDeviceViewController];
        [self.navigationController pushViewController:addVC animated:YES];
    }
}
#pragma mark --------------------
#pragma mark - NSNotification

//连接音响通知
- (void)socketDidConnect:(NSNotification *)noti{

    [self refreshViews];
}
//断开音响连接通知
- (void)socketDidDisconnect:(NSNotification *)noti{

    [self refreshViews];
}
@end
