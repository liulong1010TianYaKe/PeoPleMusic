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
    self.dataArray = @[@"轻音乐",@"小清新",@"网络"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    LibraryMusicHeaderView *headerView =
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
    cell.lblTitle.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pageControlChange:(id)sender {
    
}


@end
