//
//  HomeCell.h
//  PeoPleMusic
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

#define KHomeCellIdentify @"KHomeCellIdentify"
#define KHomeCellHeight 44

@interface HomeCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexpath;
@property (nonatomic, strong) HomeModel  *model;

@end
