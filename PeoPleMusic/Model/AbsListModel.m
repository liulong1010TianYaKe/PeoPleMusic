//
//  AbsListModel.m
//  PeoPleMusic
//
//  Created by Alen on 16/4/17.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "AbsListModel.h"

@implementation AbsListModel

+ (NSString *)getMusicWithMusicULRString:(NSString *)urlString{
//    NSURL *url = [NSURL URLWithString:[urlString encodeToPercentEscapeString]];
//    NSString *title=[NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    //创建URL
    NSURL *mURL = [NSURL URLWithString:urlString];
    
    //创建一个请求，最大请求时间为20秒
    NSURLRequest *requrst = [NSURLRequest requestWithURL:mURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    //同步请求返回的参数
    NSURLResponse *response = nil;
    NSError *error = nil;
    //建立连接，下载数据，同步请求
    NSData *data = [NSURLConnection sendSynchronousRequest:requrst returningResponse:&response error:&error];
    
    //打印服务器传回得数据
    NSLog(@"data = %@",data);
    //打印请求出错时的出错信息
    NSLog(@"error is %@",[error localizedDescription]);
    return nil;
}
+ (NSArray *)getSongInforModel:(NSArray *)absListModel{
    NSMutableArray *arr = [NSMutableArray array];
    for (AbsListModel *abs in absListModel) {
        SongInforModel *model = [[SongInforModel alloc] init];
        model.albumName = abs.ALBUM;
        model.mediaId = abs.MUSICRID;
        model.mediaName = abs.SONGNAME;
        model.artist = abs.ARTIST;

        NSString *URLSTRING = [NSString stringWithFormat:@"http://antiserver.kuwo.cn/anti.s?type=convert_url&rid=%@&format=aac|mp3&response=url",abs.MUSICRID];
        
         model.mediaUrl =  [AbsListModel getMusicWithMusicULRString:URLSTRING];
        [arr addObject:model];
    }
    
    return arr;
}
@end
