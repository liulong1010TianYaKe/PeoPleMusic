//
//  MusicPlayViewController.h
//  PeoPleMusic
//
//  Created by long on 1/21/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "BasicsViewController.h"


@interface MusicListViewController : BasicsViewController
@property (nonatomic, strong) NSString *urlString;

@property (nonatomic,strong) NSString  *requestKey;
@property (nonatomic, assign) NSInteger tatolSize;

@property (nonatomic, assign) MusiclistViewStyle style;
+ (MusicListViewController *)createMusicListViewController;

@end
