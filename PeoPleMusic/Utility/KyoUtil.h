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

// network
+ (void)clearOperation:(AFHTTPRequestOperation *)operation; //清空指定网络请求

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
+ (BOOL)currentPushSwitch;  //得到当前是否开启了推送
+ (void)changePushSwitch:(BOOL)isOpen;  //改变推送是否开启

// Image
+ (UIImage *)getImageFromView:(UIView *)fromView useScreenScale:(BOOL)use useNewMethod:(BOOL)useNewMethod;  //根据uiview得到图像
+ (UIImage *)getImageFormImage:(UIImage *)fromView withRect:(CGRect)rect useScreenScale:(BOOL)use;  //根据图像和尺寸截剪图片
+ (NSArray *)getSplitImageListWithImage:(UIImage *)image withCount:(NSInteger)count;    //根据图像和分隔的总等份分隔图像
+ (UIImage*)compoundImageWithSize:(CGSize)imageSize
                    withMainImage:(UIImage *)MainImage
                withMainImageRect:(CGRect)mainImageRect
                     withSubImage:(UIImage *)subImage
                 withSubImageRect:(CGRect) subImageRect;    //图像合并成一张
//缩小图片，根据传入kb和image
+ (UIImage *)getScaleImageWithByteSize:(long)byteSize withImage:(UIImage *)image;
//缩小图片，根据传入kb和image，返回缩小后的图片和data
+ (UIImage *)getScaleImageWithByteSize:(long)byteSize withImage:(UIImage *)image receiveImageData:(NSData **)dataImage;
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

// Area
+ (NSArray *)getProvinceArray;
//字符串处理
+ (NSString *)changeToNormalMoblie:(NSString *)moblie;  //除去手机中的－和+86
+ (NSString *)passwordSecurityLevel:(NSString *)password;   /**< 得到密码的安全级别（高中低） */

// runtime
+ (NSDictionary *)getPropertyNameList:(Class)class1; //根据class 得到所有属性
+ (Method *)geMethodNameList:(Class)class1 withCount:(NSInteger *)count;    //根据class 得到所有方法 Method
+ (void)clearAllNetworkOperationWithProperty:(id)target;    //清空target的网络操作属性（前提是target有_dictCustomerProperty）
+ (void)clearAllProperty:(id)object;  //根据传入的object把其属性都设置为空
+ (NSUInteger)getAllBytesWithObject:(id)object;  //根据传入的object得到其所有属性的大小
+ (void)addAssociatedWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value; //在目标target上添加关联对象，属性名propertyname(也能用来添加block)，值value
+ (id)getAssociatedValueWithTarget:(id)target withPropertyName:(NSString *)propertyName;  //获取目标target的指定关联对象值
+ (void)addIvarWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value; //在目标target上添加属性(已经存在的类不支持，可跳进去看注释)，属性名propertyname，值value
+ (id)getIvarValueWithTarget:(id)target withPropertyName:(NSString *)propertyName;  //获取目标target的指定属性值
+ (void)addPropertyWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value; //在目标target上添加属性，属性名propertyname，值value
+ (id)getPropertyValueWithTarget:(id)target withPropertyName:(NSString *)propertyName;  //获取目标target的指定属性值

@end
