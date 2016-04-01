//
//  PlayerViewController.m
//  PeoPleMusic
//
//  Created by long on 12/2/15.
//  Copyright © 2015 long. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerCell.h"
#import "SongModel.h"
#import "UIView-WhenTappedBlocks.h"
#import "PlayListView.h"
#import "Feedbackview.h"
#import "ChaboView.h"
#import "SongDemandViewController.h"
#import "YMBonjourHelp.h"
#import "YMTCPClient.h"

#define KTopViewHeight  (210*kWindowHeight/667)

@interface PlayerViewController ()<UITableViewDataSource,UITableViewDelegate,PlayerCellDelegate>{
    SongModel *_oldModel;
    double   angle;
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>topView
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSongNumb;
@property (weak, nonatomic) IBOutlet UILabel *lblSongInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgSong;

@property (nonatomic, strong) NSLayoutConstraint *layoutTopViewHeight;
@property (nonatomic, strong) SongInforModel *currentSongInfo;

@property (nonatomic, strong)  SongInfoList *songList;
- (IBAction)showSongListClicked:(id)sender;

// >>>>>>>>>>>>>>>>>>>>>>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//>>>>>>>>>>>>>>>>>
@property (weak, nonatomic) IBOutlet UIButton *btnStartPlay;  //开始点播
@property (weak, nonatomic) IBOutlet UILabel *lblNoStartPlay;  // 暂时没有点播信息～

@property (nonatomic, strong) NSArray *songModels;

@property (nonatomic, strong) FeedBackView *feedBackView;

@property (nonatomic, strong) ChaboView *chaoboView;

@property (nonatomic, strong) PlayListView *playListView;
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
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
    
    if ([YMTCPClient share].isConnect) {
//        [[YMTCPClient share] sendCmdForPlaySongInfo]; // 获取当前播放歌曲信息
    }
}

- (void)setupView{

    
    
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
    
}

- (void)setupData{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCurrentSongInfo:) name:YNotificationName_GET_PLAY_SONGINFO_FEEDBACK object:nil];  //获取音响当前正在播放的歌曲信息
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSonglist:) name:YNotificationName_GET_SONG_LIST_FEEDBACK object:nil];   //获取点播列表反馈
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        SongModel *songModel = [[SongModel alloc] init];
        [tempArr addObject:songModel];
    }
    _songModels = tempArr;
    
    self.currentSongInfo = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO_FEEDBACK];
}
-(void) startAnimation
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
#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    cell.indexPath = indexPath;
    cell.delegate = self;
//    cell.model = _songModels[indexPath.row];
    
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    cell.textLabel.text = @"ads";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [PlayerCell getPlayCellHeight:_songModels[indexPath.row]];
    return 98;
}

#pragma mark -------------------
#pragma mark -- PlayerCellDelegate
- (void)playerCellTouchInside:(PlayerCell *)cell withModel:(SongModel *)model{
    _oldModel.isExpect = NO;
     model.isExpect = YES;
    _oldModel = model;
    [self.tableView reloadData];
    
}

- (void)playerCellTouchInside:(PlayerCell *)cell withBtnType:(PlayerCellBtnTypes)type{
    switch (type) {

        case PlayerCellBtnTypeDetail:{
            SongDemandViewController *VC = [SongDemandViewController createSongDemandViewController];
            VC.title = @"我的点播";
            [self.navigationController pushViewController:VC animated:YES];
          
            break;
        }
        case PlayerCellBtnTypeDelete:
            break;
        case PlayerCellBtnTypeMsg:
           self.feedBackView = [FeedBackView createFeedBackViewFromWindow] ;
            [self.feedBackView show];
            break;
        case PlayerCellBtnTypeChabo:
            if (!self.chaoboView) {
                self.chaoboView = [ChaboView createChaboViewFromWindow];
            }
            
            [self.chaoboView show];
            break;
            
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
#pragma mark --------------------
#pragma mark - NSNotification

//获取音响当前正在播放的歌曲信息
- (void)receiveCurrentSongInfo:(NSNotification *)noti{
    self.currentSongInfo = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_GET_PLAY_SONGINFO_FEEDBACK];
}

//获取点播列表反馈
- (void)receiveSonglist:(NSNotification *)noti{
    self.songList = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_GET_SONG_LIST_FEEDBACK];
}
//// 播放
- (IBAction)btnPlayTouchInside:(id)sender {
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
    [self.playListView show];
  
}

- (void)reshowPlayListView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self btnSongListTouchInside:nil];
    });
   
}


- (IBAction)showSongListClicked:(id)sender {
}
@end
