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
+ (MusicListViewController *)createMusicListViewController;

+ (instancetype)sharePlayerViewController;
@end
