//
//  PlayListCell.h
//  PeoPleMusic
//
//  Created by apple on 15/12/25.
//  Copyright © 2015年 kyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KPlayListCellIdentify @"KPlayListCellIdentify"
#define KPlayListCelllHeight 60

typedef void(^CancelOperationBlock)();

@interface PlayListCell : UITableViewCell

@property (nonatomic, copy)CancelOperationBlock cancelOperationBlock;

@end
