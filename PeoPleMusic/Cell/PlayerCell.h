//
//  PlayerCell.h
//  PeoPleMusic
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 zhuniT All rights reserved.
//

#import "BasicsCell.h"
#import "SongInforModel.h"

#define KPlayerCellHeight 60 // 60+38
#define KPlayerCellIdentifier  @"KPlayerCellIdentifier"

typedef enum : NSUInteger {
    PlayerCellBtnTypeDetail,
    PlayerCellBtnTypeDelete,
    PlayerCellBtnTypeMsg,
    PlayerCellBtnTypeChabo,
} PlayerCellBtnTypes;

@protocol PlayerCellDelegate;
@interface PlayerCell : BasicsCell

@property (nonatomic, strong) SongInforModel *model;


@property (nonatomic, weak)id<PlayerCellDelegate> delegate;

//+ (CGFloat)getPlayCellHeight:(SongInforModel *)model;

@end

@protocol PlayerCellDelegate <NSObject>
@optional
- (void)playerCellTouchInside:(PlayerCell *)cell withModel:(SongInforModel *)model;
- (void)playerCellTouchInside:(PlayerCell *)cell withBtnType:(PlayerCellBtnTypes )type;
@end