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

@interface HomeViewController ()

@property (nonatomic, strong) NSDictionary *dictData;

@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = nil;
    [self addAutoScrollLabelTitle:@"个人中心"];
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
    NSMutableArray *tempArr0  = [NSMutableArray array];
    
    HomeModel *model0 = [[HomeModel alloc] init];
//    model0.imgIcon = @"icon_jinbi";
    model0.title = @"设备扫描连接";
//    model0.subTitle = @"9088";
//    model0.subtitleColor = YYColorFromRGB(0xfc4040);
    model0.blockOperation = ^{
        [weekSelf.navigationController pushViewController:[[LinkDeviceViewController alloc] init] animated:YES];
    };
    
    [tempArr0 addObject:model0];
    

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
    model2.subTitle = @"人人点歌－2号音响";
    model2.blockOperation = ^{
        [weekSelf.navigationController pushViewController:[MyDeviceViewController createMyDeviceViewController] animated:YES];
    };
    [tempArr1 addObject:model2];
    
    NSMutableArray *tempArr2  = [NSMutableArray array];
    HomeModel *model3 = [[HomeModel alloc] init];
    model3.imgIcon = @"icon_speaker_manager";
    model3.title = @"音响配置";
    model3.blockOperation = ^{
        [weekSelf.navigationController pushViewController:[SpeakerManagerViewController createMSpeakerManagerViewController ] animated:YES];
    };
    [tempArr2 addObject:model3];
    
    HomeModel *model4 = [[HomeModel alloc] init];
    model4.imgIcon = @"icon_speaker_controll";
    model4.title = @"音响控制";
    model4.blockOperation = ^{
        [weekSelf.navigationController pushViewController:[SpeakerControlViewController createSpeakerControlViewController] animated:YES];
    };
    
    [tempArr2 addObject:model4];
    
    
    NSMutableArray *tempArr3  = [NSMutableArray array];
//    HomeModel *model5 = [[HomeModel alloc] init];
//    model5.imgIcon = @"icon_set_update";
//    model5.title = @"检测升级";
//    model5.subTitle = @"V1.2.1";
//    [tempArr3 addObject:model5];
    
    HomeModel *model6 = [[HomeModel alloc] init];
    model6.imgIcon = @"icon_set_feed_back";
    model6.title = @"使用反馈";
    model6.blockOperation = ^{
        [weekSelf.navigationController pushViewController:[FeedBackViewController createSFeedBackViewController] animated:YES];
    };
    [tempArr3 addObject:model6];
    
    HomeModel *model7 = [[HomeModel alloc] init];
    model7.imgIcon = @"icon_set_help";
    model7.title = @"操作指南";
    model7.blockOperation = ^{
        [weekSelf.navigationController pushViewController:[SetHelperViewController createSetHelperViewController] animated:YES];
    };
    [tempArr3 addObject:model7];
    
    _array = [NSMutableArray arrayWithObjects:tempArr0,tempArr1,tempArr2,tempArr3, nil];
   
    
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

    return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"连接设备";
    }else if (section == 1){
        return @"用户信息";
    }else if (section == 2){
       return @"管理员";
    }else if(section == 3){
        return @"系统设置";
    }
    return nil;
}
@end
