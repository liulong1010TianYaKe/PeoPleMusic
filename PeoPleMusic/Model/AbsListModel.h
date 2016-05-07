//
//  AbsListModel.h
//  PeoPleMusic
//
//  Created by Alen on 16/4/17.
//  Copyright © 2016年 zhuniT All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongInforModel.h"


@interface AbsListModel : NSObject
@property (nonatomic, strong) NSString *MUSICRID;
@property (nonatomic, strong) NSString *MVPIC;
@property (nonatomic, strong) NSString *SONGNAME;
@property (nonatomic, strong) NSString *ARTIST;
@property (nonatomic, strong) NSString *ALBUM;

+ (NSArray *)getSongInforModel:(NSArray *)absListModel;
@end
