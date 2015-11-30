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


/*
 状态码列表
 
 [Description("操作成功")]
 Success=0,
 [Description("通用错误使用编码，代表错误信息从Msg中获取，不用额外处理")]
 CommonError = 9999,
 [Description("签名错误")]
 IllegalSign = 9998,
 
 [Description("未登录")]
 NotLogin=1001,
 [Description("没有权限")]
 NotRight=1002,
 [Description("超过最大购买份数")]
 MaxBuyCount = 2001,
 [Description("已经购买过")]
 HasBuy = 2002,
 [Description("超过最大保额")]
 HighSumInsured = 2003,
 [Description("没有健康告知")]
 NotNotify = 2004,
 
 [Description("所选择的试算条件不在范围内")]
 NoPrice = 2005,
 [Description("需要登录")]
 NeedLogin=3000,
 [Description("订单不存在！")]
 NoOrder=3001,
 [Description("创建订单失败，请稍后重试！")]
 CreateOrderFalse=3002,
 [Description("很抱歉，订单中包含已经支付的投保单，不能重复支付！")]
 HavePay=3003,
 [Description("很抱歉，您提交的支付中包含已经删除的投保单！")]
 HaveDeleted=3004,
 [Description("很抱歉，目前该单暂时无法在移动端使用在线方式支付！")]
 NOTBuy = 3005,
 [Description("很抱歉，您提交的订单无法使用在线方式支付！")]
 NoOnlineBuy=3006,
 [Description("很抱歉，订单中包含已经下架的产品，请返回刷新页面！")]
 ProductNoPublish=3007,
 [Description("很抱歉，订单中包含已经过期的投保单，请核对后提交！")]
 InsureDatePass=3008,
 [Description("很抱歉，订单中有产品价格已经变更，您需要返回产品页面重新投保！")]
 PriceChange=3009,
 [Description("被保险人购买份数超过最大份数！")]
 MaxBuy=3010,
 [Description("投保单中被保险人意外伤害的保额大于保险公司设定的额度！")]
 HighSum=3012,
 [Description("非法的订单")]
 NotUser=3013,
 [Description("不能重复购买")]
 NotBuyAgain=4001
 */
    