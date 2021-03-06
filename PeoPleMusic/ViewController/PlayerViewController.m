//
//  PlayerViewController.m
//  PeoPleMusic
//
//  Created by long on 12/2/15.
//  Copyright © 2015 zhuniT All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerCell.h"

#import "UIView-WhenTappedBlocks.h"
#import "PlayListView.h"
#import "Feedbackview.h"
#import "ChaboView.h"
#import "SongDemandViewController.h"
#import "YMBonjourHelp.h"
#import "YMTCPClient.h"
#import "AutoScrollTextView.h"
#import "SearchDeviceViewController.h"

#define KTopViewHeight  (210*kWindowHeight/667)

@interface PlayerViewController ()<UITableViewDataSource,UITableViewDelegate,PlayerCellDelegate,UIAlertViewDelegate>{
    double   angle;
    SongInforModel *deleteSongInfo;
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>topView
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSongNumb;
@property (weak, nonatomic) IBOutlet UILabel *lblSongInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgSong;

@property (nonatomic, strong) NSLayoutConstraint *layoutTopViewHeight;
@property (nonatomic, strong)  SongInforModel *currentSongInfo;

@property (nonatomic, strong)  NSMutableArray *songList;

@property (weak, nonatomic) IBOutlet AutoScrollTextView *autoTextView;

// >>>>>>>>>>>>>>>>>>>>>>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//>>>>>>>>>>>>>>>>>
@property (weak, nonatomic) IBOutlet UIButton *btnStartPlay;  //开始点播
@property (weak, nonatomic) IBOutlet UILabel *lblNoStartPlay;  // 暂时没有点播信息～
- (IBAction)btnStartPlaying:(id)sender;

@property (nonatomic, strong) NSArray *songModels;

@property (nonatomic, strong) FeedBackView *feedBackView;

@property (nonatomic, strong) ChaboView *chaoboView;

@property (nonatomic, strong) PlayListView *playListView;

@property (nonatomic, strong) UIButton *linkServerBtn;
@end

@implementation PlayerViewController

#pragma mark -------------------
#pragma mark - CycLife

+ (PlayerViewController *)createPlayerViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Player" bundle:nil];
    PlayerViewController  *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([PlayerViewController class])];
    return controller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([YMTCPClient share].isConnect) {
//        self.linkServerBtn.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestCurrentSong];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestGetSonglist];
        });
    }else{
//        self.lblTitle.text = @"设备未连接";
//        self.btnStartPlay.hidden = YES;
//        self.lblNoStartPlay.hidden = YES;
//        self.lblTitle.text = @"设备未连接";
////        self.linkServerBtn.hidden = NO;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if([KyoUtil rootViewController].currentNetworkState != AFNetworkReachabilityStatusReachableViaWiFi){
//                
//                [self showMessageHUD:@"亲，你还未连接店内WIFI哦～" withTimeInterval:kShowMessageTime];
//                
//            }}
//                       
//            );
    }
  
  

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resetfreshSubViews];
    });

}
- (void)resetfreshSubViews{
    if ([YMTCPClient share].isConnect) {
        self.linkServerBtn.hidden = YES;
    }else{
        self.btnStartPlay.hidden = YES;
        self.lblNoStartPlay.hidden = YES;
        self.lblTitle.text = @"设备未连接";
        self.linkServerBtn.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([KyoUtil rootViewController].currentNetworkState != AFNetworkReachabilityStatusReachableViaWiFi){
                
                [self showMessageHUD:@"亲，你还未连接店内WIFI哦～" withTimeInterval:kShowMessageTime];
                
            }}
                       
        );
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupView{
    self.imgSong.layer.cornerRadius = self.imgSong.bounds.size.height/2;
    
    self.imgSong.layer.borderColor = [UIColor colorWithWhite:255 alpha:0.8].CGColor;
    self.imgSong.layer.borderWidth = 1;
    self.imgSong.layer.masksToBounds = YES;
    [self.view addSubview:self.topView];
     self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subView]-0-|" options:0 metrics:nil views:@{@"subView" : self.topView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subView]" options:0 metrics:nil views:@{@"subView" : self.topView}]];
    
    self.layoutTopViewHeight = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.topView addConstraint:self.layoutTopViewHeight];
    
    
    self.btnStartPlay.layer.cornerRadius = 4;
    self.btnStartPlay.layer.borderWidth = 1;
    self.btnStartPlay.layer.borderColor = [UIColor redColor].CGColor;
    self.btnStartPlay.layer.masksToBounds = YES;
    self.btnStartPlay.hidden = YES;
    self.lblNoStartPlay.hidden = YES;
    self.layoutTopViewHeight.constant = KTopViewHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(KTopViewHeight, 0, 0, 0);
    [self.view setNeedsLayout];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self startAnimation];
    self.autoTextView.userInteractionEnabled = NO;
    self.autoTextView.text = @"  点一首我们最爱的歌,回忆我们美好的曾经,人人点歌,播放你的心声";
    [self.autoTextView startAutoScroll];
    
    self.linkServerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.linkServerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.linkServerBtn.layer.cornerRadius = 5;
    self.linkServerBtn.layer.borderWidth = 1;
    self.linkServerBtn.layer.borderColor = kNavBarBGColor.CGColor;

    [self.linkServerBtn setTitle:@"点击添加设备" forState:UIControlStateNormal];
    [self.linkServerBtn setTitleColor:YYColor(224, 103, 17) forState:UIControlStateNormal];
    [self.linkServerBtn setBackgroundImage:[UIImage imageNamed:@"button_0_0_0_2"] forState:UIControlStateHighlighted];
    [self.linkServerBtn addTarget:self action:@selector(linkServerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
     self.linkServerBtn.frame = CGRectMake((kWindowWidth-150)/2, kWindowHeight/2, 150, 44);
    self.linkServerBtn.hidden = YES;
    
    [self.view addSubview:self.linkServerBtn];
    
    

    
}

- (void)setupData{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveupdataCmd:) name:YNotificationName_UPDATE_BRAODCAST object:nil];  //获取音响当前正在播放的歌曲信息
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDidConnect:) name:YNotificationName_SOCKETDIDCONNECT object:nil];  //连接上服务器
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveuDisConnect:) name:YNotificationName_SOCKETDIDDISCONNECT object:nil];  //断开连接
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDeviceInfo:) name:YNotificationName_CMDTYPE_REGISTERED_FEEDBACK object:nil];
    
    DeviceInfor *deviceInfo = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK];
    self.lblTitle.text = deviceInfo.name;
   
 
}


