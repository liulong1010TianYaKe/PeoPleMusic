//
//  KyoKeyboardReturnKeyHandler.h
//  MainApp
//
//  Created by Kyo on 8/3/16.
//  Copyright © 2016 hzins. All rights reserved.
//

/*
 解决问题：
 IQKeyboardReturnKeyHandler把textfield的delgate占用，导致之前设置的delegate不能触发
 这里做处理，会传递delegate
 */

#import "IQKeyboardReturnKeyHandler.h"

@interface KyoKeyboardReturnKeyHandler : IQKeyboardReturnKeyHandler

@end