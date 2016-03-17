//
//  HomeViewController.m
//  PeoPleMusic
//
//  Created by long on 12/2/15.
//  Copyright © 2015 long. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "MyDeviceViewController.h"
#import "SpeakerControlViewController.h"
#import "SpeakerManagerViewController.h"
#import "FeedBackViewController.h"
#import "SetHelperViewController.h"
#import "LinkDeviceViewController.h"
#import "YMSocketHelper.h"

@interface HomeViewController ()<NSNetServiceDelegate>

@property (nonatomic, strong) NSDictionary *dictData;

@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = nil;
    [self addAutoScrollLabelTitle:@"个人中心"];
//    [[YMSocketHelper share] pushSSIDAndPWD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupView{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCell class]) bundle:nil] forCellReuseIdentifier:KHomeCellIdentify];
}

- (void)setupData{
   
    __weak typeof(self)weekSelf = self;
    NSMutableArray *tempArr1  = [NSMutableArray array];
    HomeModel *model1 = [[HomeModel alloc] init];
    model1.imgIcon = @"icon_jinbi";
    model1.title = @"我的金币";
    model1.subTitle = @"9088";
    model1.subtitleColor = YYColorFromRGB(0xfc4040);
    [tempArr1 addObject:model1];
    HomeModel *model2 = [[HomeModel alloc] init];
    model2.imgIcon = @"icon_my_device";
    model2.title = @"我的音响";
    model2.subTitle = @"为连接设备";
    model2.blockOperation = ^{
//        [weekSelf.navigationController pushViewController:[MyDeviceViewController createMyDeviceViewController] animated:YES];
        
        // 注册服务
        NSNetService *netService = [[NSNetService alloc] initWithDomain:@"local." type:@"_znt_rrdg_sp._tcp" name:@"" port:2222];
        netService.delegate = self;
        [netService publish];
    };
    [tempArr1 addObject:model2];
    HomeModel *model3 = [[HomeModel alloc] init];
    model3.imgIcon = @"icon_my_device";
    model3.title = @"添加音乐";
    model3.subTitle = @"人人点歌－2号音响";
    model3.blockOperation = ^{
        [weekSelf.navigationController pushViewController:[MyDeviceViewController createMyDeviceViewController] animated:YES];
    };
    [tempArr1 addObject:model3];
    
 
    
    NSMutableArray *tempArr2  = [NSMutableArray array];

    
    HomeModel *model21 = [[HomeModel alloc] init];
    model21.imgIcon = @"icon_set_feed_back";
    model21.title = @"使用反馈";
    model21.blockOperation = ^{
        [weekSelf.navigationController pushViewController:[FeedBackViewController createSFeedBackViewController] animated:YES];
    };
    [tempArr2 addObject:model21];
    
    HomeModel *model22 = [[HomeModel alloc] init];
    model22.imgIcon = @"icon_set_help";
    model22.title = @"操作指南";
    model22.blockOperation = ^{
        [weekSelf.navigationController pushViewController:[SetHelperViewController createSetHelperViewController] animated:YES];
    };
    [tempArr2 addObject:model22];

    HomeModel *model23 = [[HomeModel alloc] init];
    model23.imgIcon = @"icon_speaker_manager";
    model23.title = @"关于我们";
    model23.blockOperation = ^{
//        [weekSelf.navigationController pushViewController:[SpeakerManagerViewController createMSpeakerManagerViewController ] animated:YES];
        [[YMSocketHelper share] searchAirPlaySevices];
    };
    [tempArr2 addObject:model23];
    
    _array = [NSMutableArray arrayWithObjects:tempArr1,tempArr2, nil];
   
    
}

- (void)netServiceWillPublish:(NSNetService *)sender{
    
}

- (void)netServiceDidPublish:(NSNetService *)sender{
    NSLog(@"发布成功!---%@ %@",sender.type,sender.hostName);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *, NSNumber *> *)errorDict{
    
}
#pragma mark ---------------------
#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:KHomeCellIdentify];
    cell.indexpath = indexPath;
    cell.model = _array[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath     //重写父类中的方法
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   HomeModel *homeModel =  _array[indexPath.section][indexPath.row];
//    if (indexPath.section == 0) {
//        if (indexPath.row == 1) {
            if (homeModel.blockOperation) {
                homeModel.blockOperation();
            }
//        }
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"用户信息";
    }else if(section == 1){
        return @"系统设置";
    }
    return nil;
}
@end
