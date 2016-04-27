
//
//  SeachSongViewController.m
//  PeoPleMusic
//
//  Created by Alen on 16/4/10.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "SeachSongViewController.h"
#import "MusicPlayerCell.h"
#import "RecordCell.h"
#import "AbsListModel.h"
#import "MusicPlayView.h"
#import "NSString+Easy.h"

#define KMusicRecordSong  @"KMusicRecordSong"

@interface SeachSongViewController ()<UISearchBarDelegate,KyoRefreshControlDelegate>{
    NSString *currentSearchString;
    NSInteger currentNumb;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *aboveTableView;

@property (strong, nonatomic) IBOutlet UIView *footView;
- (IBAction)deleteRecodeClicked:(id)sender; // 删除历史纪录
@property (nonatomic, strong) KyoRefreshControl *kyoRefreshControl;

@property (nonatomic, strong) NSMutableArray *songlist;
@property (nonatomic, strong) NSMutableArray *recordArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutAboTableViewHeight;

@end

@implementation SeachSongViewController


+ (SeachSongViewController *)createSeachSongViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    SeachSongViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([SeachSongViewController class])];
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    currentNumb = 10;
    self.searchBar.delegate = self;
    [self.searchBar setSearchTextPositionAdjustment:UIOffsetMake(0, 0)];// 设置搜索框中文本框的文本偏移量
   
    self.aboveTableView.backgroundColor = [UIColor redColor];
    
    self.aboveTableView.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MusicPlayerCell class]) bundle:nil] forCellReuseIdentifier:KMusicPlayerCellIdentifier];
    
    self.kyoRefreshControl = [[KyoRefreshControl alloc] initWithScrollView:self.tableView withDelegate:self withIsCanShowNoMore:YES];
    
    NSArray *tempARR = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:KMusicRecordSong];
    self.recordArr = [NSMutableArray arrayWithArray:tempARR];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.aboveTableView.tableFooterView = [[UIView alloc] init];
    [self refreshAbTableView];
 
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] writeToDataWithFolderName:KMusicRecordSong withData:self.recordArr];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (IBAction)deleteRecodeClicked:(id)sender {
    [self.recordArr removeAllObjects];
}

