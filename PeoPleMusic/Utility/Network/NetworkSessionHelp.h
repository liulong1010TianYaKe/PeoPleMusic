//
//  NetworkSessionHelp.h
//  MainApp
//
//  Created by Kyo on 20/11/15.
//  Copyright © 2015 zhunit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KyoRefreshControl.h"





@interface NetworkSessionHelp : NSObject

+ (NetworkSessionHelp *)shareNetwork;

+ (void)NetworkHTML:(NSString *)urlString completionBlock:(void (^)(NSString *htmlText, NSInteger responseStatusCode))completionBlock
                  errorBlock:(void (^)(NSError *error))errorBlock;
+ (void)Network:(NSString *)urlString completionBlock:(void (^)(NSDictionary *,NSInteger responseStatusCode ))completionBlock errorBlock:(void (^)(NSError *error))errorBlock finishedBlock:(void (^)(NSError *error))finishedBlock;

+ (void)postNetwork:(NSString *)urlString completionBlock:(void (^)(NSDictionary *dict, NSInteger result))completionBlock errorBlock:(void (^)(NSError *error))errorBlock finishedBlock:(void (^)(NSError *error))finishedBlock;


@end
