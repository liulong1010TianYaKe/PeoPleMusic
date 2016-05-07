//
//  HeadModel.m
//  PeoPleMusic
//
//  Created by Alen on 16/3/16.
//  Copyright © 2016年 zhuniT All rights reserved.
//

#import "HeadModel.h"

@implementation HeadModel
+ (NSDictionary *)getJSONHead:(NSString *)cmdStr{
    
    HeadModel *model = [[HeadModel alloc] init];
    model.head  = @"00";
    model.result = @"0";
    model.cmdType = cmdStr;
    model.end = @"11";
    return [model keyValues];
}
@end
