//
//  UserInfo.m
//  MainApp
//
//  Created by Kyo on 19/8/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo *userInfo = nil;



#pragma mark -----------------
#pragma mark - CycLice

+ (UserInfo *)sharedUserInfo
{
    if (userInfo == nil) {
        @synchronized(self){
            userInfo = [[UserInfo alloc] init];
        }
    }
    
    return userInfo;
}

#pragma mark -----------------
#pragma mark - Settings

- (void)setId:(NSInteger)Id {
    _Id = Id;
    
    self.userId = [NSString stringWithFormat:@"%tu",Id];
}

#pragma mark -----------------
#pragma mark - Methods

- (BOOL)isLogined
{
    return _Id > 0;
}

- (void)logout {
    NSDictionary *dictAllProperty = [KyoUtil getPropertyNameList:[self class]];
    if (!dictAllProperty && dictAllProperty.allKeys.count <= 0) {
        return;
    }
    
    NSMutableDictionary *dictKeyValues = [NSMutableDictionary dictionary];
    for (NSString *proterty in dictAllProperty.allKeys) {
        //登录名不删除
        if ([proterty isEqualToString:@"realLoginName"]) {
            continue;
        }
        NSString *protertyType = dictAllProperty[proterty];
        if ([protertyType rangeOfString:@"^T@" options:NSRegularExpressionSearch].location != NSNotFound) {
            [dictKeyValues setObject:[NSNull null] forKey:proterty];
        } else {
            [dictKeyValues setObject:[NSNumber numberWithInt:0] forKey:proterty];
        }
    }
    
    [self setKeyValues:dictKeyValues];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName_LogOutSuccess object:nil];
}

//是否绑定了手机号
- (BOOL)isBindingUserPhone {
    if (self.mobile &&
        [self.mobile isKindOfClass:[NSString class]] &&
        ![self.mobile isEqualToString:@""] &&
        ![self.mobile isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

// 是否绑定了邮箱
- (BOOL)isBindingUserMail{
    return self.authEmail;
}
@end
