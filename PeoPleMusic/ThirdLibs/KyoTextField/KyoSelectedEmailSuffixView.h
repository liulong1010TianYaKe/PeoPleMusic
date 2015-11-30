//
//  KBSelectedEmailSuffixView.h
//  JuMi
//
//  Created by Kyo on 13/1/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KyoTextField.h"

@protocol KBSelectedEmailSuffixViewDelegate;

@interface KyoSelectedEmailSuffixView : UIView

@property (nonatomic, assign) id<KBSelectedEmailSuffixViewDelegate> delegate;

- (id)initWithTargerView:(UIView *)view withDelegate:(id<KBSelectedEmailSuffixViewDelegate>)delegate withCurrentText:(NSString *)currentText;    //根据目标view显示到对应位置

- (void)show;
- (void)hide;

@end

@protocol KBSelectedEmailSuffixViewDelegate <NSObject>

- (void)selectedEmailSuffixView:(KyoSelectedEmailSuffixView *)selectedEmailSuffixView withSelectedEmailSuffix:(NSString *)suffix;

@end
