//
//  KyoUtil.m
//  YWCat
//
//  Created by Kyo on 23/3/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoUtil.h"
#import "SSKeychain.h"
#import "NSString+Convert.h"

@interface KyoUtil ()
@property (nonatomic, strong) MBProgressHUD *HUD;
@end
@implementation KyoUtil

#pragma mark -----------------------
#pragma mark - Network

//清空指定网络请求
+ (void)clearOperation:(AFHTTPRequestOperation *)operation {
    if (operation && !operation.isFinished) {
        [operation cancel];
    }
    
    operation = nil;
}

#pragma mark -----------------------
#pragma mark -  Model Key

+ (NSString *)getModelKey:(NSString *)key withUppercase:(BOOL)upper {
    NSString *result = nil;
    
    if (upper) {
        result = [NSString stringWithFormat:@"%@%@", [[key substringToIndex:1] uppercaseString], [key substringFromIndex:1]];
    } else {
        result = [NSString stringWithFormat:@"%@%@", [[key substringToIndex:1] lowercaseString], [key substringFromIndex:1]];
    }
    
    return result;
}

//把没有双引号和用了单引号的json字符串转化为标准格式字符串;
+ (NSString *)changeJsonStringToTrueJsonString:(NSString *)json
{
    // 将没有双引号的替换成有双引号的
    NSString *validString = [json stringByReplacingOccurrencesOfString:@"(\\w+)\\s*:([^A-Za-z0-9_])"
                                                            withString:@"\"$1\":$2"
                                                               options:NSRegularExpressionSearch
                                                                 range:NSMakeRange(0, [json length])];
    
    
    //把'单引号改为双引号"
    validString = [validString stringByReplacingOccurrencesOfString:@"([:\\[,\\{])'"
                                                         withString:@"$1\""
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, [validString length])];
    validString = [validString stringByReplacingOccurrencesOfString:@"'([:\\],\\}])"
                                                         withString:@"\"$1"
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, [validString length])];
    
    //再重复一次 将没有双引号的替换成有双引号的
    validString = [validString stringByReplacingOccurrencesOfString:@"([:\\[,\\{])(\\w+)\\s*:"
                                                         withString:@"$1\"$2\":"
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, [validString length])];
    return validString;
}

//把json字符串转化为字典
+ (NSDictionary *)changeJsonStringToDictionary:(NSString *)json
{
    
    if (!json || ![json isKindOfClass:[NSString class]]) {
        return @{};
    }
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return dictData;
}

//把json字符串转化为数组
+ (NSArray *)changeJsonStringToArray:(NSString *)json
{
    if (!json || ![json isKindOfClass:[NSString class]]) {
        return @[];
    }
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *arrayData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return arrayData;
}

#pragma mark -----------------------
#pragma mark - GestureRecognizer

+ (UITapGestureRecognizer *)addTagGesture:(id)targer performSelector:(SEL)selector withView:(id)view
{
    return [self addTagGesture:targer performSelector:selector withView:view withTapCount:1];
}


+ (UITapGestureRecognizer *)addTagGesture:(id)targer performSelector:(SEL)selector withView:(id)view withTapCount:(NSInteger)tapCount
{
    UITapGestureRecognizer *tapSing = [[UITapGestureRecognizer alloc] initWithTarget:targer action:selector];
    tapSing.numberOfTapsRequired = tapCount;   //设置轻击数量
    tapSing.delegate = targer;
    tapSing.cancelsTouchesInView = NO;
    [view addGestureRecognizer:tapSing];
    return tapSing;
}

#pragma mark -----------------------
#pragma mark - MBProgressHUD

static char kMBProgressHUDKey;
static char kMBProgressHUDMessageKey;

