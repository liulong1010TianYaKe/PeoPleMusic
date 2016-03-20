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
#import "PlayDetailViewController.h"
#import "YMBonjourHelp.h"
#import "YMSocketHelper.h"


@interface PlayerViewController ()<UITableViewDataSource,UITableViewDelegate,PlayerCellDelegate>{
    SongModel *_oldModel;
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>topView
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSongNumb;
@property (weak, nonatomic) IBOutlet UILabel *lblSongInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgSong;

- (IBAction)showSongListClicked:(id)sender;

// >>>>>>>>>>>>>>>>>>>>>>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//>>>>>>>>>>>>>>>>>
@property (weak, nonatomic) IBOutlet UIButton *btnStartPlay;  //开始点播
@property (weak, nonatomic) IBOutlet UILabel *lblNoStartPlay;  // 暂时没有点播信息～

@property (nonatomic, strong) NSArray *songModels;

@property (nonatomic, strong) FeedBackView *feedBackView;

@property (nonatomic, strong) ChaboView *chaoboView;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([YMBonjourHelp shareInstance].isAirSuccess) {
            NSString *ips =  [YMBonjourHelp shareInstance].deviceIp;
            NSLog(@"%@  %ld", [YMBonjourHelp shareInstance].deviceIp,[YMBonjourHelp shareInstance].port);
            [[YMSocketHelper share] connectServer:ips port:SOCKET_PORT2];
        }
        
        
    });
   
 
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupView{

    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.btnStartPlay.layer.cornerRadius = 4;
    self.btnStartPlay.layer.borderWidth = 1;
    self.btnStartPlay.layer.borderColor = [UIColor redColor].CGColor;
    self.btnStartPlay.layer.masksToBounds = YES;
    
}

- (void)setupData{
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        SongModel *songModel = [[SongModel alloc] init];
        [tempArr addObject:songModel];
    }
    _songModels = tempArr;
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
            PlayDetailViewController *VC = [PlayDetailViewController createViewController];
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
            self.chaoboView = [ChaboView createChaboViewFromWindow];
            [self.chaoboView show];
            break;
            
        default:
            break;
    }
}

//// 播放
//- (IBAction)btnPlayTouchInside:(id)sender {
//}
//
//- (IBAction)btnSongListTouchInside:(id)sender {
//    
//
//    [[PlayListView createPlayListViewFromWindow] show];
//  
//}

//- (void)keyboardWillShow:(NSNotification *)notification{
//    [super keyboardWillShow:notification];
////    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
////    self.currentKeyBoradRect = keyboardRect;
//    CGRect kyRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    KyoLog(@"%@",NSStringFromCGRect(self.currentKeyBoradRect));
//    if (self.feedBackView && self.feedBackView.frame.origin.x == 0) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.feedBackView.frame = CGRectMake(0, -kyRect.size.height   , kWindowWidth, kWindowHeight);
//        }];
//    }
//    
//    if (self.chaoboView) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.chaoboView.frame = CGRectMake(0, -kyRect.size.height   , kWindowWidth, kWindowHeight);
//        }];
//    }
//
//}
//- (void)keyboardWillHide:(NSNotification *)notification{
//    [super keyboardWillHide:notification];
//}
- (IBAction)showSongListClicked:(id)sender {
}
@end
