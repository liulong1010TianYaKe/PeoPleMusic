//
//  YYInfoResult.h
//  login
//
//  Created by hzins on 14-9-28.
//  Copyright (c) 2014年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNetworkKeyState    @"State"
#define kNetworkKeyMsg    @"Msg"
#define kNetworkKeyData    @"Data"

@interface NetworkResultModel : NSObject

@property(nonatomic, strong)NSString *State;    /**< 返回状态码 */
@property(nonatomic, strong)NSString *Msg;  /**< 返回的提示信息 */
@property(nonatomic, strong)id Data;    /**< 返回处理数据（Json字符串）  */

@end

    