+ (void)showMessageHUD:(NSString *)messageText withTimeInterval:(NSTimeInterval)delayTime inView:(UIView *)view
{
    MBProgressHUD *HUD = (MBProgressHUD *)objc_getAssociatedObject(view, &kMBProgressHUDMessageKey);
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:HUD];
    }
    
    HUD.labelText = messageText;
    HUD.mode = MBProgressHUDModeText;
    HUD.userInteractionEnabled = NO;
    HUD.removeFromSuperViewOnHide = NO;
    
    [HUD hide:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD show:YES];
        [HUD hide:YES afterDelay:delayTime];
    });
    
    objc_setAssociatedObject(view, &kMBProgressHUDMessageKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)showLoadingHUD:(NSString *)labelTextOrNil inView:(UIView *)view withDelegate:(id<MBProgressHUDDelegate>)delegate userInteractionEnabled:(BOOL)userInteractionEnabled {
    MBProgressHUD *loadingHUD = (MBProgressHUD *)objc_getAssociatedObject(view, &kMBProgressHUDKey);
    if (!loadingHUD) {
        loadingHUD = [[MBProgressHUD alloc] initWithView:view];
        loadingHUD.delegate = delegate;
        loadingHUD.mode = MBProgressHUDModeIndeterminate;
        loadingHUD.dimBackground = YES;
        [view addSubview:loadingHUD];
    }
    
    if (labelTextOrNil.length > 0) {
        loadingHUD.labelText = labelTextOrNil;
    }
    
    loadingHUD.userInteractionEnabled = userInteractionEnabled;
    
    [loadingHUD show:YES];
    
    objc_setAssociatedObject(view, &kMBProgressHUDKey, loadingHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)hideLoadingHUD:(NSTimeInterval)afterTime withView:(UIView *)view
{
    MBProgressHUD *loadingHUD = (MBProgressHUD *)objc_getAssociatedObject(view, &kMBProgressHUDKey);
    [loadingHUD hide:YES afterDelay:afterTime];
}

#pragma mark - Show DialogView

+ (CTBaseDialogView *)showDialogView:(UIView *)subview fromFrame:(CGRect)fromFrame
{
    return [self showDialogView:subview animatedType:CTAnimationTypeUnwind fromFrame:fromFrame];
}

+ (CTBaseDialogView *)showDialogView:(UIView *)subview animatedType:(CTAnimationType)animatedType {
    CTBaseDialogView *dialogView = [self showDialogView:subview animatedType:animatedType fromFrame:CGRectZero];
    if (animatedType == CTAnimationTypeDownToUp || animatedType == CTAnimationTypeUpToDown) {
        dialogView.isNoReposeWhenBackgroundTouched = YES;
    }
    return dialogView;
}

+ (CTBaseDialogView *)showDialogView:(UIView *)subview animatedType:(CTAnimationType)animatedType fromFrame:(CGRect)fromFrame
{
    CTBaseDialogView *dialogView = [[CTBaseDialogView alloc] initWithSubView:subview animation:animatedType fromFrame:fromFrame];
    dialogView.isNoNeedCloseBtn = YES;
    [dialogView show];
    
    return dialogView;
}

#pragma mark -----------------------
#pragma mark - Root

//获取rootviewcontroller
+ (RootViewController *)rootViewController
{
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if ([viewController isKindOfClass:[RootViewController class]]) {
        return (RootViewController *)viewController;
    }else {
        return nil;
    }
}

+ (JMTabBarViewController *)getRootViewController
{
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if ([viewController isKindOfClass:[RootViewController class]]) {
        return ((RootViewController *)viewController).tabBarViewController;
    } else if ([viewController isKindOfClass:[JMTabBarViewController class]]) {
        return (JMTabBarViewController *)viewController;
    } else {
        return nil;
    }
}

+ (JMNavigationViewController *)getCurrentNavigationViewController
{
    JMTabBarViewController *tabViewController = [self getRootViewController];
    if (tabViewController) {
        UIViewController *viewController = tabViewController.selectedViewController;
        if ([viewController isKindOfClass:[JMNavigationViewController class]]) {
            return (JMNavigationViewController *)viewController;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

#pragma mark -----------------------
#pragma mark - Find Focus Input View

+ (UIView *)findFocusInputView:(UIView *)view
{
    if ([KyoUtil checkCanGoOn:view]) {
        for (int i = 0; i < view.subviews.count; i++) {
            UIView *subview = [view.subviews objectAtIndex:i];
            if ([subview isKindOfClass:[UITextField class]] ||
                [subview isMemberOfClass:[UITextField class]]) {
                if ([subview isFirstResponder]) {
                    return subview;
                }
            }else if ([subview isKindOfClass:[UITextView class]] ||
                      [subview isMemberOfClass:[UITextView class]]){
                if ([subview isFirstResponder]) {
                    return subview;
                }
            }else if ([self checkCanGoOn:subview]){
                UIView *focusView = [KyoUtil findFocusInputView:subview];
                if (focusView) {
                    return focusView;
                }
            }
        }
    }
    
    return nil;
}

+ (BOOL)checkCanGoOn:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]] || [view isMemberOfClass:[UIButton class]]) {
        return NO;
    }
    if ([view isKindOfClass:[UIImageView class]] || [view isMemberOfClass:[UIImageView class]]) {
        return NO;
    }
    
    return (view.subviews ? YES : NO);
}

