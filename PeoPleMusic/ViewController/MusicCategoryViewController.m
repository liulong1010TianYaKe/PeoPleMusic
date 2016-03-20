//
//  LibraryMusicListViewController.m
//  PeoPleMusic
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "MusicCategoryViewController.h"
#import "MusicCategoryModel.h"
#import "TFHpple.h"
#import "MusicCategoryCell.h"
#import "MusicListViewController.h"
#import "UIImageView+WebCache.h"

@interface MusicCategoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation MusicCategoryViewController

#pragma mark -------------------
#pragma mark - CycLife

+ (MusicCategoryViewController *)createMusicCategoryViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    MusicCategoryViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MusicCategoryViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setupView{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = kTableViewbackgroundColor;
}

- (void)setupData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self networkGetMusicData];
    });
}

#pragma mark -------------------
#pragma mark - Network 

- (void)networkGetMusicData{
    
    [self showLoadingHUD:nil];
    [NetworkSessionHelp NetworkHTML:self.urlString completionBlock:^(NSString *htmlText, NSInteger responseStatusCode) {
        
        if (responseStatusCode == 200) {
            TFHpple *doc = [TFHpple hppleWithHTMLData:[htmlText dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSArray *TRElements = [doc searchWithXPathQuery:@"//div[@class='main fl']//ul[@class='singer_list clearfix']//li"];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (TFHppleElement *e in TRElements) {
                MusicCategoryModel *model = [[MusicCategoryModel alloc] init];
                
                model.number = [[e firstChildWithTagName:@"p"] content];
                TFHppleElement *temp1 = [e firstChildWithTagName:@"a"];
                model.href = [NSString stringWithFormat:@"http://yinyue.kuwo.cn%@",[temp1 objectForKey:@"href"]];
                model.title = [temp1 objectForKey:@"title"];
                model.image = [temp1.children[0] objectForKey:@"lazy_src"];
                [tempArr addObject:model];
            }
            self.dataSource = [NSArray arrayWithArray:tempArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self hideLoadingHUD];
            });
        }
    } errorBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingHUD];
        });
    }];
}


#pragma mark -------------------
#pragma mark - CycLife UITableViewDataSource, UITableViewDelegate



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMusicCategoryCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicCategoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MusicCategoryCell"];
    cell.indexPath = indexPath;
    MusicCategoryModel *model = self.dataSource[indexPath.row];
    cell.lblTilte.text = model.title;
    [cell.imgMusic sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"com_image_90x90"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicCategoryModel *model = self.dataSource[indexPath.row];
    MusicListViewController *musicPlayerVC = [MusicListViewController createMusicListViewController];
    musicPlayerVC.title = model.title;
    musicPlayerVC.urlString = model.href;
    [self.navigationController pushViewController:musicPlayerVC animated:YES];
    
}


@end
