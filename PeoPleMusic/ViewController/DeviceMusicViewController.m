//
//  DeviceMusicViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/31.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "DeviceMusicViewController.h"
#import "LibraryMusicCell.h"

@interface DeviceMusicViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *musicList;
@end

@implementation DeviceMusicViewController

#pragma mark -------------------
#pragma mark - CycLife
+ (DeviceMusicViewController *)createDeviceMusicViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    DeviceMusicViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceMusicViewController class])];
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.title = @"音响本地";
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestNetWork];
    });
}

#pragma mark --------------------
#pragma mark - Network

- (void)requestNetWork{
    
    [[YMTCPClient share] networkSendDeviceForSongDirWithCompletionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
        KyoLog(@"%@",dict);
    }];
}
#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KLibraryMusicCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryMusicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryMusicCell"];
//    MusicCategoryModel *model = self.dataArray[indexPath.row];
//    cell.lblTitle.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MusicCategoryModel *model = self.dataArray[indexPath.row];
//    MusicCategoryViewController *listVC = [MusicCategoryViewController createMusicCategoryViewController];
//    listVC.title = model.title;
//    listVC.urlString = model.href;
//    [self.navigationController pushViewController:listVC animated:YES];
    
}
@end