#pragma mark -----------------------
#pragma mark - Find Rect In Window

+ (CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    CGFloat screenHeight = kWindowHeight;
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while ((kSystemVersionMoreThan8 && !kSystemVersionMoreThan8_1) ? view.frame.size.height != kWindowWidth || view.frame.size.width != screenHeight : view.frame.size.width != kWindowWidth || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        if (!view.superview) {   //如果没有父视图，则返回cgrectzero
            return CGRectZero;
        }
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}

#pragma mark -----------------------
#pragma mark - Stands User Default

+ (void)addUserDefault:(NSString *)key value:(id)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserDefault:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getUserDefaultValue:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

#pragma mark - Push

//得到当前是否开启了推送
+ (BOOL)currentPushSwitch {
    NSString *pushSwitch = [self getUserDefaultValue:@"kUserDefaultPushSwitch"];
    if (!pushSwitch || [pushSwitch boolValue]) {
        return YES;
    } else {
        return NO;
    }
}

//改变推送是否开启
+ (void)changePushSwitch:(BOOL)isOpen {
    [self addUserDefault:@"kUserDefaultPushSwitch" value:[NSString stringWithFormat:@"%d", isOpen]];
}

#pragma mark -----------------------
#pragma mark - Image

//根据uiview得到图像
+ (UIImage *)getImageFromView:(UIView *)fromView useScreenScale:(BOOL)use useNewMethod:(BOOL)useNewMethod
{
    UIImage *viewImage = nil;
    
    if (kSystemVersionMoreThan7 && useNewMethod) {
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, NO, kScreenScale);
        [fromView drawViewHierarchyInRect:fromView.bounds afterScreenUpdates:NO];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        NSInteger scale = use ? kScreenScale : 1;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(fromView.bounds.size.width, fromView.bounds.size.height), NO, scale);
        [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    
    return viewImage;
}

//根据图像和尺寸截剪图片
+ (UIImage *)getImageFormImage:(UIImage *)fromView withRect:(CGRect)rect useScreenScale:(BOOL)use
{
    NSInteger scale = use ? kScreenScale : 1;
    CGRect scaleRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale); //得到剪切部分的图片的scale后的rect
    CGImageRef imageRef = CGImageCreateWithImageInRect([fromView CGImage], scaleRect);
    UIImage *avatarImage = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CFRelease(imageRef);
    return avatarImage;
}

//根据图像和分隔的总等份分隔图像
+ (NSArray *)getSplitImageListWithImage:(UIImage *)image withCount:(NSInteger)count
{
    CGFloat height = image.size.height / count;
    NSMutableArray *arrayImage = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        UIImage *imgSplit = [self getImageFormImage:image withRect:CGRectMake(0, i*height, image.size.width, height) useScreenScale:NO];
        [arrayImage addObject:imgSplit];
    }
    return arrayImage;
}

