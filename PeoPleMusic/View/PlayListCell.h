//
//  PlayListCell.h
//  PeoPleMusic
//
//  Created by apple on 15/12/25.
//  Copyright © 2015年 zhuniT All rights reserved.
//

#import "BasicsCell.h"
#import "SongInforModel.h"
#define KPlayListCellIdentify @"KPlayListCellIdentify"
#define KPlayListCelllHeight 44



@interface PlayListCell : BasicsCell

@property (nonatomic, strong)SongInforModel *model;
@property (nonatomic, copy)void(^CancelOperationBlock)(NSIndexPath *indexPath);
@end
                                                                                                                                                                    