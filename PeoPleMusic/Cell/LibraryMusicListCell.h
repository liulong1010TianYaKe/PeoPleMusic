//
//  LibraryMusicListCell.h
//  PeoPleMusic
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicCategoryModel.h"
#define KLibraryMusicListCellTableViewCellHeight 60// 60+38
#define KLibraryMusicListCellTableViewCellIdentifier  @"KLibraryMusicListCellTableViewCellIdentifier"

@interface LibraryMusicListCell : UITableViewCell
@property (nonatomic, strong) MusicCategoryModel *model;
@property (nonatomic, strong) NSIndexPath  *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *imgMusic;
@property (weak, nonatomic) IBOutlet UILabel *lblTilte;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (nonatomic, weak) UITableView *tableView;
@end
