//
//  HomeModel.h
//  PeoPleMusic
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BlockOperation)(void);
@interface HomeModel : NSObject

@property (nonatomic, strong) NSString* imgIcon; /**< 左边图标 */

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) UIColor *subtitleColor;

@property (nonatomic, copy) BlockOperation blockOperation;

@end
