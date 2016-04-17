//
//  AbsListModel.m
//  PeoPleMusic
//
//  Created by Alen on 16/4/17.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "AbsListModel.h"
#import "AFNetworking.h"

@implementation AbsListModel

+ (NSString *)getMusicWithMusicULRString:(NSString *)urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *err;
  
    NSString *title=[NSString stringWithContentsOfURL:url encoding:NSUTF32BigEndianStringEncoding error:&err];
    

    
    const NSStringEncoding *encodings = [NSString availableStringEncodings];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    NSStringEncoding encoding;
    while ((encoding = *encodings++) != 0)
    {
        [str appendFormat: @"%@ === %lun", [NSString localizedNameOfStringEncoding:encoding], (unsigned long)encoding];
        title=[NSString stringWithContentsOfURL:url encoding:encoding error:&err];
        if (title) {
            KyoLog(@"----%@",title);
            break;
        }
    }
    
    KyoLog(@"%@",str);
    if (!title) {
        title = @"http://ip.h5.ra03.sycdn.kuwo.cn/f8216774477d26d57291fd90b4bf8ed5/57133f22/resource/a3/48/50/0/3322591213.aac";
    }

    return title ;
}
+ (NSArray *)getSongInforModel:(NSArray *)absListModel{
    NSMutableArray *arr = [NSMutableArray array];
    for (AbsListModel *abs in absListModel) {
        SongInforModel *model = [[SongInforModel alloc] init];
        model.albumName = abs.ALBUM;
        model.mediaId = abs.MUSICRID;
        model.mediaName = abs.SONGNAME;
        model.artist = abs.ARTIST;

//        NSString *URLSTRING = [NSString stringWithFormat:@"http://antiserver.kuwo.cn/anti.s?type=convert_url&rid=%@&format=aac|mp3&response=url",abs.MUSICRID];
//        
//         model.mediaUrl =  [AbsListModel getMusicWithMusicULRString:URLSTRING];
        [arr addObject:model];
    }
    
    return arr;
}
@end