-(void)startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.imgSong.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}
-(void)endAnimation
{
    angle += 1;
    [self startAnimation];
}

#pragma mark -------------------
#pragma mark - Event
- (void)linkServerBtnAction:(UIButton  *)btn{
    SearchDeviceViewController *searchVC = [SearchDeviceViewController createSearchDeviceViewController];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark -------------------
#pragma mark - NetWork
//发送获取当前正在播放的歌曲信息
- (void)requestCurrentSong{
    
    [[YMTCPClient share] networkSendCmdForPlaySongInfor:^(NSInteger result, NSDictionary *dict, NSError *err) {
//        KyoLog(@"%@",dict);
        if (result == 0) {
            NSDictionary *songInfoDict = [dict objectForKey:@"songInfor"];
            self.currentSongInfo = [SongInforModel objectWithKeyValues:songInfoDict];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.lblSongInfo.text = self.currentSongInfo.mediaName;
                
                if(![self.currentSongInfo.playMsg isEqualToString:@""]){
                  self.autoTextView.text = self.currentSongInfo.playMsg;
                }else{
                  self.autoTextView.text = @"  点一首我们最爱的歌,回忆我们美好的曾经,人人点歌,播放你的心声";
                }
            });
           
            
        }else{
           
           
        }
    }];
}

