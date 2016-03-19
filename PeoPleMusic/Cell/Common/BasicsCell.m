//
//  BasicsCell.m
//  KidsBook
//
//  Created by Lukes Lu on 13-9-29.
//  Copyright (c) 2013年 KidsBook Office. All rights reserved.
//

#import "BasicsCell.h"

@interface BasicsCell ()

@end

@implementation BasicsCell

#pragma mark - Lifecycle

- (void)dealloc {
    KyoLog(@"[%@] dealloc", [self class]);
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (NSString *)reuseIdentifier
{
    return [super reuseIdentifier];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}

#pragma mark - Methods

@end
