
//                      _ooOoo_
//                     o8888888o
//                     88" . "88
//                     (| -_- |)
//                     O\  =  /O
//                  ____/`---'\____
//                 .' \\|     |// `.
//                / \\||| :   |||// \
//               / _||||| -:- |||||- \
//              |   | \\\  -  /// |   |
//              | \_|  ''\---/ '' |   |
//              \  .-\__  `-`  ___/-. /
//             ___`. .' /--.--\  `. . __
//          ."" '< `.___\_<|>_/___.' >'"".
//         | | : `- \`.;`\ _ /`;.`/ - ` : | |
//          \ \ `-.  \_ __\ /__ _/ .-`    / /
//   ======`-.____`-.___\_____/___.-`____.-'======
//                      `=---='
//
//            佛祖保佑                永无BUG
//
//  Global.h
//  YWCat
//
//  Created by Kyo on 23/3/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

//一些url
//#define kCounselorUrl(_proId,_planID,_appId) [NSString stringWithFormat:@"http://m.hzins.com/activities/yuyue/bdym?productId=%ld&planId=%ld&appId=%@", (long)_proId, (long)_planID, _appId]   //预约顾问的页面  －－h5使用的


//主站App的一些标示
#define kAppPlatform  @"4"
#define kAppMarket  @"001_002"
#define kAppSalt  @"ios123"

//最上层能显示HUD的window
#define kShowMessageView()   \
[NSStringFromClass([[[UIApplication sharedApplication].windows objectAtIndex:[UIApplication sharedApplication].windows.count - 1] class]) rangeOfString:@"UIRemoteKeyboardWindow"].location != NSNotFound ?  \
[[UIApplication sharedApplication].windows objectAtIndex:[UIApplication sharedApplication].windows.count - 1] :  \
[UIApplication sharedApplication].keyWindow

//设备高度
#define kWindowHeight (kSystemVersionMoreThan8 ? [[[UIApplication sharedApplication] delegate] window].bounds.size.height : [[[UIApplication sharedApplication] delegate] window].bounds.size.height)

//设备宽度
#define kWindowWidth (kSystemVersionMoreThan8 ? [[[UIApplication sharedApplication] delegate] window].bounds.size.width : [[[UIApplication sharedApplication] delegate] window].bounds.size.width)

//设备比例
#define kScreenScale    ([UIScreen mainScreen].scale)

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

//系统版本
#define kSystemVersion ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define kSystemVersionMoreThan5 (kSystemVersion >= 5.0)
#define kSystemVersionMoreThan6 (kSystemVersion >= 6.0)
#define kSystemVersionMoreThan7 (kSystemVersion >= 7.0)
#define kSystemVersionMoreThan8 (kSystemVersion >= 8.0)
#define kSystemVersionMoreThan8_1 (kSystemVersion >= 8.1)
#define kSystemVersionMoreThan(_version) (kSystemVersion >= _version)  //版本号是否大于等于传入版本号
#define kSystemVersionMiddleAndEqual(_min,_max) (kSystemVersion >= _min && kSystemVersion <= _max)  //版本号在区间内（开区间，可以等于两个区间值）
#define kSystemVersionMiddle(_min,_max) (kSystemVersion > _min && kSystemVersion < _max)  //版本号在区间内（闭区间，不可以等于两个区间值）

//设备类型
#define kIsIphone6Plus (kWindowHeight == 736)   //414
#define kIsIphone6 (kWindowHeight == 667)   //375
#define kIsIphone5 (kWindowHeight == 568)
#define kIsIphone4 (kWindowHeight == 480)
#define kWindowWidth320 320

//时间
#define kShowMessageTimeOne 1.0f   //提示显示时间
#define kShowMessageTime 2.0f   //提示显示时间
#define kOverViewInWindowTag 10086120   //弹框添加的视图
#define kAnimationTime 0.35f //弹框使用的动画时间

//提示语句
#define kTipsNetworkError   @"网络请求失败"
#define kSecurityLevelDefaultTip @"密码安全程度："
#define kSecurityLevelEmptyTip @"密码由6-20位数字、字母或符号组成"

//电话
#define kCallServer @"4006366366"

//分页
#define kPageSize   10

//UserDefault
#define kUserDefaultKey_CFBundleShortVersionString  @"kUserDefaultKey_CFBundleShortVersionString"   //版本号
#define kUserDefaultKey_KeyChar @"kUserDefaultKey_KeyChar"  //唯一标示
//保障
#define KProtectBaseInfoModel  @"KProtectBaseInfoModel"

