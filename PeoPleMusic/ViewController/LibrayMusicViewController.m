//
//  LibrayMusicViewController.m
//  PeoPleMusic
//
//  Created by long on 12/2/15.
//  Copyright © 2015 long. All rights reserved.
//

#import "LibrayMusicViewController.h"
#import "LibraryMusicHeaderView.h"
#import "LibraryMusiceCellTableViewCell.h"
#import "TFHpple.h"
#import "MusicCategoryModel.h"
#import "LibraryMusicListViewController.h"
#import "SDCycleScrollView.h"

@interface LibrayMusicViewController ()<LibraryMusicHeaderViewDelegate,SDCycleScrollViewDelegate>


//@property (nonatomic, strong) YMScrollView *tableHeaderView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation LibrayMusicViewController

+ (LibrayMusicViewController *)createLibrayMusicViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    LibrayMusicViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([LibrayMusicViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = nil;
    [self addAutoScrollLabelTitle:@"我的曲库"];
    self.tableView.bounds = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
//    self.headerView.frame = CGRectMake(0, 0, kWindowWidth, 150);
//    self.tableView.tableHeaderView = self.headerView;

    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LibraryMusiceCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:KLibraryMusiceCellTableViewCellIdentifier];
    


}

- (void)setupView{
    
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
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWindowWidth, 135) imageNamesGroup:imageNames];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.titlesGroup = titles;
    self.tableView.tableHeaderView = cycleScrollView;
}
- (void)setupData{
   
    self.dataArray = [self getMusicCategoryModels];

}
#pragma mark -- 

// 获取酷我音乐类别
- (NSArray *)getMusicCategoryModels{
    NSString *contentHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://yinyue.kuwo.cn/yy/category.htm"] encoding:NSUTF8StringEncoding error:nil];
    TFHpple *doc = [TFHpple hppleWithHTMLData:[contentHtml dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSArray *TRElements = [doc searchWithXPathQuery:@"//div[@class='sider fl']//div[@class='hotlist']"];
    NSArray *tempElements = [TRElements[0] searchWithXPathQuery:@"//li"];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (TFHppleElement *e in tempElements) {
        MusicCategoryModel *model = [[MusicCategoryModel alloc] init];
        model.title = [e.children[0] content];
        model.href = [NSString stringWithFormat:@"http://yinyue.kuwo.cn%@",[e.children[0] objectForKey:@"href"]];
        [tempArr addObject:model];
    }
    
    return tempArr;
}
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

  LibraryMusicHeaderView *libView =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LibraryMusicHeaderView class]) owner:tableView options:nil] firstObject];
    libView.delegate = self;
    
    return libView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KLibraryMusicHeaderViewHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KLibraryMusiceCellTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryMusiceCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KLibraryMusiceCellTableViewCellIdentifier];
    cell.model = self.dataArray[indexPath.row];
    
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


- (IBAction)pageControlChange:(id)sender {
    
    
}



@end
