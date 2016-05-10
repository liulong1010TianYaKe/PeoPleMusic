//
//  SearchDeviceCell.h
//  PeoPleMusic
//
//  Created by long on 5/5/16.
//  Copyright © 2016 zhuniT All rights reserved.
//

#import "BasicsCell.h"
#import "DeviceVodBoxModel.h"

@interface SearchDeviceCell : BasicsCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelect;

@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@property (nonatomic, strong) DeviceVodBoxModel *model;

@end
