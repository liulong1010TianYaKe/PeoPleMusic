//
//  OnlineMusicModel.h
//  PeoPleMusic
//
//  Created by long on 1/21/16.
//  Copyright © 2016 zhuniT All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineMusicModel : NSObject

@property (nonatomic, strong) NSString *number; // 歌曲序号
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *m_name; // 歌曲名
@property (nonatomic, strong) NSString *a_name; // 专辑
@property (nonatomic, strong) NSString *s_name; // 歌手
@property (nonatomic, strong) NSString *listen_href; // 歌曲地址


@end
