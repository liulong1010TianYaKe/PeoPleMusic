//
//  SongDemandViewController.h
//  PeoPleMusic
//
//  Created by Alen on 16/3/20.
//  Copyright © 2016年 zhuniT All rights reserved.
//

#import "BasicsViewController.h"
#import "SongInforModel.h"

@interface SongDemandViewController : BasicsViewController

@property (nonatomic, assign) MusicSongPlayStyle playStyle;

@property (nonatomic, assign) MusiclistViewStyle type;
@property (nonatomic, strong)SongInforModel *songInfoModel;
+ (SongDemandViewController *)createSongDemandViewController;
@property (nonatomic, copy) void (^btnBackBlockOperation)();
@end
