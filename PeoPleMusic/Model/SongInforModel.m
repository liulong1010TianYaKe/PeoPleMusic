//
//  SongInforModel.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/5.
//  Copyright © 2016年 kyo. All rights reserved.
//

#import "SongInforModel.h"
#import "TFHpple.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SongInforModel


- (NSString *)mediaUrl{
    
    if (!_mediaUrl) {
        
        _mediaUrl =  [self getMusic:self.mediaId];
    }
    return _mediaUrl;
}


- (NSString *)getMusic:(NSString *)musicID{
    
    
    NSString *downUrl = nil;
    
    NSString *midUrl = [NSString stringWithFormat:@"http://player.kuwo.cn/webmusic/st/getNewMuiseByRid?rid=MUSIC_%@", musicID];
    
    NSString *title=[NSString stringWithContentsOfURL:[NSURL URLWithString:midUrl] encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [title dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *parser = [[TFHpple alloc]initWithXMLData:data];
    NSArray *array = [parser searchWithXPathQuery:@"//Song"];
    if (array == nil || array.count == 0) return nil;
    TFHppleElement *e0 = array[0];
    NSArray *contetnt = [e0 children];
    
    NSString *dl = nil;
    NSString *path;
    NSString *size;
    
    for(TFHppleElement *e in contetnt){
        NSString *tagName =[e tagName];
        if([tagName isEqualToString:@"mp3dl"]){
            //            NSLog(@"%@", [e content]);
            dl = [e content];
        }else if([tagName isEqualToString:@"mp3path"]){
            //            NSLog(@"%@", [e content]);
            path = [e content];
        }else if([tagName isEqualToString:@"mp3size"]){
            //            NSLog(@"%@", [e content]);
            size = [e content];
        }
    }
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [[NSString stringWithFormat:@"%8x", (int)a] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    //    NSLog(@"%@", timeString);
    NSMutableString *str = [[NSMutableString alloc] init];
    
    [str setString:@"kuwo_web@1906/resource/"];
    
    [str appendString:path];
    [str appendString:timeString];
    //    NSString *str = [[NSMutableString stringWithFormat:@"kuwo_web@1906/resource/%@", path] appendString:timeString];
    NSString *mUrl = [self md5HexDigest:str];
    //    NSLog(@"%@", mUrl);
    downUrl = [NSString stringWithFormat:@"http://%@/%@/%@/%@/%@", dl, mUrl, timeString, @"resource", path];
    
    
    NSLog(@"%@", downUrl);
    return downUrl;
}

-(NSString *)md5HexDigest:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (NSDictionary *)getSongInfoDictWtihSongInfo:(SongInforModel *)songInfo{
    
    return [songInfo keyValues];
}
@end

@implementation SongInfoList

- (NSDictionary *)objectClassInArray{
    return @{@"songList": [SongInforModel class]};
}

@end
