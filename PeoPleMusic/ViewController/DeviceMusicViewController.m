//
//  DeviceMusicViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/31.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "DeviceMusicViewController.h"
#import "LibraryMusicCell.h"
#import "MusicListViewController.h"

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
    
    [self networkGetSongList];
}

#pragma mark --------------------
#pragma mark - Network

- (void)networkGetSongList{
    
    

     NSString *urlString = [NSString stringWithFormat:@"http://115.28.191.217:8080/vodbox/mobinf/terminalAction!getNearbyTerminal.do?terminalId=%ld",(long)[UserInfo sharedUserInfo].deviceVodBoxModel.code];
    [NetworkSessionHelp postNetwork:urlString completionBlock:^(NSDictionary *dict, NSInteger result) {

    } errorBlock:^(NSError *error) {
        
    } finishedBlock:^(NSError *error) {
        
 
        
    }];
}

- (void)requestNetWork{
    
    [[YMTCPClient share] networkSendDeviceForSongDir:^(NSInteger result, NSDictionary *dict, NSError *err) {
//        KyoLog(@"%@",dict);
        if (result == 0) {
            NSArray *arr = [KyoUtil changeJsonStringToArray:dict[@"musicList"]];
            if (arr) {
                self.musicList = [SongInforModel objectArrayWithKeyValuesArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
    }];
}
#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KLibraryMusicCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryMusicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryMusicCell"];
    SongInforModel *model = self.musicList[indexPath.row];
    cell.lblTitle.text = model.mediaName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SongInforModel *model = self.musicList[indexPath.row];
    MusicListViewController *musicPlayerVC = [MusicListViewController createMusicListViewController];
    musicPlayerVC.style = MusiclistViewStyleDeviceLoc;
    musicPlayerVC.title = model.mediaName;
    musicPlayerVC.requestKey = model.mediaUrl;
    musicPlayerVC.tatolSize = model.childCount;
    [self.navigationController pushViewController:musicPlayerVC animated:YES];
    
}
@end
