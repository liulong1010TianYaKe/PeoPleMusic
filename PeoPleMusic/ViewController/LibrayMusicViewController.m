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

@interface LibrayMusicViewController ()<LibraryMusicHeaderViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)pageControlChange:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
    self.headerView.frame = CGRectMake(0, 0, kWindowWidth, 150);
    self.tableView.tableHeaderView = self.headerView;
    self.scrollView.pagingEnabled = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LibraryMusiceCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:KLibraryMusiceCellTableViewCellIdentifier];
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
