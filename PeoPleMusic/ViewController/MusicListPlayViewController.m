//
//  MusicListPlayViewController.m
//  PeoPleMusic
//
//  Created by long on 1/21/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "MusicListPlayViewController.h"
#import "TFHpple.h"
#import "OnlineMusicModel.h"
#import "MusicPlayerCell.h"

@interface MusicListPlayViewController ()<UITableViewDataSource,UITableViewDelegate,KyoRefreshControlDelegate>

@property (nonatomic, strong) NSArray *musicList;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KyoRefreshControl *kyoRefreshControl;

@end

@implementation MusicListPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.musicList = [self getMusicPlayList:self.urlString];
    
}

- (void)setupView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = kTableViewbackgroundColor;
     [self.view addSubview:self.tableView];
    
    NSDictionary *dictViews = @{@"tableView" : self.tableView,
                                @"topLayoutGuide" : self.topLayoutGuide};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[tableView]-(==0)-|" options:0 metrics:nil views:dictViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[tableView]-(==0)-|" options:0 metrics:nil views:dictViews]];

    
    
   
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MusicPlayerCell class]) bundle:nil] forCellReuseIdentifier:KMusicPlayerCellIdentifier];
//      self.kyoRefreshControl = [[KyoRefreshControl alloc] initWithScrollView:self.tableView withDelegate:self withIsCanShowNoMore:YES];
    self.view.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    self.tableView.bounds = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (NSArray *)getMusicPlayList:(NSString *)ulrString{
    
    NSString *contentHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:ulrString] encoding:NSUTF8StringEncoding error:nil];
    TFHpple *doc = [TFHpple hppleWithHTMLData:[contentHtml dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSArray *TRElements = [doc searchWithXPathQuery:@"//div[@class='main fl']//div[@class='m_list']//ul[@id='musicList']//li[@class='clearfix']"];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (TFHppleElement *e in TRElements) {
        
        OnlineMusicModel *model = [[OnlineMusicModel alloc] init];
        
        NSArray *tempNumb = [e searchWithXPathQuery:@"//p[@class='number']"];
        if(tempNumb.count > 0){
            model.number = [tempNumb[0] content];
            model.mid = [[[tempNumb[0] children] objectAtIndex:0] objectForKey:@"mid"];
        }
        
        NSArray *tempm_name = [e searchWithXPathQuery:@"//p[@class='m_name']//a"];
        if (tempm_name.count > 0) {
            model.m_name =  [tempm_name[0]  content];
        }
      
        NSArray *tempa_name = [e searchWithXPathQuery:@"//p[@class='a_name']//a"];
        if (tempa_name.count > 0) {
            model.a_name = [tempa_name[0] content];
        }
        
        NSArray *temps_name = [e searchWithXPathQuery:@"//p[@class='s_name']//a"];
        if (temps_name) {
            model.s_name = [temps_name[0] content];
        }
        
        NSArray *templisten = [e searchWithXPathQuery:@"//p[@class='listen']//a"];
        if (templisten) {
            model.listen_href = [templisten[0] objectForKey:@"href"];
        }
       

        [tempArr addObject:model];
    }
    return tempArr;
}

- (void)requestData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.kyoRefreshControl kyoRefreshDoneRefreshOrLoadMore:YES withHadData:YES withError:nil];
    });
}

#pragma mark - UITableViewDelegate, UITableViewSourceData



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.musicList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return KMusicPlayerCellHeight;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MusicPlayerCell  *cell = [tableView dequeueReusableCellWithIdentifier:KMusicPlayerCellIdentifier];

    cell.onlineMusicModel = self.musicList[indexPath.row];
    
    
    return cell;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate

//刷新
- (void)kyoRefreshDidTriggerRefresh:(KyoRefreshControl *)refreshControl {
    [self requestData];
}

//加载下一页
- (void)kyoRefreshLoadMore:(KyoRefreshControl *)refreshControl loadPage:(NSInteger)index {
}

@end
