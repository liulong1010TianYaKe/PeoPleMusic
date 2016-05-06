//
//  UserInfo.h
//  MainApp
//
//  Created by Kyo on 19/8/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "BasicsUserInfo.h"
#import "DeviceVodBoxModel.h"


@interface UserInfo : BasicsUserInfo

@property (nonatomic, strong) NSString *token;  //用户登录后得到的令牌

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, strong) NSString *memberName; //－账户名
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * lastLoginTime; // 最后上线时间
@property (nonatomic, strong) NSString * regesterTime;
@property (nonatomic, strong) NSString * isShopper; // 否是代购员0-否 1-是
@property (nonatomic, strong) NSString * isAuth; // 否实名认证0-否 1-是
@property (nonatomic, strong) NSObject * memberHead; // 头像url
@property (nonatomic, strong) NSString *loginId; //  登录帐号，可以是email/phone/memberName
@property (nonatomic, strong) NSString *password; // 密码

@property (nonatomic, strong) NSString *userId;

@property (nonatomic,strong) DeviceVodBoxModel *deviceVodBoxModel;// 当前连接的音响



+ (UserInfo *)sharedUserInfo;
- (BOOL)isLogined;  //是否已经登录
- (void)logout; //退出登录
- (BOOL)isBindingUserPhone; //是否绑定了手机号
- (BOOL)isBindingUserMail;  // 是否绑定了邮箱
@end
