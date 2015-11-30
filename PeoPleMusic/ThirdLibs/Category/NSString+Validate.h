//
//  NSString+Validate.h
//  JuMi
//
//  Created by Yang Gaofeng on 15/1/8.
//  Copyright (c) 2015年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRegex3_30EnglishOrNumber    @"^[a-zA-Z0-9]{3,30}$"  //3-30位英文或数字
#define kRegex6_16EnglishOrNumber    @"^[a-zA-Z0-9]{6,16}$"  //6-20位英文或数字
#define k1English   @"^[a-zA-Z]{1}$"  //1位英文


#define kRegex2_20EnglishOrNumber    @"^[a-zA-Z0-9]{2,20}$"  //2-20位英文或数字

#define kRegex4_38EnglishOrTrim    @"^[a-zA-Z]{1,1}[a-zA-Z ]{2,36}[a-zA-Z]{1,1}$"  //4-38位英文
#define kRegex2_38EnglishOrTrim    @"^[a-zA-Z]{1,1}[a-zA-Z ]{0,36}[a-zA-Z]{1,1}$"  //2-38位英文
#define kRegex2_50Chinese    @"[\\u4E00-\\u9FA5]{2,50}"    //2-50位中文
static NSString * const kRegexName = @"([\\u4E00-\\u9FA5]{2,50})|([a-zA-Z][a-zA-Z ]{2,36}[a-zA-Z])"; //2-50位中文或则4-38位英文
#define kRegex2_50ChineseOrEnglish    @"[\\u4E00-\\u9FA5a-zA-Z]{2,50}"    //3-50位中英文

#define kRegex2_Chinese      @"[0-9a-zA-Z\\u4E00-\\u9FA5]{2,}" //2中文及以上
#define kRegex6_Chinese      @"[0-9a-zA-Z\\u4E00-\\u9FA5]{6,}" //6中文及以上
#define kRegex2_ChineseAndEnglish    @"([0-9a-zA-Z\\u4E00-\\u9FA5]\\,*){2,}"   //2字符及以上
#define kRegex6Number        @"^[0-9]{6,6}$" //6位数字
#define kRegex1_2Number        @"^[\\d]{1,2}$"   //1-2位数字
#define kRegex1_6Number        @"^[\\d]{1,6}$"   //1-6位数字
#define kRegex2_20Number        @"^[\\d]{2,20}$"   //2-20位数字
#define kRegex1_6Number        @"^[\\d]{1,6}$"   //1-6位数字
#define kRegex10_30Number        @"^[\\d]{10,30}$"   //10-30位数字

#define kRegex11Phone        @"(\\+\\d+)?1[345789]\\d{9}$"   //11位手机号
#define kRegex6_20Phone        @"^[\\d]{6,20}$"   //6-20位电话号码
static NSString * const kRegexEmail = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";   //格式为***@***  的邮箱
//#define kRegexOtherCard        @"[a-zA-Z0-9\\u4E00-\\u9FA5]{3,}"   //其它证件或护照
#define kRegexTaiWanCard        @"^[A-Z0-9()]{3,30}$"   //台胞 //@"^[a-zA-Z]([0-9]{9})$"   //台胞
#define kRegex2_20Any        @"^.{2,20}$"
#define kRegex2_10Any        @"^.{2,10}$"
#define kRegex6_20Any        @"^.{6,20}$"
#define kRegexMin_MaxAny(_min, _max)        [NSString stringWithFormat:@"^.{%@,%@}$", _min, _max]
#define kRegex4_20Any        @"^[A-Za-z0-9_\\u4e00-\\u9fa5]{4,20}$"
#define kRegex_NotEmpty        @"^.{1,100}$"  //验证不为空
#define kRegex2_20ChineseOr4_20English  @"^([0-9A-Za-z\\u4e00-\\u9fa5_]{4,20})|([0-9A-Za-z_]{0,10}[\\u4e00-\\u9fa5]{2,20}[0-9A-Za-z_]{0,10})|(([\u4E00-\u9FA5]|[0-9A-Za-z_]{2}){2,10})|([\\u4e00-\\u9fa5]{1,10}[0-9A-Za-z_]{1,10}[\\u4e00-\\u9fa5]{1,10})$"  //4-20个字符或2－20个汉字
//
#define kRegex_CName        @"[\\u4E00-\\u9FA5a-zA-Z]{2,50}"   // 2位以上汉字或英文字母
#define kRegex_EName         @"^[a-zA-Z]{1,1}[a-zA-Z ]{0,36}[a-zA-Z]{1,1}$"  // 2-38位英文字母
#define kRegex_Address        @"^.{5,50}$"  // 5到50个字
#define kRegex_Post        @"^[0-9]{6,6}$"  //6位数字
#define KRegex_Email      @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"  //格式为***@***  的邮箱

@interface NSString (Validate)

- (BOOL)isValidateMobile;
- (BOOL)isValidateEmail;
- (BOOL)isValidatePassword;
// 姓名只能为2位以上汉字或英文字母
- (BOOL)isValidateCName;
// 2-38位英文字母
- (BOOL)isValidateEName;
// 5到50个字
- (BOOL)isValidateAddress;
- (BOOL)isValidatePost;
//用户名验证（6-16位数字或字母，字母开头）
-(BOOL)isValidateUseName;
-(BOOL)isValidateUseName2;
//- (BOOL)chk18PaperId:(NSString *) sPaperId;
//姓名
- (BOOL)isValidateFullName;

- (BOOL)isValidateText;

- (BOOL)isMatchedByRegex:(NSString *)pattern;

- (NSUInteger)indexOf:(NSString *)text;

-(BOOL)verifyIDCardNumber:(NSString *)value;    //身份证验证

+ (NSString *)replaceRegexCharToNormal:(NSString *)str; //把str中跟正则相同的特殊字符加上\，变成正常字符

@end
