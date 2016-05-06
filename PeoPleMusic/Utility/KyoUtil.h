//
//  KyoUtil.h
//  YWCat
//
//  Created by Kyo on 23/3/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "RootViewController.h"
#import "JMTabBarViewController.h"
#import "JMNavigationViewController.h"

@interface KyoUtil : NSObject


// Model
+ (NSString *)getModelKey:(NSString *)key withUppercase:(BOOL)upper;  //把key组转化成大小些
+ (NSString *)changeJsonStringToTrueJsonString:(NSString *)json; //把没有双引号和用了单引号的json字符串转化为标准格式字符串;
+ (NSDictionary *)changeJsonStringToDictionary:(NSString *)json; //把json字符串转化为字典
+ (NSArray *)changeJsonStringToArray:(NSString *)json;

//GestureRecognizer
+ (UITapGestureRecognizer *)addTagGesture:(id)targer performSelector:(SEL)selector withView:(id)view;
+ (UITapGestureRecognizer *)addTagGesture:(id)targer performSelector:(SEL)selector withView:(id)view withTapCount:(NSInteger)tapCount;

// MBProgressHUD
+ (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view;
+ (void)showLoadingHUD:(NSString *)labelTextOrNil inView:(UIView *)view withDelegate:(id<MBProgressHUDDelegate>)delegate userInteractionEnabled:(BOOL)userInteractionEnabled;
+ (void)hideLoadingHUD:(NSTimeInterval)afterTime withView:(UIView *)view;

// ShowDialogView
+ (CTBaseDialogView *)showDialogView:(UIView *)subview fromFrame:(CGRect)fromFrame;
+ (CTBaseDialogView *)showDialogView:(UIView *)subview animatedType:(CTAnimationType)animatedType;
+ (CTBaseDialogView *)showDialogView:(UIView *)subview animatedType:(CTAnimationType)animatedType fromFrame:(CGRect)fromFrame;

//root
+ (RootViewController *)rootViewController; //获取rootviewcontroller
+ (JMTabBarViewController *)getRootViewController;
+ (JMNavigationViewController *)getCurrentNavigationViewController;

// Find Focus Input View
+ (UIView *)findFocusInputView:(UIView *)view;
+ (BOOL)checkCanGoOn:(UIView *)view;

// Find Rect In Window
+ (CGRect)relativeFrameForScreenWithView:(UIView *)v;

// Stand User Default
+ (void)addUserDefault:(NSString *)key value:(id)value;
+ (void)removeUserDefault:(NSString *)key;
+ (id)getUserDefaultValue:(NSString *)key;

// Push

// Image

//通过字符串声称ciimage类型的二维码
+ (CIImage *)createQRForString:(NSString *)qrString;
//把ciimage转换成uiiamge格式
+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale;

//设备和应用
+ (NSString *)getAppstoreVersion; //获取当前应用的app store中的版本号
+ (NSString *)getAppKeyChar;   //获取唯一标识udid
//+ (void)goToAppStore;   //跳转到appstore升级或评论
+ (void)callPhoneWithNumber:(NSString *)number; //打电话
+ (void)setWebViewUserAgent:(NSString *)information;    //设置webview的UserAgent，在末尾加入information


//字符串处理
+ (NSString *)changeToNormalMoblie:(NSString *)moblie;  //除去手机中的－和+86
+ (NSString *)passwordSecurityLevel:(NSString *)password;   /**< 得到密码的安全级别（高中低） */

// runtime
+ (NSDictionary *)getPropertyNameList:(Class)class1; //根据class 得到所有属性
+ (Method *)geMethodNameList:(Class)class1 withCount:(NSInteger *)count;    //根据class 得到所有方法 Method

+ (void)addAssociatedWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value; //在目标target上添加关联对象，属性名propertyname(也能用来添加block)，值value
+ (id)getAssociatedValueWithTarget:(id)target withPropertyName:(NSString *)propertyName;  //获取目标target的指定关联对象值
+ (void)addIvarWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value; //在目标target上添加属性(已经存在的类不支持，可跳进去看注释)，属性名propertyname，值value
+ (id)getIvarValueWithTarget:(id)target withPropertyName:(NSString *)propertyName;  //获取目标target的指定属性值
+ (void)addPropertyWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value; //在目标target上添加属性，属性名propertyname，值value
+ (id)getPropertyValueWithTarget:(id)target withPropertyName:(NSString *)propertyName;  //获取目标target的指定属性值

@end
