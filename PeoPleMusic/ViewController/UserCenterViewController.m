//
//  UserCenterViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/27.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "UserCenterViewController.h"


@interface UserCenterSectionHeaderView : UIView
@property (nonatomic, strong) NSString *title;



@end


@interface UserCenterViewController (){
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

@interface UserCenterViewController ()

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
    _isConnect = NO;
}

- (void)setupData{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidConnect:) name:YNotificationName_SOCKETDIDCONNECT object:nil];  //连接音响通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidDisconnect:) name:YNotificationName_SOCKETDIDDISCONNECT object:nil];  //断开音响连接通知
}

#pragma mark -------------------
#pragma mark - Method
- (void)refreshViews{
    
    if (_isConnect) {
        self.lblMyDev.text = @"未连接设备";
    }else{
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
}
- (IBAction)switchChangeValue:(UISwitch *)sender {

    if (sender.on) {
        KyoLog(@"开启");
    }else{
        KyoLog(@"关闭");
    }
}

#pragma mark --------------------
#pragma mark - NSNotification

//连接音响通知
- (void)socketDidConnect:(NSNotification *)noti{
    _isConnect = YES;
    [self refreshViews];
}
//断开音响连接通知
- (void)socketDidDisconnect:(NSNotification *)noti{
    _isConnect = NO;
    [self refreshViews];
}
@end
