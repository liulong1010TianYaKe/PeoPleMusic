//
//  LibrayMusicViewController.m
//  PeoPleMusic
//
//  Created by long on 12/2/15.
//  Copyright © 2015 long. All rights reserved.
//

#import "LibrayMusicViewController.h"
#import "LibraryMusicHeaderView.h"
#import "LibraryMusiceCell.h"
#import "TFHpple.h"
#import "MusicCategoryModel.h"
#import "LibraryMusicListViewController.h"
#import "SDCycleScrollView.h"

#define KLIBLRAYMUCICHTML @"http://yinyue.kuwo.cn/yy/category.htm"
@interface LibrayMusicViewController ()<LibraryMusicHeaderViewDelegate,SDCycleScrollViewDelegate>


//@property (nonatomic, strong) YMScrollView *tableHeaderView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation LibrayMusicViewController

#pragma mark -------------------
#pragma mark - CycLife
+ (LibrayMusicViewController *)createLibrayMusicViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    LibrayMusicViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([LibrayMusicViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupView{
    
    self.navigationItem.titleView = nil;
    [self addAutoScrollLabelTitle:@"我的曲库"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    NSArray *imageNames = @[@"guide_one",
                            @"guide_two",
                            @"guide_three",
                            @"guide_four"
                            ];
    
    NSArray *titles = @[@"恋爱，是永远最美好的回忆",
                        @"困了累了,来一首咖啡音乐",
                        @"安静的午后,一个人在这听歌",
                        @"那些年，我们一起听过的校园音乐"
                        ];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWindowWidth, (140*667)/kWindowHeight) imageNamesGroup:imageNames];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.titlesGroup = titles;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.tableView.tableHeaderView = cycleScrollView;
}
- (void)setupData{
   
    [self networkGetMusicCateGoryData];

}



#pragma mark --------------------
#pragma mark - Settings, Gettings

#pragma mark --------------------
#pragma mark - Events

#pragma mark -------------------
#pragma mark - Methods



- (void)networkGetMusicCateGoryData{
  
    [self showLoadingHUD:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoadingHUD];
    });
    
 
    [NetworkSessionHelp NetworkHTML:KLIBLRAYMUCICHTML completionBlock:^(NSString *htmlText, NSInteger responseStatusCode) {
//        [self hideLoadingHUD];
        if (responseStatusCode == 200) {
            TFHpple *doc = [TFHpple hppleWithHTMLData:[htmlText dataUsingEncoding:NSUTF8StringEncoding]];
            NSArray *TRElements = [doc searchWithXPathQuery:@"//div[@class='sider fl']//div[@class='hotlist']"];
            NSArray *tempElements = [TRElements[0] searchWithXPathQuery:@"//li"];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (TFHppleElement *e in tempElements) {
                MusicCategoryModel *model = [[MusicCategoryModel alloc] init];
                model.title = [e.children[0] content];
                model.href = [NSString stringWithFormat:@"http://yinyue.kuwo.cn%@",[e.children[0] objectForKey:@"href"]];
                [tempArr addObject:model];
            }
            self.dataArray = [NSArray arrayWithArray:tempArr];
           
            [self.tableView reloadData];
           
        }
        
//          [self hideLoadingHUD];
    } errorBlock:^(NSError *error) {
//        [self hideLoadingHUD];
    }];
 
}

#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData
- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    LibraryMusicHeaderView *libView =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LibraryMusicHeaderView class]) owner:tableView options:nil] firstObject];
    libView.delegate = self;
    
    return libView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KLibraryMusicHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KLibraryMusiceCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryMusiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryMusiceCell"];
    MusicCategoryModel *model = self.dataArray[indexPath.row];
    cell.lblTitle.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicCategoryModel *model = self.dataArray[indexPath.row];
    LibraryMusicListViewController *listVC = [LibraryMusicListViewController createLibraryMusicListViewController];
    listVC.title = model.title;
    listVC.urlString = model.href;
    [self.navigationController pushViewController:listVC animated:YES];
    
}



#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC

@end
