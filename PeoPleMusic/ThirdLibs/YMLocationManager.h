//
//  YMLocationManager.h
//  PeoPleMusic
//
//  Created by long on 5/5/16.
//  Copyright © 2016 kyo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^locationgCompletionBlock)(CGFloat latitude, CGFloat longitude,NSError *error);
@interface YMLocationManager : NSObject


+(instancetype)shareManager;

- (void)startLocotion:(locationgCompletionBlock)completionblock;
@end