- (void)requestGetSonglist{
    [[YMTCPClient share] networkSendBookingSongListWithPageNum:0 withPageSize:100 completionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
//         KyoLog(@"%@",dict);
        if (result == 0) {
            NSArray *arr = [KyoUtil changeJsonStringToArray:dict[@"songList"]];
            if (arr) {
                NSArray *tempArr = [SongInforModel objectArrayWithKeyValuesArray:arr];
                self.songList = [NSMutableArray arrayWithArray:tempArr];
                
                for (SongInforModel *model in self.songList) {
                    if ([model.userInfor.userId isEqualToString:[UIDevice getUUID]]){
                        model.isExtend = YES;
                    }
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    self.lblSongNumb.text = [NSString stringWithFormat:@"总共: %lu",(unsigned long)self.songList.count];
                    if (self.songList.count == 0) {
                        self.btnStartPlay.hidden = NO;
                        self.lblNoStartPlay.hidden = NO;
                    }else{
                        self.btnStartPlay.hidden = YES;
                        self.lblNoStartPlay.hidden = YES;
                        
                    }
                    
                });
            }
        }
       
       
    }];
}

- (void)requestNetworkwithPlayStye:(MusicSongPlayStyle)style withSongInfo:(SongInforModel *)songInfoModel withMessage:(NSString *)message  withView:(UIView *)view{
  
    [self showLoadingHUD:nil];
    [[YMTCPClient share] networkSendBookSongInfo:songInfoModel withPlayType:style completionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
        
        if (result == 0) { // 点播成功
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideLoadingHUD];
                [self showMessageHUD:[NSString stringWithFormat:@"%@成功!",message] withTimeInterval:kShowMessageTime];
                if (self.feedBackView == view){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.feedBackView close];
                    });
                
                }else if(self.chaoboView == view){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.chaoboView close];
                    });
                }
            });
            
            
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideLoadingHUD];
                [self showMessageHUD:[NSString stringWithFormat:@"%@!失败",message] withTimeInterval:kShowMessageTime];
                if (self.feedBackView == view){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.feedBackView close];
                    });
                    
                }else if(self.chaoboView == view){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.chaoboView close];
                    });
                }
            });
        }
    }];
    
}

#pragma mark -------------------
#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.model = self.songList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SongInforModel *model = self.songList[indexPath.row];
    if ([model.userInfor.userId isEqualToString:[UIDevice getUUID]]) {
        return model.isExtend ? KPlayerCellHeight + 38 : KPlayerCellHeight;
    }
    return KPlayerCellHeight;
}

#pragma mark -------------------
#pragma mark -- PlayerCellDelegate
- (void)playerCellTouchInside:(PlayerCell *)cell withModel:(SongInforModel *)model{
//     _currentSongInfo.isExtend = !_currentSongInfo.isExtend;
    model.isExtend = !model.isExtend;
    self.songList[cell.indexPath.row] = model;

    [self.tableView reloadData];
    
}

- (void)playerCellTouchInside:(PlayerCell *)cell withBtnType:(PlayerCellBtnTypes)type{
     __weak typeof(self) weakSelf = self;
    switch (type) {

        case PlayerCellBtnTypeDetail:{
            SongDemandViewController *VC = [SongDemandViewController createSongDemandViewController];
            VC.songInfoModel = cell.model;
            VC.playStyle = MusicSongPlayStyleUpdate;
            VC.title = @"歌曲详细";
            
            [self.navigationController pushViewController:VC animated:YES];
        
            break;
        }
        case PlayerCellBtnTypeDelete:{
            NSString *message = [NSString stringWithFormat:@"是否删除-%@?",cell.model.mediaName];
            deleteSongInfo = cell.model;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除歌曲" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag =  1000;
            [alertView show];
            break;
        }
        case PlayerCellBtnTypeMsg:{
           
           self.feedBackView = [FeedBackView createFeedBackViewFromWindow] ;
           
            self.feedBackView.btnSubmitBlockOperation = ^{
                [weakSelf requestNetworkwithPlayStye:MusicSongPlayStyleUpdate withSongInfo:cell.model withMessage:@"更新留言" withView:weakSelf.feedBackView];
            };
            [self.feedBackView show];
        }
            break;
        case PlayerCellBtnTypeChabo:{
            if (!self.chaoboView) {
                self.chaoboView = [ChaboView createChaboViewFromWindow];
            }
            self.chaoboView.btnSubmitBlockOperation= ^{
                [weakSelf requestNetworkwithPlayStye:MusicSongPlayStyleUpdate withSongInfo:cell.model withMessage:@"插播" withView:weakSelf.chaoboView];
            };
            
            [self.chaoboView show];
            break;
        }
            
        default:
            break;
    }
}
- (void)creatFeedBackViewAndShow{
    
    if (!self) {
        self.feedBackView = [FeedBackView createFeedBackViewFromWindow];
    }
}
#pragma mark --------------------
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.layoutTopViewHeight.constant = -scrollView.contentOffset.y;
}


