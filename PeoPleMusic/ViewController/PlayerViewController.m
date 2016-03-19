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

@interface PlayerViewController ()<UITableViewDataSource,UITableViewDelegate,PlayerCellDelegate>{
    SongModel *_oldModel;
}
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
- (IBAction)btnPlayTouchInside:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblLyrics;
@property (weak, nonatomic) IBOutlet UILabel *lblSongNumb;
- (IBAction)btnSongListTouchInside:(id)sender;

@property (nonatomic, strong) NSArray *songModels;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;

@property (nonatomic, strong) FeedBackView *feedBackView;

@property (nonatomic, strong) ChaboView *chaoboView;
@end

@implementation PlayerViewController

#pragma mark -- Life

+ (PlayerViewController *)createPlayerViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Player" bundle:nil];
    PlayerViewController  *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([PlayerViewController class])];
    return controller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.lblLyrics.textColor = YYColor(244, 151, 24);
//    self.imgBg.image = nil;
//    self.tableHeaderView.backgroundColor = [UIColor clearColor];

    self.tableView.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_song_header"]];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10);
    self.tableView.tableFooterView = [[UIView alloc] init];
   
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
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    __weak typeof(self)weekSelf = self;
    [self.imgBg whenDoubleTapped:^{
        if (_oldModel.isExpect) {
            _oldModel.isExpect = NO;
            [weekSelf.tableView reloadData];
        }
    }];
}

- (void)setupData{
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        SongModel *songModel = [[SongModel alloc] init];
        [tempArr addObject:songModel];
    }
    _songModels = tempArr;
}
#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:KPlayerCellIdentifier];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.model = _songModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PlayerCell getPlayCellHeight:_songModels[indexPath.row]];
}

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

// 播放
- (IBAction)btnPlayTouchInside:(id)sender {
}

- (IBAction)btnSongListTouchInside:(id)sender {
    

    [[PlayListView createPlayListViewFromWindow] show];
  
}

- (void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
//    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    self.currentKeyBoradRect = keyboardRect;
    CGRect kyRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    KyoLog(@"%@",NSStringFromCGRect(self.currentKeyBoradRect));
    if (self.feedBackView && self.feedBackView.frame.origin.x == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.feedBackView.frame = CGRectMake(0, -kyRect.size.height   , kWindowWidth, kWindowHeight);
        }];
    }
    
    if (self.chaoboView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.chaoboView.frame = CGRectMake(0, -kyRect.size.height   , kWindowWidth, kWindowHeight);
        }];
    }

}
- (void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
}
@end
