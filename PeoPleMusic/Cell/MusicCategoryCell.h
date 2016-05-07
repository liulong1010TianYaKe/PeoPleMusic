//
//  LibraryMusicListCell.h
//  PeoPleMusic
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 zhuniT All rights reserved.
//

#import "BasicsCell.h"



#define KMusicCategoryCellHeight 60// 60+38



@interface MusicCategoryCell : BasicsCell

@property (weak, nonatomic) IBOutlet UIImageView *imgMusic;
@property (weak, nonatomic) IBOutlet UILabel *lblTilte;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@end
