//
//  MusicPlayViewController.h
//  PeoPleMusic
//
//  Created by long on 1/21/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import "BasicsViewController.h"

@interface MusicPlayViewController : BasicsViewController
@property (nonatomic, strong) NSString *urlString;
+ (MusicPlayViewController *)createMusicPlayViewController;

+ (instancetype)sharePlayerViewController;
@end
