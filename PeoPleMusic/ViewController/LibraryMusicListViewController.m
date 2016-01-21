//
//  LibraryMusicListViewController.m
//  PeoPleMusic
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "LibraryMusicListViewController.h"
#import "MusicCategoryModel.h"
#import "TFHpple.h"
#import "LibraryMusicListCell.h"
#import "MusicListPlayViewController.h"

@interface LibraryMusicListViewController ()

@property (nonatomic, strong) NSArray *musicList;
@end

@implementation LibraryMusicListViewController


+ (LibraryMusicListViewController *)createLibraryMusicListViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    LibraryMusicListViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([LibraryMusicListViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.musicList = [self getMusicList:self.urlString];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LibraryMusicListCell class]) bundle:nil] forCellReuseIdentifier:KLibraryMusicListCellTableViewCellIdentifier];
//    [self.tableView registerClass:NSStringFromClass([LibraryMusicListCell class]) forCellReuseIdentifier:KLibraryMusicListCellTableViewCellIdentifier];
    
//    [self.tableView registerClass:[LibraryMusicListCell class] forCellReuseIdentifier:KLibraryMusicListCellTableViewCellIdentifier];
}


#pragma  mark -- 
- (NSArray *)getMusicList:(NSString *)ulrString{
    
    NSString *contentHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:ulrString] encoding:NSUTF8StringEncoding error:nil];
    TFHpple *doc = [TFHpple hppleWithHTMLData:[contentHtml dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    
    return tempArr;
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicList.count;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KLibraryMusicListCellTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryMusicListCell * cell = [tableView dequeueReusableCellWithIdentifier:KLibraryMusicListCellTableViewCellIdentifier];

    cell.model = self.musicList[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicCategoryModel *model = self.musicList[indexPath.row];
    MusicListPlayViewController *musicListPlayerVC = [[MusicListPlayViewController alloc] init];
    musicListPlayerVC.title = model.title;
    musicListPlayerVC.urlString = model.href;
    [self.navigationController pushViewController:musicListPlayerVC animated:YES];
    
}


@end