//通知
#define kNotificationName_ViewControllerWillAppear  @"ViewControllerWillAppear" //viewcontroller显示时触发
#define kNotificationName_ViewControllerWillDisappear   @"ViewControllerWillDisappear" //viewcontroller隐藏时触发
#define kNotificationName_WeiXinPaySuccess    @"WeiXinPaySuccess" //微信支付成功通知
#define kNotificationName_AlixPaySuccess    @"alixPaySuccess" //跳转到支付宝客户端支付成功通知
#define kNotificationName_LoginSuccess    @"LoginSuccess"  //登录成功通知
#define kNotificationName_LogOutSuccess    @"LogOutSuccess"  //退出登录成功通知
#define kNotificationName_UserChanged   @"UserChanged"  //用户修改资料成功通知
#define kNotificationName_GetMyDetail   @"GetMyDetail"  //获取用户信息成功通知
#define kNotificationName_HistoryFoot   @"HistoryFoot"  //更改了足迹缓存通知
#define kNotificationName_ProjectHistoryFoot   @"ProjectHistoryFoot"  //更改了方案缓存通知
#define kNotificationProductDetailModelChangeSelected   @"kNotificationProductDetailModelChangeSelected"    //更改了保险选择项
#define kNotificationProductDetailModelChangeIsShowRemark   @"kNotificationProductDetailModelChangeIsShowRemark"    //改变是否显示产品详情说明通知
#define kNotificationName_CollectionStateDidChange  @"kNotificationName_CollectionStateDidChange"   //产品收藏或取消收藏成功通知
#define kNotificationName_ChatViewBack   @"ChatViewBack"  //首次进入聊天界面后返回通知
#define kNotificationName_bindPhoneSuccess   @"bindPhoneSuccess"  //首次进入聊天界面后返回通知
#define kNotificationName_commitCommentSuccess   @"commitCommentSuccess"  //提交评分成功通知
#define kNotificationName_unBindCounselor   @"unBindCounselor"  //解绑顾问通知
#define kNotificationName_ProjectIdChangeSelected   @"ProjectIdChangeSelected"    //更改了方案选择项
#define kNotificationName_SecurityPersonListChange  @"SecurityPersonListChange" // 更改保障头部联系人
#define kNotificationName_ContactDataChange  @"kNotificationName_ContactDataChange" // 更改联系人信息
#define kNotificationName_AdvisorStatus @"advisorStatus"    //顾问状态变更通知
#define kNotificationName_GotoOnlineServicePage @"gotoOnlineServicePage"    //跳转到在线客服通知
#define kNotificationName_InitShareInfo @"initShareInfo"    //h5返回的分享内容通知

//*****AppStyle
#define kGlobalStyleColor kStyleFontColorFC4949 //主题色
#define kTabBarBGColor   YYColor(255,255,255)//tabBar的背景色
#define kNavBarBGColor YYColor(223,81,1) //NavBar的背景色
#define kNavBarTextColor YYColor(255,255,255)  //NavBar的文字颜色
#define kNavShadowColor [UIImage createImageWithColor:YYColorRGBA(100, 100, 100,0.1)]   //NavBar的阴影色
#define KGlobalBackgroundColor  YYColorFromRGB(0xF5F5F5)  //所有viewcontroller的背景色
#define kProductTableViewSeparator240Color YYColor(240, 240, 240)  //产品tableview的分割线颜色240
#define kProductTableViewSeparator205Color YYColor(205, 205, 205)  //产品tableview的分割线颜色205
#define kAgentIncomeTableViewSeparator220Color YYColor(220, 220, 220)  //代理人收益tableview的分割线颜色240
#define kAppBackgrounpColor YYColor(236,236,236)    //所有页面背景色

#define kStyleFontColor333333   YYColorFromRGB(0x333333)
#define kStyleFontColor666666   YYColorFromRGB(0x666666)
#define kStyleFontColor999999   YYColorFromRGB(0x999999)
#define kStyleFontColorFC4949   YYColorFromRGB(0xFC4949)
#define KNavEvaluteRptColor YYColorFromRGB(0x4891ef)  //YYColor(24, 105, 208)

#define kTableViewbackgroundColor YYColorFromRGB(0xECECEC)

#define kSegmentControlHeightWithFilter  43  //segmented高度－产品分类筛选
#define kSegmentControlFont [UIFont systemFontOfSize:14]  //segmented字体大小
#define kSegmentControlMaskBGColor  YYColorRGBA(255, 255, 255, 0.6)


