//
//  KyoMultiTextField.m
//  YWCat
//
//  Created by Kyo on 4/12/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoMultiTextField.h"
#import "KyoTextField.h"

@interface KyoMultiTextField()

- (void)addNotification;    //添加通知监听

- (void)textFieldTextDidBeginNotification:(NSNotification *)notification;  //通知：textfield开始编辑改变时通知
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification;  //通知：textfield文本改变时通知
- (void)textFieldTextDidEndEditingNotification:(NSNotification *)notification;  //通知：textfield文本结束编辑时通知

@end

@implementation KyoMultiTextField

#pragma mark ---------------------
#pragma mark - CycLife

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.lblText) {
        UILabel *lblText = [[UILabel alloc] init];
        lblText.font = [UIFont systemFontOfSize:self.textFontSize];
        lblText.textColor = self.color;
        lblText.numberOfLines = self.numberOfLines;
        lblText.textAlignment = self.textAlignment;
        lblText.text = self.text;
        [self addSubview:lblText];
        lblText.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *dictViews = @{@"subView" : lblText};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[subView]-(==0)-|" options:0 metrics:nil views:dictViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[subView]-(==0)-|" options:0 metrics:nil views:dictViews]];
        self.lblText = lblText;
    }
    
    if (!self.textField) {
        KyoTextField *textField = [[KyoTextField alloc] init];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = self.color;
        textField.font = [UIFont systemFontOfSize:self.textFontSize];
        textField.returnKeyType = self.textReturnKeyType;
        textField.background = self.backgroupImage;
        textField.delegate = self.delegate;
        textField.placeholder = self.placeholder;
        textField.text = @"";
        textField.leftSpace = self.leftSpace;
        textField.textAlignment = self.textAlignment;
        [self insertSubview:textField belowSubview:self.lblText];
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *dictViews = @{@"subView" : textField};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[subView]-(==0)-|" options:0 metrics:nil views:dictViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[subView]-(==0)-|" options:0 metrics:nil views:dictViews]];
        self.textField = textField;
        
        if (self.lblText.text && ![self.lblText.text isEqualToString:@""]) {
            self.textField.placeholder = nil;
        } else {
            self.textField.placeholder = self.placeholder;
        }
        
        [self addNotification];
    }
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}

#pragma mark ---------------------
#pragma mark - Settings

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    _delegate = delegate;
    
    if (self.textField && delegate) {
        self.textField.delegate = delegate;
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    
    if (!self.textField || !self.lblText) {
        return;
    }
    
    self.textField.text = nil;
    self.lblText.text = nil;
    
    if ([self.textField isFirstResponder]) {
        self.textField.text = text;
    } else {
        self.lblText.text = text;
        if (text && ![text isEqualToString:@""]) {
            self.textField.placeholder = nil;
        } else {
            self.textField.placeholder = self.placeholder;
        }
    }
}

#pragma mark ----------------------
#pragma mark - Methods

//添加通知监听
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginNotification:) name:UITextFieldTextDidBeginEditingNotification object:self.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:self.textField];
}

#pragma mark ---------------------
#pragma mark - NSNotification

//通知：textfield开始编辑改变时通知
- (void)textFieldTextDidBeginNotification:(NSNotification *)notification {
    if (notification.object && notification.object != [NSNull null] && notification.object == self.textField) {  //如果文本改变通知是自己的textfield
        self.textField.text = self.text;
        self.lblText.text = nil;
    }
}

//通知：textfield文本改变时通知
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification {
    if (notification.object && notification.object != [NSNull null] && notification.object == self.textField) {  //如果文本改变通知是自己的textfield
        _text = self.textField.text;
        if (self.text && ![self.text isEqualToString:@""]) {
            self.textField.placeholder = nil;
        } else {
            self.textField.placeholder = self.placeholder;
        }
    }
}

//通知：textfield文本结束编辑时通知
- (void)textFieldTextDidEndEditingNotification:(NSNotification *)notification {
    if (notification.object && notification.object != [NSNull null] && notification.object == self.textField) {  //如果文本改变通知是自己的textfield
        _text = self.textField.text;
        self.textField.text = nil;
        self.lblText.text = self.text;
        if (self.lblText.text && ![self.lblText.text isEqualToString:@""]) {
            self.textField.placeholder = nil;
        } else {
            self.textField.placeholder = self.placeholder;
        }
    }
}

@end
