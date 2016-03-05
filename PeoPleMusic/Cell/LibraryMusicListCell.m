//
//  LibraryMusicListCell.m
//  PeoPleMusic
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "LibraryMusicListCell.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface LibraryMusicListCell ()


@end
@implementation LibraryMusicListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MusicCategoryModel *)model{
    _model = model;
    if (model) {
  
//
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////          dispatch_async(dispatch_get_main_queue(), ^{
////              self.imageView.image = image;
////              [self.tableView performSelectorOnMainThread:@selector(real) withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>]
////              [self.tableView reloadData];
////              [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
////          });
//        }];
        
        [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
      
        self.lblTilte.text = model.title;
        self.lblSubTitle.text = model.number;
    }
}

//- (void)loadImage{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long) NULL), ^{
//        
//    });
//}

@end
