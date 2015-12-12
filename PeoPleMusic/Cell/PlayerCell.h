//
//  PlayerCell.h
//  PeoPleMusic
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"

#define KPlayerCellHeight 60 // 60+38
#define KPlayerCellIdentifier  @"KPlayerCellIdentifier"

typedef enum : NSUInteger {
    PlayerCellBtnTypeDetail,
    PlayerCellBtnTypeDelete,
    PlayerCellBtnTypeMsg,
    PlayerCellBtnTypeChabo,
} PlayerCellBtnTypes;

@protocol PlayerCellDelegate;
@interface PlayerCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) SongModel *model;

@property (nonatomic, weak)id<PlayerCellDelegate> delegate;

+ (CGFloat)getPlayCellHeight:(SongModel *)model;

@end

@protocol PlayerCellDelegate <NSObject>
@optional
- (void)playerCellTouchInside:(PlayerCell *)cell withModel:(SongModel *)model;
- (void)playerCellTouchInside:(PlayerCell *)cell withBtnType:(PlayerCellBtnTypes )type;
@end