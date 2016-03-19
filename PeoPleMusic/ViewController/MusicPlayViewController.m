//
//  MusicListPlayViewController.m
//  PeoPleMusic
//
//  Created by long on 1/21/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "TFHpple.h"
#import "OnlineMusicModel.h"
#import "MusicPlayerCell.h"
#import <CommonCrypto/CommonDigest.h>
#import "STKAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicPlayViewController ()<UITableViewDataSource,UITableViewDelegate,KyoRefreshControlDelegate,STKAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *musicList;


@property (nonatomic, strong) KyoRefreshControl *kyoRefreshControl;


@property (nonatomic, strong) STKAudioPlayer *player;

//临时储存当前播放音乐的URL
@property (nonatomic, strong) NSString *nowSource;

@property (nonatomic,strong) NSString *aMusic;
//上一曲 下一曲
//从上个VC传来的当前音乐在数组中的位置
@property(nonatomic,assign)NSInteger indexRow;

@property(nonatomic,retain)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UISlider *playSlider;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;

// 上一首
- (IBAction)btnPrevPlayer:(id)sender;
// 正在播放
- (IBAction)btnPlaying:(id)sender;
// 下一首
- (IBAction)btnNextPlay:(id)sender;
- (IBAction)musicSliderTouchInside:(id)sender;

@end

@implementation MusicPlayViewController


#pragma mark -------------------
#pragma mark - CycLife

+ (MusicPlayViewController *)createMusicPlayViewController{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LibraryMusic" bundle:nil];
    
    MusicPlayViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MusicPlayViewController class])];
    return controller;
}

+ (instancetype)sharePlayerViewController{
    static MusicPlayViewController *musicPlayVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicPlayVC = [MusicPlayViewController createMusicPlayViewController];
    });
    return musicPlayVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

      self.musicList = [self getMusicPlayList:self.urlString];
    //equalizerBandFrequencies均衡器带频率
    //enableVolumeMixer设置为yes,将启用音量控制
    //flushQueueOnSeek 刷新音频队列
    
    
    self.player = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = YES, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    
    self.player.volume = 0.5;
    self.player.delegate = self;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(track) userInfo:nil repeats:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}
- (void)setupView{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MusicPlayerCell class]) bundle:nil] forCellReuseIdentifier:KMusicPlayerCellIdentifier];
    //      self.kyoRefreshControl = [[KyoRefreshControl alloc] initWithScrollView:self.tableView withDelegate:self withIsCanShowNoMore:YES];

} 

#pragma mark --------------------
#pragma mark - Settings, Gettings

- (void)setAMusic:(NSString *)aMusic{
    _aMusic = aMusic;
    if (self.nowSource != aMusic) {
        [self.btnPlay setTitle:@"暂停" forState:UIControlStateNormal];
        [self.player play:aMusic];
        //把当前的音乐URL储存,记录为下一次播放时候的 上一个音乐URL
        self.nowSource = aMusic;
    }
}
#pragma mark --------------------
#pragma mark - Events
- (IBAction)btnPrevPlayer:(id)sender {
    [self lastButtonAction];
}

- (IBAction)btnPlaying:(id)sender {
    [self startButtonAction];
}

- (IBAction)btnNextPlay:(id)sender {
    [self nextButtonAction];
}

- (IBAction)musicSliderTouchInside:(UISlider *)sender {
    if (self.player) {
        
        [self.player seekToTime:sender.value];
    }
}
#pragma mark -------------------
#pragma mark - Methods

//开始,暂停按钮
- (void)startButtonAction{
    if (self.player.state == STKAudioPlayerStatePaused) {
//        self.
        NSLog(@"暂停");
        [self.btnPlay setTitle:@"暂停" forState:UIControlStateNormal];
        [self.player resume];
        
    }else if (self.player.state == STKAudioPlayerStatePlaying) {
        [self.btnPlay setTitle:@"播放" forState:UIControlStateNormal];
         NSLog(@"播放");
        [self.player pause];
        
    }
}

-(void)nextButtonAction
{
    self.indexRow++;
    if (self.indexRow == self.musicList.count) {
        self.indexRow = 0;
    }
    
    OnlineMusicModel *model = self.musicList[self.indexRow];
    NSLog(@"%@",model.mid);
      self.aMusic = [self getMusic:model.mid];;
    
//    self.amusic = [self.allMusicArray objectAtIndex:self.indexRow];
}

-(void)lastButtonAction
{
    self.indexRow--;
    if (self.indexRow == -1) {
        self.indexRow = self.musicList.count - 1;
    }
    
    OnlineMusicModel *model = self.musicList[self.indexRow];
    NSLog(@"%@",model.mid);
    //   [self playMusic:[self getMusic:model.mid]];
    self.aMusic = [self getMusic:model.mid];
//    self.amusic = [self.allMusicArray objectAtIndex:self.indexRow];
}


//每隔一秒调用该方法
-(void)track
{
    //
    //self.player.duration 音乐总时长
    //self.player.progress 当前进度
    self.playSlider.maximumValue = self.player.duration;//音乐总时长
    self.playSlider.value = self.player.progress;//当前进度
//    self.progressView.progress = self.player.progress / self.player.duration;

    
    //当前时长进度progress
    NSInteger proMin = (NSInteger)self.player.progress / 60;//当前秒
    NSInteger proSec = (NSInteger)self.player.progress % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = (NSInteger)self.player.duration / 60;//总秒
    NSInteger durSec = (NSInteger)self.player.duration % 60;//总分钟
    
    self.lblTime.text = [NSString stringWithFormat:@"%ld:%ld / %ld:%ld", (long)proMin, (long)proSec, (long)durMin, (long)durSec];
}
#pragma mark --------------------
#pragma mark - UITableViewDelegate, UITableViewSourceData

#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC


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
    
    self.indexRow = indexPath.row;
    OnlineMusicModel *model = self.musicList[indexPath.row];
    NSLog(@"%@",model.mid);
//   [self playMusic:[self getMusic:model.mid]];
    self.aMusic = [self getMusic:model.mid];
}

- (void)playMusic:(NSString *)playUrl{
    NSLog(@"playUrl = %@",playUrl);
//    STKAudioPlayer *audioPlayer = [[STKAudioPlayer alloc] init];
    [self.player playURL:[NSURL URLWithString:playUrl]];

}
#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate

#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate
//刷新
- (void)kyoRefreshDidTriggerRefresh:(KyoRefreshControl *)refreshControl {
    [self requestData];
}

//加载下一页
- (void)kyoRefreshLoadMore:(KyoRefreshControl *)refreshControl loadPage:(NSInteger)index {
}

#pragma mark -------------------
#pragma mark -  STKAudioPlayerDelegate
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    
}

-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"开始播放");
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"完成加载");
}
-(void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    NSLog(@"播放状态改变");
}

-(void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    NSLog(@"结束播放");
    NSLog(   @"stopReason:  %ld"    @"progress:  %f"  @"duration: %f",(long)stopReason,progress,duration);
    if (stopReason == 1) {
        [self nextButtonAction];
    }
}


@end
