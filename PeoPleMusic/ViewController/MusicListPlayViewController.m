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
#import <CommonCrypto/CommonDigest.h>
#import "STKAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

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



- (NSString *)getMusic:(NSString *)musicID{

    
    NSString *downUrl = nil;
    
    NSString *midUrl = [NSString stringWithFormat:@"http://player.kuwo.cn/webmusic/st/getNewMuiseByRid?rid=MUSIC_%@", musicID];
    
    NSString *title=[NSString stringWithContentsOfURL:[NSURL URLWithString:midUrl] encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [title dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *parser = [[TFHpple alloc]initWithXMLData:data];
    NSArray *array = [parser searchWithXPathQuery:@"//Song"];
    if (array == nil || array.count == 0) return nil;
    TFHppleElement *e0 = array[0];
    NSArray *contetnt = [e0 children];
    
    NSString *dl = nil;
    NSString *path;
    NSString *size;
    
    for(TFHppleElement *e in contetnt){
        NSString *tagName =[e tagName];
        if([tagName isEqualToString:@"mp3dl"]){
            //            NSLog(@"%@", [e content]);
            dl = [e content];
        }else if([tagName isEqualToString:@"mp3path"]){
            //            NSLog(@"%@", [e content]);
            path = [e content];
        }else if([tagName isEqualToString:@"mp3size"]){
            //            NSLog(@"%@", [e content]);
            size = [e content];
        }
    }
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [[NSString stringWithFormat:@"%8x", (int)a] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    //    NSLog(@"%@", timeString);
    NSMutableString *str = [[NSMutableString alloc] init];
    
    [str setString:@"kuwo_web@1906/resource/"];
    
    [str appendString:path];
    [str appendString:timeString];
    //    NSString *str = [[NSMutableString stringWithFormat:@"kuwo_web@1906/resource/%@", path] appendString:timeString];
    NSString *mUrl = [self md5HexDigest:str];
    //    NSLog(@"%@", mUrl);
    downUrl = [NSString stringWithFormat:@"http://%@/%@/%@/%@/%@", dl, mUrl, timeString, @"resource", path];
    
    
    NSLog(@"%@", downUrl);
    return downUrl;
}

-(NSString *)md5HexDigest:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
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
    
    OnlineMusicModel *model = self.musicList[indexPath.row];
    NSLog(@"%@",model.mid);
  [self playMusic:[self getMusic:model.mid]];
}

- (void)playMusic:(NSString *)playUrl{
    NSLog(@"playUrl = %@",playUrl);
    STKAudioPlayer *audioPlayer = [[STKAudioPlayer alloc] init];
    [audioPlayer playURL:[NSURL URLWithString:playUrl]];
//    NSURL *url = [[NSURL alloc] initWithString:playUrl];
////    NSURL *url = [[NSURL alloc]initWithString:urlStr];
//    NSData * audioData = [NSData dataWithContentsOfURL:url];
//    
//    //将数据保存到本地指定位置
//    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
//    [audioData writeToFile:filePath atomically:YES];
//    
//    //播放本地音乐
//    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//   AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//    [player play];
    
  
//    NSURL *url = [NSURL URLWithString: [playUrl encodeToPercentEscapeString]];
////    [audioPlayer playURL:url];
//   
//      MPMoviePlayerController*    moivePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//
//    [moivePlayer play];
    
    
    
    
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