//图像合并成一张
+ (UIImage*)compoundImageWithSize:(CGSize)imageSize
                    withMainImage:(UIImage *)MainImage
                withMainImageRect:(CGRect)mainImageRect
                     withSubImage:(UIImage *)subImage
                 withSubImageRect:(CGRect) subImageRect
{
    UIGraphicsBeginImageContextWithOptions(imageSize,NO,[UIScreen mainScreen].scale);
    
    [MainImage drawInRect:mainImageRect];
    [subImage drawInRect:subImageRect];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//缩小图片，根据传入kb和image
+ (UIImage *)getScaleImageWithByteSize:(long)byteSize withImage:(UIImage *)image {
    return [KyoUtil getScaleImageWithByteSize:byteSize withImage:image receiveImageData:nil];
    
}

//缩小图片，根据传入kb和image，返回缩小后的图片和data
+ (UIImage *)getScaleImageWithByteSize:(long)byteSize withImage:(UIImage *)image receiveImageData:(NSData **)dataImage {
    if (!image) {
        return image;
    }
    
    //如果超过，则缩小分辨率
    UIImage *tempImage = nil;
    NSData *data = UIImageJPEGRepresentation(image, 1);
    if (data.length > byteSize) {
        float i = (float)byteSize / (float)data.length;
        i = sqrt(i);    //根号
        tempImage = [UIImage imageWithData:data];
        tempImage = [UIImage imageCompressForSize:tempImage targetSize:CGSizeMake(tempImage.size.width * i, tempImage.size.height * i)];
        data = UIImageJPEGRepresentation(tempImage, 1);
    } else {
        return [UIImage imageWithData:data];
    }
    
    //减小画质
    while (data.length >= byteSize) {
        float i = (float)byteSize / (float)data.length;
        data = UIImageJPEGRepresentation(tempImage, i);
        i = i * 0.8;
        if (i < 0.1) {
            break;
        }
    }
    
    if (dataImage) {
        *dataImage = data;
    }
    return [UIImage imageWithData:data];
}

//通过字符串声称ciimage类型的二维码
+ (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"L" forKey:@"inputCorrectionLevel"];    //复杂程度等级（L代表低，H代表高度复杂）
    
    // Send the image back
    return qrFilter.outputImage;
}

//把ciimage转换成uiiamge格式
+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale {
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    // Need to set the image orientation correctly
    UIImage *flippedImage = [UIImage imageWithCGImage:[scaledImage CGImage]
                                                scale:scaledImage.scale
                                          orientation:UIImageOrientationDownMirrored];
    
    return flippedImage;
}

#pragma mark ----------------------
#pragma mark - Device and App

//获取当前应用的app store中的版本号
+ (NSString *)getAppstoreVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleShortVersionString"];
}

//获取唯一标识udid
+ (NSString *)getAppKeyChar
{
    NSString *openUDID = [KyoUtil getUserDefaultValue:kUserDefaultKey_KeyChar];
    if (!openUDID) {
        
        
        [KyoUtil addUserDefault:kUserDefaultKey_KeyChar value:openUDID];
    }
    
    static NSString *keyChar;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        keyChar = [KyoUtil getUserDefaultValue:kUserDefaultKey_KeyChar];
        if (!keyChar) { //如果没有记录在userdefault里面,则从keychar获取
            keyChar = [SSKeychain passwordForService:@"com.keeds.KidBook"account:@"uuid"];
            
            if (keyChar == nil || [keyChar isEqualToString:@""]) {  //如果keychar没有，则创建
                CFUUIDRef uuid = CFUUIDCreate(NULL);
                assert(uuid != NULL);
                CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
                keyChar = [NSString stringWithFormat:@"%@", uuidStr];
                [SSKeychain setPassword: keyChar
                             forService:@"com.keeds.KidBook"account:@"uuid"];
            }
            
            //把keychar转换成10进制字符串
            NSArray *arraySplit = [keyChar componentsSeparatedByString:@"-"];
            if (arraySplit.count > 0) {
                NSString *decimalKeyChar = @"";
                for (NSString *hex in arraySplit) {
                    decimalKeyChar = [decimalKeyChar stringByAppendingString:[hex changeToDecimalFromHex]];
                }
                KyoLog(@"打印出拼接后的十进制字符串:%@",decimalKeyChar);
                keyChar = decimalKeyChar;
            }
            
            [KyoUtil addUserDefault:kUserDefaultKey_KeyChar value:keyChar];
        }
    });
    
    return keyChar;
}