- (IBAction)btnSongListTouchInside:(id)sender {

    if (!self.playListView) {
        self.playListView = [PlayListView createPlayListViewFromWindow];
        __weak typeof(self) weakSelf = self;
        self.playListView.reShowBlockOperation = ^{
            weakSelf.playListView = nil;
          
                [weakSelf reshowPlayListView];
        
        };
    }
    NSArray *teamArr = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_BOOK_PLAYING_SONG];
    
  
    if (teamArr.count > 0) {
          self.playListView.songList = [NSMutableArray arrayWithArray:teamArr];
        [self.playListView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"亲，未有点播点播纪录～" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去点播", nil];
        alertView.tag = 2000;
        [alertView show];
    }

  
}

- (void)reshowPlayListView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self btnSongListTouchInside:nil];
    });
   
}
#pragma mark --------------------
#pragma mark - NSNotification

//获取音响当前正在播放的歌曲信息
- (void)receiveupdataCmd:(NSNotification *)noti{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestCurrentSong];
       
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self requestGetSonglist];
    });
}
//连接上音响
- (void)receiveDidConnect:(NSNotification *)noti{
     self.linkServerBtn.hidden = YES;
//    [self resetfreshSubViews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestCurrentSong];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestGetSonglist];
    });
    
   
}
//音响断开连接
- (void)receiveuDisConnect:(NSNotification *)noti{
    self.currentSongInfo = nil;
    [self.tableView reloadData];

//    [self resetfreshSubViews];
    self.btnStartPlay.hidden = YES;
    self.lblNoStartPlay.hidden = YES;
    self.lblTitle.text = @"设备未连接";
    self.linkServerBtn.hidden = NO;
    [KyoUtil showMessageHUD:@"音响断开了连接" withTimeInterval:kShowMessageTime inView:self.view];
}

- (void)receiveDeviceInfo:(NSNotification *)noti{
    
    DeviceInfor *deviceInfo = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK];
    
    self.lblTitle.text = deviceInfo.name;
    
//    [self resetfreshSubViews];
    self.linkServerBtn.hidden = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 1000) {
            [self  showLoadingHUD:@"删除歌曲"];
            [[YMTCPClient share] networkSendDeleteSongInfo:deleteSongInfo completionBlock:^(NSInteger result, NSDictionary *dict, NSError *err) {
                if(result == 0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self  hideLoadingHUD];
                        [self  showMessageHUD:@"删除歌曲成功!" withTimeInterval:kShowMessageTime];
                        [self requestGetSonglist];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self  hideLoadingHUD];
                        [self  showMessageHUD:@"删除歌曲失败!" withTimeInterval:kShowMessageTime];
                    });
                }
               
            }];
        }else if(alertView.tag == 2000){
//            [KyoUtil rootViewController].tabBarViewController.selectedIndex = 0;
            [[KyoUtil rootViewController] gotoLibrayMusicViewController];
        }

    }
}
- (IBAction)btnStartPlaying:(id)sender {
    [[KyoUtil rootViewController] gotoLibrayMusicViewController];
}
@end
