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
    return _songModels.count;
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
    
}

// 播放
- (IBAction)btnPlayTouchInside:(id)sender {
}

- (IBAction)btnSongListTouchInside:(id)sender {
    
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    view.frame = CGRectMake(0, kWindowHeight - 100, kWindowWidth, 100);
//    
//    CTBaseDialogView *baseView = [[CTBaseDialogView alloc] initWithSubView:view animation:CTAnimationTypeDownToUp fromFrame:self.view.frame];
//    baseView.isNoNeedCloseBtn = YES;
//    baseView.bodyView = view;
//    [baseView show];
    [[PlayListView createPlayListViewFromWindow] show];
  
}
@end
