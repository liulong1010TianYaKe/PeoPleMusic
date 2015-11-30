//
//  KyoMultiTextField.h
//  YWCat
//
//  Created by Kyo on 4/12/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KyoMultiTextFieldDelegate;

@interface KyoMultiTextField : UIView

@property (nonatomic, strong) UILabel *lblText;
@property (nonatomic, strong) KyoTextField *textField;

@property (nonatomic) IBInspectable NSInteger numberOfLines;
@property (nonatomic, assign) IBInspectable NSInteger textFontSize;
@property (nonatomic, strong) IBInspectable UIColor *color;
@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) IBInspectable NSString *text;
@property (nonatomic, strong) IBInspectable UIImage *backgroupImage;
@property(nonatomic) IBInspectable NSInteger textReturnKeyType;
@property (nonatomic, assign) IBInspectable NSInteger leftSpace;
@property (nonatomic, assign) IBInspectable NSInteger textAlignment;
@property (nonatomic, assign) id<UITextFieldDelegate> delegate;

@end

@protocol KyoMultiTextFieldDelegate <NSObject>

@end
