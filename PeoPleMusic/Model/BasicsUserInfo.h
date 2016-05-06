//
//  UserInfo.h
//  KidsBook
//
//  Created by Lukes Lu on 10/21/13.
//  Copyright (c) 2013 KidsBook Office. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicsUserInfo : NSObject

@property (strong, nonatomic) NSArray *arrayNoWrite;   /**< 不写入缓存的属性 */

- (id)initWithOutRecord;    /**< 初始化，不监听值 */

@end