- (void)refreshAbTableView{
   
    self.layoutAboTableViewHeight.constant = 44 *(self.recordArr.count + 1);
    
    [self.view setNeedsLayout];
    
    [self.aboveTableView reloadData];
    
}
#pragma mark --------------------
#pragma mark - network
- (void)requestNetwork:(NSString *)searchStr withIndex:(NSInteger)index{
    NSString *urlString = [NSString stringWithFormat:@"http://sou.kuwo.cn/ws/NSearch?key=%@&type=music&pn=%ld",[searchStr encodeToPercentEscapeString],(long)index];
   
    NSLog(@"%@",urlString);
//    http://sou.kuwo.cn/ws/NSearch?key= &type=music&pn=1
    


    
    [NetworkSessionHelp NetworkHTML:urlString completionBlock:^(NSString *htmlText, NSInteger responseStatusCode) {
        if (responseStatusCode == 200) {
            
            TFHpple *doc = [TFHpple hppleWithHTMLData:[htmlText dataUsingEncoding:NSUTF8StringEncoding]];
            NSArray *TRElements = [doc searchWithXPathQuery:@"//div[@class='list']//ul//li[@class='clearfix']"];
//            NSArray *TRElements = [doc searchWithXPathQuery:@"//div[@class='main fl']//div[@class='m_list']//ul[@id='musicList']//li[@class='clearfix']"];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (TFHppleElement *e in TRElements) {
                
                SongInforModel *model = [[SongInforModel alloc] init];
                
                NSArray *tempNumb = [e searchWithXPathQuery:@"//p[@class='number']"];  // 歌曲Id
                if(tempNumb&&tempNumb.count > 0){
                    model.number = [tempNumb[0] content];
                    model.mediaId = [[[tempNumb[0] children] objectAtIndex:0] objectForKey:@"mid"];
                }
                
                NSArray *tempm_name = [e searchWithXPathQuery:@"//p[@class='m_name']//a"]; // 歌词
                if (tempm_name&&tempm_name.count > 0) {
                    
                    TFHppleElement *e0 = tempm_name[0];
                    model.mediaName = [e0 objectForKeyedSubscript:@"title"];
                    
                    model.lyric_herf =  [e0 objectForKeyedSubscript:@"href"];
                }
                
                NSArray *tempa_name = [e searchWithXPathQuery:@"//p[@class='a_name']//a"]; // 专辑名称
                if (tempa_name&&tempa_name.count > 0) {
                    model.albumName = [tempa_name[0] objectForKeyedSubscript:@"title"];
                }
                
                NSArray *temps_name = [e searchWithXPathQuery:@"//p[@class='s_name']//a"]; // 歌手
                if (temps_name&&temps_name.count > 0) {
                     TFHppleElement *e0 = tempm_name[0];
                    model.artist = [e0 objectForKey:@"title"]; //[tempa_name[0] objectForKeyedSubscript:@"title"];
                }
                
                NSArray *templisten = [e searchWithXPathQuery:@"//p[@class='listen']//a"]; //  http://player.kuwo.cn/MUSIC/MUSIC_324244  播放连接
                if (templisten&&templisten>0) {
                    model.listen_href = [templisten[0] objectForKey:@"href"];
                }
                
                
                [tempArr addObject:model];
            }
            
            
             NSArray *TRElementPage = [doc searchWithXPathQuery:@"//form//div[@class='page']//a"];
     
            NSInteger total = 1;
            for (TFHppleElement *e in TRElementPage) {
                NSInteger numb = [[e content] integerValue];
                if (numb > total) {
                    total = numb;
                }
            }
            if (!self.songlist) {
                self.songlist = [NSMutableArray array];
            }

            if(index == 1){
                [self.songlist removeAllObjects];
                currentNumb = TRElements.count;
            }
            
//            self.kyoRefreshControl.numberOfPage = KYOLOADMORECONTROL_NUMBER_OF_PAGES(total, currentNumb);
              self.kyoRefreshControl.numberOfPage = total;
            [self.songlist addObjectsFromArray:tempArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.kyoRefreshControl kyoRefreshDoneRefreshOrLoadMore:index==1 ? YES : NO withHadData:self.songlist.count > 0 ? YES : NO withError:nil];
            });
        }
    } errorBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.kyoRefreshControl kyoRefreshDoneRefreshOrLoadMore:index==1 ? YES : NO withHadData:self.songlist.count > 0 ? YES : NO withError:error];
        });
    }];
    
}
#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.aboveTableView) {
        return self.recordArr.count;
    }else if (tableView == self.tableView){
        return self.songlist.count;
    }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.aboveTableView) {
        self.footView.frame = CGRectMake(0, 0, kWindowWidth, 44);
        return  self.footView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.aboveTableView == tableView) {
        return 44;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.aboveTableView) {
        return 44;
    }else if (tableView == self.tableView){
         return KMusicPlayerCellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if (tableView == self.aboveTableView) {
        RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
        cell.lblRecord.text = self.recordArr[indexPath.row];
        return cell;
    }else if (tableView == self.tableView){
        MusicPlayerCell  *cell = [tableView dequeueReusableCellWithIdentifier:KMusicPlayerCellIdentifier];
        cell.indexPath = indexPath;
        SongInforModel *model = self.songlist[indexPath.row];
        cell.lblM_Name.text = model.mediaName;
        cell.lblS_Name.text = model.albumName ? model.albumName : model.artist;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.tableView == tableView) {
        MusicPlayerCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        
        
        MusicPlayView *musicPlayView = [[[NSBundle mainBundle] loadNibNamed:@"MusicPlayView" owner:self options:nil] objectAtIndex:0];
        musicPlayView.type = MusiclistViewStyleNetwork;
        musicPlayView.songlist = self.songlist;
        musicPlayView.indexRow = indexPath.row;
        
        CTBaseDialogView *dialogView = [KyoUtil showDialogView:musicPlayView fromFrame:[KyoUtil relativeFrameForScreenWithView:currentCell]];
        dialogView.isNoReposeWhenBackgroundTouched = YES;
    }else if(self.aboveTableView == tableView){
        
        NSString *string = self.recordArr[indexPath.row];
        
        currentSearchString = string;
        [self.kyoRefreshControl performSelector:@selector(kyoRefreshOperation) withObject:nil afterDelay:0.2];
        
    }

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    if (self.recordArr.count > 0) {
        self.aboveTableView.hidden = NO;
    }
   
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.aboveTableView.hidden = YES;
    });
  
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    
    if (self.recordArr.count > 9) {
        [self.recordArr insertObject:[searchBar.text trim] atIndex:self.recordArr.count];
    }else{
         [self.recordArr addObject:[searchBar.text trim]];
    }
   
    [self refreshAbTableView];
  
    
    currentSearchString = [searchBar.text trim];
    [self.kyoRefreshControl performSelector:@selector(kyoRefreshOperation) withObject:nil afterDelay:0.2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
    });
}

#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate

//刷新
- (void)kyoRefreshDidTriggerRefresh:(KyoRefreshControl *)refreshControl {
      [self requestNetwork:currentSearchString withIndex:1];
}

//加载下一页
- (void)kyoRefreshLoadMore:(KyoRefreshControl *)refreshControl loadPage:(NSInteger)index {
    [self requestNetwork:currentSearchString withIndex:index + 1];
}

@end
