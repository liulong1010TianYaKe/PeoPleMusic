//
//  KBTextField.h
//  KidsBook
//
//  Created by Lukes Lu on 12/6/13.
//  Copyright (c) 2013 KidsBook Office. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kKBTextFieldEmailSuffix @[@"qq.com", @"sina.com", @"163.com", @"gmail.com", @"yahoo.com",@"126.com",@"live.com",@"live.cn",@"hotmail.com",@"outlook.com",@"msn.com",@"icloud.com",@"me.com",@"21cn.com",@"263.net",@"tom.com",@"139.com",@"188.com",@"vip.qq.com",@"vip.163.com",@"foxmail.com",@"sohu.com",@"vip.sohu.com",@"sogou.com",@"vip.sina.com",@"sina.cn",@"yeah.net",@"zhihu.com"]

@interface KyoTextField : UITextField

@property (nonatomic, assign) BOOL isShowEmailSuffix;   //是否在输入@后显示email后缀
@property (nonatomic, assign) BOOL isAutoCompleterEmailSuffix;  //是否自动补全email后缀

@property (nonatomic, assign) NSInteger leftSpace;  //距离左边间距

- (void)resetRightView;

@end
