//
//  LibraryMusiceCellTableViewCell.h
//  PeoPleMusic
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import "BasicsCell.h"


#define KLibraryMusiceCellHeight 44// 60+38
#define KLibraryMusiceCellIdentifier  @"LibraryMusiceCell"


@interface LibraryMusiceCell : BasicsCell
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@end
