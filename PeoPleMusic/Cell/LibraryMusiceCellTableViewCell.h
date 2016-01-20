//
//  LibraryMusiceCellTableViewCell.h
//  PeoPleMusic
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicCategoryModel.h"
#define KLibraryMusiceCellTableViewCellHeight 44// 60+38
#define KLibraryMusiceCellTableViewCellIdentifier  @"KPlayerCellIdentifier"


@interface LibraryMusiceCellTableViewCell : UITableViewCell



@property (nonatomic, strong) MusicCategoryModel *model;

@end
