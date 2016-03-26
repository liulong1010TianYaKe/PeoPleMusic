//
//  MusicPlayView.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "MusicPlayView.h"
#import "UIView+CTDialog.h"
#import "STKAudioPlayer.h"
#import "SongDemandViewController.h"

@interface MusicPlayView ()<STKAudioPlayerDelegate>
@property (nonatomic, strong) STKAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayTime;
@property (weak, nonatomic) IBOutlet UISlider *slider;
//临时储存当前播放音乐的URL
@property (nonatomic, strong) NSString *nowSource;

@property (nonatomic,strong) NSString *aMusic;
//上一曲 下一曲
//从上个VC传来的当前音乐在数组中的位置


@property(nonatomic,retain)NSTimer *timer;
@end

@implementation MusicPlayView

- (void)awakeFromNib{
    [super awakeFromNib];
     self.isPlaying = YES;

//    equalizerBandFrequencies均衡器带频率
//    enableVolumeMixer设置为yes,将启用音量控制
//    flushQueueOnSeek 刷新音频队列
    
        self.player = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = YES, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
        self.player.volume = 0.5;
        self.player.delegate = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(track) userInfo:nil repeats:YES];
    
}

- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    if (_isPlaying) {
        [self.btnPlaying setTitle:@"停止" forState:UIControlStateNormal];
    }else{
        [self.btnPlaying setTitle:@"播放" forState:UIControlStateNormal];
    }
}

- (void)setAMusic:(NSString *)aMusic{
    _aMusic = aMusic;
    if (!aMusic) {
        self.lblSongName.text = @"亲，播放失败，请重试!";
    }
    if (self.nowSource != aMusic) {
        [self playMusic:aMusic];
        //把当前的音乐URL储存,记录为下一次播放时候的 上一个音乐URL
        self.nowSource = aMusic;
    }
}
 
- (void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
    SongInforModel *model = self.songlist[indexRow];
    self.lblSongName.text = model.mediaName;
    self.aMusic = [self.songlist[indexRow] mediaUrl];
}
#pragma mark -------------------
#pragma mark - Methods
- (void)playMusic:(NSString *)playUrl{
    [self.player playURL:[NSURL URLWithString:playUrl]];
}
//开始,暂停按钮
- (void)startButtonAction{
    if (self.player.state == STKAudioPlayerStatePaused) {
        NSLog(@"暂停");
        self.isPlaying = YES;
        [self.player resume];
        
    }else if (self.player.state == STKAudioPlayerStatePlaying) {
        self.isPlaying = NO;
        NSLog(@"播放");
        [self.player pause];
        
    }
}

-(void)nextButtonAction
{
        self.indexRow++;
        if (self.indexRow == self.songlist.count) {
            self.indexRow = 0;
        }
        SongInforModel *model = self.songlist[self.indexRow];
        self.lblSongName.text = model.mediaName;
        self.aMusic = model.mediaUrl;
}

-(void)lastButtonAction
{
        self.indexRow--;
        if (self.indexRow == -1) {
            self.indexRow = self.songlist.count - 1;
        }
        SongInforModel *model = self.songlist[self.indexRow];
        self.lblSongName.text = model.mediaName;
        self.aMusic = model.mediaUrl;
}


//每隔一秒调用该方法
-(void)track
{
    self.slider.maximumValue = self.player.duration;//音乐总时长
    self.slider.value = self.player.progress;//当前进度
    //    self.progressView.progress = self.player.progress / self.player.duration;
    
    
    //当前时长进度progress
    NSInteger proMin = (NSInteger)self.player.progress / 60;//当前秒
    NSInteger proSec = (NSInteger)self.player.progress % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = (NSInteger)self.player.duration / 60;//总秒
    NSInteger durSec = (NSInteger)self.player.duration % 60;//总分钟
    
    self.lblPlayTime.text = [NSString stringWithFormat:@"%ld:%ld / %ld:%ld", (long)proMin, (long)proSec, (long)durMin, (long)durSec];
}



- (IBAction)btnPreTouchInside:(id)sender {
    [self lastButtonAction];
}

- (IBAction)btnNextTouchInside:(id)sender {
    [self nextButtonAction];
}


- (IBAction)btnPlayingTouchInside:(UIButton *)sender {
   
    self.isPlaying = !self.isPlaying;
    
    [self startButtonAction];
}

// 点歌
- (IBAction)btnDianboTouchInside:(id)sender {
    
    [self btnCloseTouchInside:nil];
    
    SongDemandViewController *songVC = [SongDemandViewController createSongDemandViewController];
    songVC.songInfoModel = self.songlist[self.indexRow];
    [[KyoUtil getCurrentNavigationViewController] pushViewController:songVC animated:YES];
}

- (IBAction)btnCloseTouchInside:(id)sender {
    [self.player dispose];
    self.player = nil;
    [self.timer invalidate];
    self.timer = nil;
    [self.dialogView close];
}
- (IBAction)musicSliderTouchInside:(UISlider *)sender {
    if (self.player) {
        [self.player seekToTime:sender.value];
    }
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