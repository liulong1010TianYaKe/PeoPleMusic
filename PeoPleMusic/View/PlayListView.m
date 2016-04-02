//
//  PlayListView.m
//  PeoPleMusic
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "PlayListView.h"
#import "PlayListCell.h"
#import "SongDemandViewController.h"


@interface PlayListView ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSInteger  deleteRow;
}
- (IBAction)btnTopTouchInside:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)btnCancelTouchInside:(id)sender;
@end
@implementation PlayListView


- (void)awakeFromNib{
    [super awakeFromNib];

    
   
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PlayListCell class]) bundle:nil] forCellReuseIdentifier:KPlayListCellIdentify];
   
    
}
+ (instancetype)createPlayListViewFromWindow{
    
    PlayListView *playListView = [[[NSBundle mainBundle] loadNibNamed:@"PlayListView" owner:self options:nil] firstObject];
    
    
    return playListView;
}


- (void)show{
    
    if (self == nil) {
        return;
    }
    self.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight);
    
    self.layoutBottViewHeight.constant = 60 +40+ 44*self.songList.count;
//    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    [self setNeedsLayout];
//    [[KyoUtil getRootViewController].view addSubview:self];
    [[KyoUtil getRootViewController].view addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    }];
    
    
}

- (void)close{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (IBAction)btnCancelTouchInside:(id)sender {
    
    [self close];
}


- (void)deleteSongWithIndexPath:(NSIndexPath *)indexPath{
    deleteRow = indexPath.row;
    SongInforModel *model = _songList[indexPath.row];
    
    [[[UIAlertView alloc] initWithTitle:nil message:model.mediaName delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:KPlayListCellIdentify];
    cell.indexPath = indexPath;
    cell.model = self.songList[indexPath.row];
    __weak typeof(self)weekSelf = self;
    cell.CancelOperationBlock = ^(NSIndexPath *index){
        [weekSelf deleteSongWithIndexPath:index];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KPlayListCelllHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    [self close];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SongDemandViewController *songVC = [SongDemandViewController createSongDemandViewController];
        songVC.title = @"歌曲点播";
        __weak typeof(self) weakSelf = self;
        songVC.btnBackBlockOperation = ^{
            if (weakSelf.reShowBlockOperation) {
                weakSelf.reShowBlockOperation();
            }
        };
        //    songVC.songInfoModel = self.songlist[self.indexRow];
        [[KyoUtil getCurrentNavigationViewController] pushViewController:songVC animated:YES];
    });
  
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.songList removeObjectAtIndex:deleteRow];
        if (self.songList.count > 0) {
            [self.tableView reloadData];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self close];
            });
        }
    }
}
- (IBAction)btnTopTouchInside:(id)sender {
    [self close];
}
@end
