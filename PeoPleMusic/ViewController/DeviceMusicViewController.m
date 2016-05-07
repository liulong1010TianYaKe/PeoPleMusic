//
//  DeviceMusicViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/31.
//  Copyright © 2016年 zhuniT All rights reserved.
//

#import "DeviceMusicViewController.h"
#import "LibraryMusicCell.h"
#import "MusicListViewController.h"

@interface DeviceMusicViewController ()<KyoRefreshControlDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *musicList;

@property (nonatomic,strong) KyoRefreshControl *kyoRefreshControl;

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
    
    self.kyoRefreshControl  = [[KyoRefreshControl alloc] initWithScrollView:self.tableView withDelegate:self withIsCanShowNoMore:NO];
}

- (void)setupData{
    
    
    [self.kyoRefreshControl performSelector:@selector(kyoRefreshOperation) withObject:nil afterDelay:0.2f];
    
    
}

#pragma mark --------------------
#pragma mark - Network



- (void)requestNetWork{
    
    [[YMTCPClient share] networkSendDeviceForSongDir:^(NSInteger result, NSDictionary *dict, NSError *err) {
        
        dispatch_main_async_safeThread(^{
            
            if (result == 0) {
                NSArray *arr = [KyoUtil changeJsonStringToArray:dict[@"musicList"]];
                if (arr) {
                    
                    self.musicList = [SongInforModel objectArrayWithKeyValuesArray:arr];
        
                    [self.tableView reloadData];
                    
                   
                }
            }
            
            [self.kyoRefreshControl kyoRefreshDoneRefreshOrLoadMore:YES withHadData:self.musicList &&self.musicList.count > 0 ? YES : NO withError:err];
        })
     
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

#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate
- (void)kyoRefreshDidTriggerRefresh:(KyoRefreshControl *)refreshControl{
    [self requestNetWork];
}
- (void)kyoRefreshLoadMore:(KyoRefreshControl *)refreshControl loadPage:(NSInteger)index{
    
}
@end
