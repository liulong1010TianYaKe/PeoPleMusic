//
//  MusicPlayerCell.h
//  PeoPleMusic
//
//  Created by long on 1/21/16.
//  Copyright © 2016 kyo. All rights reserved.
//


#import "BasicsCell.h"

#define KMusicPlayerCellHeight 65// 60+38
#define KMusicPlayerCellIdentifier  @"KMusicPlayerCellIdentifier"

@interface MusicPlayerCell : BasicsCell


@property (weak, nonatomic) IBOutlet UILabel *lblM_Name;
@property (weak, nonatomic) IBOutlet UILabel *lblS_Name;
@end