//*****默认图片
#define kImageDefaultUserPhoto  [UIImage imageNamed:@"com_user_defaultPhoto"]
#define kImageDefault640x318   [UIImage imageNamed:@"com_image_640x318"]
#define kImageDefault130x50   [UIImage imageNamed:@"com_image_130x50"]
#define kImageDefault140x140   [UIImage imageNamed:@"com_image_140x140"]
#define kImageDefault580x360   [UIImage imageNamed:@"com_image_580x360"]
#define kImageDefault640x420   [UIImage imageNamed:@"consultant_img_nopic_normal"]
#define kImageDefault90x90   [UIImage imageNamed:@"com_image_90x90"]
#define kImageDefault580x320   [UIImage imageNamed:@"consultant_img_nopic2_normal(1)"]

#define KImageDefaultCompanyLogo [UIImage imageNamed:@"com_image_130x50"]
//*****颜色
#define YYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define YYColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define YYColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//*****字体
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000

#define KyoSizeWithFont(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero
#define KyoBoundingRectWithSize(text, font, width) [text length] > 0 ? [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:NULL].size : CGSizeZero
#define KyoAttributeStringSize(_attributeString, _size)  [_attributeString boundingRectWithSize:_size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size

#else

#define KyoSizeWithFont(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero
#define KyoBoundingRectWithSize(text, font, width) [text length] > 0 ? [text sizeWithFont:font forWidth:width lineBreakMode:NSLineBreakByWordWrapping] : CGSizeZero
#define KyoAttributeStringSize(_attributeString, _size) CGSizeZero

#endif

//****类型处理
#define NSStringFromInt(_i) [NSString stringWithFormat:@"%ld", (long)_i]
#define NSStringFromNumber(_f) [NSString stringWithFormat:@"%@", @(_f)]

//****视图的一些设置

//分割线居左
#define kTableViewRemoveSeparatorPpace(tableViewOrCell)   if (kSystemVersionMoreThan8) {  \
[tableViewOrCell setSeparatorInset:UIEdgeInsetsZero]; \
[tableViewOrCell setLayoutMargins:UIEdgeInsetsZero];  \
} else if (kSystemVersionMoreThan7) {    \
[tableViewOrCell setSeparatorInset:UIEdgeInsetsZero]; \
};

//分割线按照指定inset设置
#define kTableViewChangeSeparatorPpace(tableViewOrCell, inset)   if (kSystemVersionMoreThan8) {  \
[tableViewOrCell setSeparatorInset:inset]; \
[tableViewOrCell setLayoutMargins:inset];  \
} else if (kSystemVersionMoreThan7) {    \
[tableViewOrCell setSeparatorInset:inset]; \
};

//绝对布局的autoresizing全部属性
#define kAutoresizingAll    UIViewAutoresizingFlexibleLeftMargin   | \
UIViewAutoresizingFlexibleWidth        | \
UIViewAutoresizingFlexibleRightMargin  | \
UIViewAutoresizingFlexibleTopMargin    | \
UIViewAutoresizingFlexibleHeight       | \
UIViewAutoresizingFlexibleBottomMargin

//绝对布局的autoresizing居左且上下拉伸属性
#define kAutoresizingLeftMarginAndHeight    UIViewAutoresizingFlexibleLeftMargin   | \
UIViewAutoresizingFlexibleTopMargin    | \
UIViewAutoresizingFlexibleHeight       | \
UIViewAutoresizingFlexibleBottomMargin

//*****查看代码运行时间
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

//***** Public Enum

typedef enum {
    ProductMakeTypeCategory = 0, //按险种
    ProductMakeTypeBrand = 1,   //按品牌
    ProductMakeTypePeople = 2   //按人群
} ProductMakeType;   //挑选产品的分类

typedef enum {
    ProductCategoryAccident = 1,  //意外险
    ProductCategoryTravel = 2,  //旅游险
    ProductCategoryHealth = 3,  //健康险
    ProductCategoryLife = 7,  //人寿险
    ProductCategoryProperty = 10,  //家财险
} ProductCategory;

typedef enum : NSInteger {
    ProductTableViewTypebasicConditions = 0,    //基本条件
    ProductTableViewTypeProtectItems = 1,   //保障项目
    ProductTableViewTypeProductNeedKnow = 2 //投保须知
} ProductTableViewType;  //table的类型（决定这个table要显示的数据）


