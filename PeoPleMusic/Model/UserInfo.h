//
//  UserInfo.h
//  MainApp
//
//  Created by Kyo on 19/8/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "BasicsUserInfo.h"


@interface UserInfo : BasicsUserInfo

@property (nonatomic, strong) NSString *session;  //用户登录后得到的seesion
@property (nonatomic, strong) NSString *loginName; //－－－新用户这里存得其实是手机号
@property (nonatomic, strong) NSString *loginPassWord;
@property (nonatomic, assign) BOOL authEmail;
@property (nonatomic, assign) BOOL authMobile;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, assign) NSInteger bigRegisteredSource;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * fullName;
@property (nonatomic, strong) NSObject * iP;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) NSInteger isActive;
@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, strong) NSString * lastLoginTime;
@property (nonatomic, assign) NSInteger loginCount;

@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * previousTime;
@property (nonatomic, assign) NSInteger registeredSource;
@property (nonatomic, strong) NSString * registeredSourceKey;
@property (nonatomic, assign) NSInteger safeLevel;
@property (nonatomic, strong) NSObject * saltKey;
@property (nonatomic, strong) NSString * weiXinRegisteredSourceKey;

/**个人信息－－会员详细信息*/
@property (nonatomic, assign) NSInteger customerId;  // 客户Id
@property (nonatomic, assign) NSInteger level;   // 会员等级
@property (nonatomic, assign) NSInteger passwordSafeLevel; // 登录密码安全等级，0-未设置密码或未知,1-低,2-中,3-高
@property (nonatomic, assign) NSInteger accountSafeLevel;  // 账户安全等级，1-低，2-中，3-高
@property (nonatomic, assign) NSInteger growth;  // 成长值
@property (nonatomic, assign) NSInteger levelMaxGrowth;   // 下一级最小成长值
@property (nonatomic, assign) NSInteger  policyAmount;
@property (nonatomic, assign) NSInteger policyCount;// 保单数量
@property (nonatomic, assign) NSInteger favoriteCount; // 收藏数量
@property (nonatomic, strong) NSString * avatar;  // 头像文件URL
@property (nonatomic, assign) NSInteger footercout;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, assign) NSInteger freezeGiveGold;
@property (nonatomic, assign) NSInteger freezeGold;
@property (nonatomic, assign) NSInteger gold;
@property (nonatomic, assign) float owed;
@property (nonatomic, strong) NSArray * privilege;

@property (strong, nonatomic) NSString *realLoginName;




+ (UserInfo *)sharedUserInfo;
- (BOOL)isLogined;  //是否已经登录
- (void)logout; //退出登录
- (BOOL)isBindingUserPhone; //是否绑定了手机号
- (BOOL)isBindingUserMail;  // 是否绑定了邮箱
@end