//跳转到appstore
//+ (void)goToAppStore
//{
//    NSURL *urlIOS6 = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", kAppStoreID]];
//    NSURL *urlIOS7 = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/%@/app/id%@",NSLocalizedString(@"AppStoreCode", @"cn"), kAppStoreID]];
//
//    if ([[UIApplication sharedApplication] canOpenURL:urlIOS6]) {
//        [[UIApplication sharedApplication] openURL:urlIOS6];
//    } else if ([[UIApplication sharedApplication] canOpenURL:urlIOS7]) {
//        [[UIApplication sharedApplication] openURL:urlIOS7];
//    }
//}

//打电话
+ (void)callPhoneWithNumber:(NSString *)number
{
    static UIWebView *phoneWebView = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    });
    
    //打电话
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
    [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

//设置webview的UserAgent，在末尾加入information
+ (void)setWebViewUserAgent:(NSString *)information {
    @try {
        //不让程序执行多次，每次创建uiwebview耗费性能
        static int i = 0;
        if (i != 0) {
            return;
        } else {
            i++;
        }
        // 获取 iOS 默认的 UserAgent，可以很巧妙地创建一个空的UIWebView来获取：
        NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *customUserAgent = @"";
        if (!information || [information isEqualToString:@""]) {
            // 如果不需要本地化的App名称，可以使用下面这句
            NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            customUserAgent = [userAgent stringByAppendingFormat:@" mainApp/%@", version];
        } else {
            customUserAgent = [userAgent stringByAppendingString:information];
        }
        
        if ([userAgent rangeOfString:customUserAgent].location == NSNotFound) {
            [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
        }
    }
    @catch (NSException *exception) {}
}

#pragma mark -----------------------
#pragma mark - Area
+ (NSArray *)getProvinceArray {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"txt"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
    
    return [NSClassFromString(@"Province") objectArrayWithKeyValuesArray:jsonObject];
//    return [KyoUtil getModelArray:jsonObject withClass:@"Province" modelKey:nil];
}

#pragma mark -----------------------
#pragma mark - String

//除去手机中的－和+86
+ (NSString *)changeToNormalMoblie:(NSString *)moblie {
    if (!moblie || (id)moblie == [NSNull null] || ![moblie isKindOfClass:[NSString class]]) {
        return @"";
    } else {
        moblie = [moblie stringByReplacingOccurrencesOfString:@"-" withString:@""]; //去掉-
        moblie = [moblie stringByReplacingOccurrencesOfString:@" " withString:@""]; //去掉空格
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:
                                                  @"\\+[0-9]+" options:0 error:nil];   //去掉+86等任何国家前缀
        moblie = [regularExpression stringByReplacingMatchesInString:moblie options:0 range:NSMakeRange(0, moblie.length) withTemplate:@""]; //正则替换
        regularExpression = [NSRegularExpression regularExpressionWithPattern:
                             @"^86" options:0 error:nil];   //去掉86开头等任何国家前缀
        moblie = [regularExpression stringByReplacingMatchesInString:moblie options:0 range:NSMakeRange(0, moblie.length) withTemplate:@""]; //正则替换
        return moblie;
    }
}

/**< 得到密码的安全级别（高中低） */
+ (NSString *)passwordSecurityLevel:(NSString *)password {
    NSString *tip = kSecurityLevelDefaultTip;
    if ([password isMatchedByRegex:@"^[a-z]{1,100}$|^[A-Z]{1,100}$|^[0-9]{1,100}$|^[^0-9A-Za-z]{1,100}$"]) {
        tip = [tip stringByAppendingString:@"低"];
    } else if ([password isMatchedByRegex:@"^[a-zA-Z]{1,100}$|^[A-Z0-9]{1,100}$|^[a-z0-9]{1,100}$|^((?=[\x21-\x7e]+)[^A-Z0-9]){1,100}$|^((?=[\x21-\x7e]+)[^a-z0-9]){1,100}$|^((?=[\x21-\x7e]+)[^A-Za-z]){1,100}$"]) {
        tip = [tip stringByAppendingString:@"中"];
    } else {
        tip = [tip stringByAppendingString:@"高"];
    }
    
    return tip;
}

#pragma mark -----------------------
#pragma mark - runtime

+ (NSDictionary *)getPropertyNameList:(Class)class
{
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    NSMutableDictionary *propertyNameDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char *propertyAttributes = property_getAttributes(properties[i]);
        const char *propertyName = property_getName(properties[i]);
        
        [propertyNameDictionary setObject:[NSString stringWithUTF8String: propertyAttributes] forKey:[NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    
    
    return propertyNameDictionary;
}

//根据class 得到所有方法 Methods
+ (Method *)geMethodNameList:(Class)class withCount:(NSInteger *)count;
{
    u_int               all;
    Method *methods = class_copyMethodList([UIView class], &all);
    *count = all;
    return methods;
}

//清空target的网络操作属性（前提是target有_dictCustomerProperty）
+ (void)clearAllNetworkOperationWithProperty:(id)target
{
    NSDictionary *dictProperty = [KyoUtil getPropertyNameList:[target class]];
    
    for (int i = 0; i < dictProperty.allKeys.count; i++) {
        NSString *key = dictProperty.allKeys[i];
        NSString *value = [dictProperty objectForKey:key];
        if ([value rangeOfString:@"AFHTTPRequestOperation"].location != NSNotFound) {  //说明是网络请求属性
            AFHTTPRequestOperation *operation = [target valueForKey:key];
            if (operation && !operation.isFinished) {
                [operation cancel];
            }
            operation = nil;
        }
    }
    
    //删除所有关联对象
//    objc_removeAssociatedObjects(viewController);
}

//根据传入的object把其属性都设置为空
+ (void)clearAllProperty:(id)object
{
    NSDictionary *dictProperty = [KyoUtil getPropertyNameList:[object class]];
    
    for (int i = 0; i < dictProperty.allKeys.count; i++) {
        NSString *key = dictProperty.allKeys[i];
        [object setValue:nil forKey:key];
    }
}

//根据传入的object得到其所有属性的大小
+ (NSUInteger)getAllBytesWithObject:(id)object
{
    static NSString * const kSerializeGetAllBytes = @"kSerializeGetAllBytes";
    NSMutableData *dataArchiver = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArchiver];
    [archiver encodeObject:object forKey:kSerializeGetAllBytes];
    [archiver finishEncoding];
    
    return dataArchiver.length;
}


#pragma mark - runtime动态添加属性详解
/*
Ivar的方法不能在已有的class上面添加属性，不然Ivar是最好的办法

Associated可以关联属性或对象，但是不能递归得到所有关联的key，只有一个remove，把所有关联取消
由于网络请求还在跑着，所以只取消关联不行，需要把网络请求清空

Property可以说是上面的综合，可以在已有class加属性，也能递归得到属性，只是get和set方法需要自己写，
而且值夜需要自己去存储，就比如说这里，我在BasicsViewController里面添加了一个_dictCustomerProperty用来存储值。
*/

//在目标target上添加关联对象，属性名propertyname(也能用来添加block)，值value
+ (void)addAssociatedWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value {
    id property = objc_getAssociatedObject(target, &propertyName);
    
    if(property == nil)
    {
        property = value;
        objc_setAssociatedObject(target, &propertyName, property, OBJC_ASSOCIATION_RETAIN);
    }
}

//获取目标target的指定关联对象值
+ (id)getAssociatedValueWithTarget:(id)target withPropertyName:(NSString *)propertyName {
    id property = objc_getAssociatedObject(target, &propertyName);
    return property;
}

//在目标target上添加属性(已经存在的类不支持，可跳进去看注释)，属性名propertyname，值value
+ (void)addIvarWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value {
    if (class_addIvar([target class], [propertyName UTF8String], sizeof(id), log2(sizeof(id)), "@")) {
        KyoLog(@"创建属性Ivar成功");
    }
}

//获取目标target的指定属性值
+ (id)getIvarValueWithTarget:(id)target withPropertyName:(NSString *)propertyName {
    Ivar ivar = class_getInstanceVariable([target class], [propertyName UTF8String]);
    if (ivar) {
        id value = object_getIvar(target, ivar);
        return value;
    } else {
        return nil;
    }
}

//在目标target上添加属性，属性名propertyname，值value
+ (void)addPropertyWithtarget:(id)target withPropertyName:(NSString *)propertyName withValue:(id)value {
    
    //先判断有没有这个属性，没有就添加，有就直接赋值
    Ivar ivar = class_getInstanceVariable([target class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
    if (ivar) {
        return;
    }
    
    /*
     objc_property_attribute_t type = { "T", "@\"NSString\"" };
     objc_property_attribute_t ownership = { "C", "" }; // C = copy
     objc_property_attribute_t backingivar  = { "V", "_privateName" };
     objc_property_attribute_t attrs[] = { type, ownership, backingivar };
     class_addProperty([SomeClass class], "name", attrs, 3);
     */
    
    //objc_property_attribute_t所代表的意思可以调用getPropertyNameList打印，大概就能猜出
    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([value class])] UTF8String] };
    objc_property_attribute_t ownership = { "&", "N" };
    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", propertyName] UTF8String] };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    if (class_addProperty([target class], [propertyName UTF8String], attrs, 3)) {
        
        //添加get和set方法
        class_addMethod([target class], NSSelectorFromString(propertyName), (IMP)getter, "@@:");
        class_addMethod([target class], NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]]), (IMP)setter, "v@:@");
        
        //赋值
        [target setValue:value forKey:propertyName];
        NSLog(@"%@", [target valueForKey:propertyName]);
        
        KyoLog(@"创建属性Property成功");
    } else {
        class_replaceProperty([target class], [propertyName UTF8String], attrs, 3);
        //添加get和set方法
        class_addMethod([target class], NSSelectorFromString(propertyName), (IMP)getter, "@@:");
        class_addMethod([target class], NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]]), (IMP)setter, "v@:@");
        
        //赋值
        [target setValue:value forKey:propertyName];
    }
}

