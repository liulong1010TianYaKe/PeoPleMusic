//
//  MusicPlayerCell.h
//  PeoPleMusic
//
//  Created by long on 1/21/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlineMusicModel.h"

#define KMusicPlayerCellHeight 65// 60+38
#define KMusicPlayerCellIdentifier  @"KMusicPlayerCellIdentifier"

@interface MusicPlayerCell : UITableViewCell

@property (nonatomic, strong) OnlineMusicModel *onlineMusicModel;

@end
