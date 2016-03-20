//
//  MusicListPlayViewController.m
//  PeoPleMusic
//
//  Created by long on 1/21/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "MusicListViewController.h"
#import "TFHpple.h"
#import "OnlineMusicModel.h"
#import "MusicPlayerCell.h"

#import "MusicPlayView.h"
#import "SongInforModel.h"

@interface MusicListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSArray *songList;


@end

@implementation MusicListViewController


#pragma mark -------------------
#pragma mark - CycLife

+ (MusicListViewController *)createMusicListViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    MusicListViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MusicListViewController class])];
    return controller;
}

+ (instancetype)sharePlayerViewController{
    static MusicListViewController *musicPlayVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicPlayVC = [MusicListViewController createMusicListViewController];
    });
    return musicPlayVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)setupView{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MusicPlayerCell class]) bundle:nil] forCellReuseIdentifier:KMusicPlayerCellIdentifier];

    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void)setupData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self networkGetMusicListData];
    });
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

- (void)networkGetMusicListData{
    
    [NetworkSessionHelp NetworkHTML:self.urlString completionBlock:^(NSString *htmlText, NSInteger responseStatusCode) {
        if (responseStatusCode == 200) {
            
            TFHpple *doc = [TFHpple hppleWithHTMLData:[htmlText dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSArray *TRElements = [doc searchWithXPathQuery:@"//div[@class='main fl']//div[@class='m_list']//ul[@id='musicList']//li[@class='clearfix']"];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (TFHppleElement *e in TRElements) {
                
                SongInforModel *model = [[SongInforModel alloc] init];
                
                NSArray *tempNumb = [e searchWithXPathQuery:@"//p[@class='number']"];
                if(tempNumb.count > 0){
                    model.number = [tempNumb[0] content];
                    model.mediaId = [[[tempNumb[0] children] objectAtIndex:0] objectForKey:@"mid"];
                }
                
                NSArray *tempm_name = [e searchWithXPathQuery:@"//p[@class='m_name']//a"];
                if (tempm_name.count > 0) {
                    model.mediaName =  [tempm_name[0]  content];
                }
                
                NSArray *tempa_name = [e searchWithXPathQuery:@"//p[@class='a_name']//a"];
                if (tempa_name.count > 0) {
                    model.albumName = [tempa_name[0] content];
                }
                
                NSArray *temps_name = [e searchWithXPathQuery:@"//p[@class='s_name']//a"];
                if (temps_name) {
                    model.artist = [temps_name[0] content];
                }
                
                NSArray *templisten = [e searchWithXPathQuery:@"//p[@class='listen']//a"];
                if (templisten) {
                    model.listen_href = [templisten[0] objectForKey:@"href"];
                }
                
                
                [tempArr addObject:model];
            }
            self.songList = [NSArray arrayWithArray:tempArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark --------------------
#pragma mark - Events


#pragma mark -------------------
#pragma mark - Methods



#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.songList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return KMusicPlayerCellHeight;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MusicPlayerCell  *cell = [tableView dequeueReusableCellWithIdentifier:KMusicPlayerCellIdentifier];
    cell.indexPath = indexPath;
    
    SongInforModel *model = self.songList[indexPath.row];
    cell.lblM_Name.text = model.mediaName;
    cell.lblS_Name.text = model.artist;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MusicPlayerCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];

    
    MusicPlayView *musicPlayView = [[[NSBundle mainBundle] loadNibNamed:@"MusicPlayView" owner:self options:nil] objectAtIndex:0];
    musicPlayView.songlist = self.songList;
    musicPlayView.indexRow = indexPath.row;

    CTBaseDialogView *dialogView = [KyoUtil showDialogView:musicPlayView fromFrame:[KyoUtil relativeFrameForScreenWithView:currentCell]];
    dialogView.isNoReposeWhenBackgroundTouched = YES;
}


#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate




@end