id getter(id self1, SEL _cmd1) {
    NSString *key = NSStringFromSelector(_cmd1);
    Ivar ivar = class_getInstanceVariable([self1 class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
    NSMutableDictionary *dictCustomerProperty = object_getIvar(self1, ivar);
    return [dictCustomerProperty objectForKey:key];
}

void setter(id self1, SEL _cmd1, id newValue) {
    //移除set
    NSString *key = [NSStringFromSelector(_cmd1) stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
    //首字母小写
    NSString *head = [key substringWithRange:NSMakeRange(0, 1)];
    head = [head lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:head];
    //移除后缀 ":"
    key = [key stringByReplacingCharactersInRange:NSMakeRange(key.length - 1, 1) withString:@""];
    
    Ivar ivar = class_getInstanceVariable([self1 class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
    NSMutableDictionary *dictCustomerProperty = object_getIvar(self1, ivar);
    if (!dictCustomerProperty) {
        dictCustomerProperty = [NSMutableDictionary dictionary];
        object_setIvar(self1, ivar, dictCustomerProperty);
    }
    [dictCustomerProperty setObject:newValue forKey:key];
}

+ (id)getPropertyValueWithTarget:(id)target withPropertyName:(NSString *)propertyName {
    //先判断有没有这个属性，没有就添加，有就直接赋值
    Ivar ivar = class_getInstanceVariable([target class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
    if (ivar) {
        return object_getIvar(target, ivar);
    }
    
    ivar = class_getInstanceVariable([target class], "_dictCustomerProperty");  //basicsViewController里面有个_dictCustomerProperty属性
    NSMutableDictionary *dict = object_getIvar(target, ivar);
    if (dict && [dict objectForKey:propertyName]) {
        return [dict objectForKey:propertyName];
    } else {
        return nil;
    }
}

@end
