//
//  KBTextField.m
//  KidsBook
//
//  Created by Lukes Lu on 12/6/13.
//  Copyright (c) 2013 KidsBook Office. All rights reserved.
//

#import "KyoTextField.h"
#import "KyoSelectedEmailSuffixView.h"

@interface KyoTextField()<KBSelectedEmailSuffixViewDelegate>
{
    NSString *_perviousMarketText;
    NSRange _perviousSelectedRange;
    BOOL _isMarketHandle;
}

@property (nonatomic, strong) KyoSelectedEmailSuffixView *emailSuffixView;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *autoCompleterText;  //自动提示的email字符

- (void)initialize; //初始化
- (void)addNotification;    //添加通知监听
- (void)showSelectedEmailSuffix;    //显示选择email后缀
- (void)hideSelectedEmailSuffix;    //隐藏选择email后缀
- (void)showPlaceholderWithEmail;   //提示email

- (void)whenClearBtnTapped:(UIButton *)btn;

- (void)textFieldTextDidChangeNotification:(NSNotification *)notification;  //通知：textfield文本改变时通知
- (void)textFieldTextDidEndEditingNotification:(NSNotification *)notification;  //通知：textfield文本结束编辑时通知


@end

@implementation KyoTextField

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{
    _perviousMarketText = markedText;
    _perviousSelectedRange = selectedRange;
    @try {
        [super setMarkedText:markedText selectedRange:selectedRange];
    }
    @catch (NSException *exception) {
        KyoLog(@"error: setMarkedText:selectedRange");
    }
}

#pragma mark ----------------------
#pragma mark - Settings

- (void)setLeftSpace:(NSInteger)leftSpace {
    _leftSpace = leftSpace;
    
    if (leftSpace > 0) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.width = leftSpace;
        view.backgroundColor = [UIColor clearColor];
        
        self.leftView = view;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
}

#pragma mark ----------------------
#pragma mark - Events

- (void)whenClearBtnTapped:(UIButton *)btn
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, self.text ? self.text.length : 0) replacementString:@""];
    }
    
    self.text = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
    
    [self becomeFirstResponder];
    
    if (self.isShowEmailSuffix) {
        [self hideSelectedEmailSuffix];
    }
}

#pragma mark ----------------------
#pragma mark - Methods

//初始化
- (void)initialize
{
    [self addNotification];
    [self resetRightView];
}

//添加通知监听
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:self];
}

//重置右边按钮变为x
- (void)resetRightView
{
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40, 40)];
    [myButton setImage:[UIImage imageNamed:@"com_txt_btn_clear"] forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(whenClearBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    myButton.userInteractionEnabled = YES;
    
    self.rightView = myButton;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    self.rightView.userInteractionEnabled = YES;
}

//显示选择email后缀
- (void)showSelectedEmailSuffix
{
    if (self.emailSuffixView) {
        [self.emailSuffixView hide];
        self.emailSuffixView = nil;
    }
    
    self.emailSuffixView = [[KyoSelectedEmailSuffixView alloc] initWithTargerView:self withDelegate:self withCurrentText:self.text];
    [self.emailSuffixView show];
}

//隐藏选择email后缀
- (void)hideSelectedEmailSuffix
{
    if (self.emailSuffixView) {
        [self.emailSuffixView hide];
        self.emailSuffixView = nil;
    }
}

//提示email
- (void)showPlaceholderWithEmail
{
    /*markedTextRange 和 selectedTextRange 是不同的 ，markedTextRange是高亮文字(比如中文输入法输入文字后的显示)  selectedTextRange是选中的文字*/
    UITextRange *range = nil;
    if (kSystemVersionMoreThan8) {  //ios8系统下才需要判读,因为在ios8下才不正常
        range = self.markedTextRange ? self.markedTextRange : self.selectedTextRange; //markedTextRange有高亮一段文字才有值，selectedTextRange的值都是在光标末尾
    } else {
        range = self.selectedTextRange;
    }
    UITextPosition *startTextPosition = range.start;
    UITextPosition *endTextPosition = range.end;
    NSInteger startPosition = [[startTextPosition valueForKey:@"offset"] integerValue];   //当前光标的开始位置
    NSInteger endPosition = [[endTextPosition valueForKey:@"offset"] integerValue];   //当前光标的结束位置
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    NSString *language = [[self textInputMode] primaryLanguage];    // 键盘输入模式
#else
    NSString *language = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
#endif
    
    BOOL isChineseLanguage = [language isEqualToString:@"zh-Hans"]; //是否是简体中文输入，包括简体拼音，健体五笔，简体手写
    if (isChineseLanguage &&
        startPosition != endPosition
        && !self.autoCompleterText) {    //如果在简体中文下有高亮文字范围，且当前没匹配过email，则跳出
        return;
    }
    
    //如果有高亮文字范围，且后面有文字，把高亮后的文字去掉
    if (startPosition != endPosition && self.text.length > endPosition) {
        self.text = [self.text substringToIndex:startPosition];
        _isMarketHandle = YES;
        [self setMarkedText:_perviousMarketText selectedRange:_perviousSelectedRange];
        return;
    } else if (startPosition != endPosition) {  //如果有高亮文字 且 高亮文字后面没文字了，则跳出
        return;
    }
    
    NSString *currentInputSuffix = nil;
    NSString *postionText = [self.text substringToIndex:endPosition];
    
    if ([postionText rangeOfString:@"@"].location == NSNotFound) {
        currentInputSuffix = nil;
    } else {
        NSInteger location = [postionText rangeOfString:@"@"].location + 1;
        if (postionText.length <= location) {
            currentInputSuffix = nil;
        } else {
            currentInputSuffix = [NSString stringWithFormat:@"%@",[postionText substringFromIndex:location]];
        }
    }
    
    
    //后缀
    NSMutableArray *arraySuffix = [kKBTextFieldEmailSuffix mutableCopy];
    
    //移除不包含现在输入过的后缀的邮箱后缀
    NSIndexSet *indexSet = [arraySuffix indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *suffix = obj;
        //如果当前输入的后缀为空或递归到的后缀包含当前输入的后缀，则不被移除
        if (!currentInputSuffix || [currentInputSuffix isEqualToString:@""] || [suffix rangeOfString:currentInputSuffix].location == 0) {
            return NO;
        } else {
            return YES;
        }
    }];
    [arraySuffix removeObjectsAtIndexes:indexSet];
    
    if (arraySuffix.count > 0) {
        self.text = [NSString stringWithFormat:@"%@%@",[self.text substringToIndex:[self.text rangeOfString:@"@"].location + 1], arraySuffix[0]];   //重置text

        //设置富文本属性
        if (!self.color) {
            self.color = [self.textColor copy];
        }
        
        NSMutableAttributedString *attributedStringOrder = [[NSMutableAttributedString alloc] initWithString:self.text];
        [attributedStringOrder addAttribute:NSForegroundColorAttributeName
                                      value:self.color
                                      range:NSMakeRange(0, endPosition)];
        NSRange autoCompleterTextRange = NSMakeRange(endPosition, self.text.length - endPosition);
        self.autoCompleterText = [self.text substringWithRange:autoCompleterTextRange];
        [attributedStringOrder addAttribute:NSForegroundColorAttributeName
                                      value:YYColor(188.0, 188.0, 188.0)
                                      range:autoCompleterTextRange];
        self.attributedText = attributedStringOrder;
        
        //移动光标位置
        if (endPosition  < self.text.length) {
            NSInteger offset = self.text.length - (endPosition );
            [self moveCursor:self inDirection:UITextLayoutDirectionLeft offset:offset];
        }
    } else {
        self.text = [self.text substringToIndex:endPosition];

        self.autoCompleterText = nil;
    }
}

-(void) moveCursor:(id<UITextInput>)textInput inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    UITextRange *range = textInput.selectedTextRange;
    UITextPosition* start = [textInput positionFromPosition:range.start inDirection:direction offset:offset];
    if (start)
    {
        [textInput setSelectedTextRange:[textInput textRangeFromPosition:start toPosition:start]];
    }
}

#pragma mark ---------------------
#pragma mark - KBSelectedEmailSuffixViewDelegate

- (void)selectedEmailSuffixView:(KyoSelectedEmailSuffixView *)selectedEmailSuffixView withSelectedEmailSuffix:(NSString *)suffix
{
    self.text = [NSString stringWithFormat:@"%@%@",[self.text substringToIndex:[self.text rangeOfString:@"@"].location+1],suffix];
    [self resignFirstResponder];
}

#pragma mark ---------------------
#pragma mark - NSNotification

//通知：textfield文本改变时通知
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
    if (notification.object && notification.object != [NSNull null] && notification.object == self) {  //如果文本改变通知是自己
        
        if (_isMarketHandle) {
            _isMarketHandle = NO;
            return;
        }
        
        //如果在输入@后显示与文本有@符号,则显示
        if (self.isShowEmailSuffix && [self.text rangeOfString:@"@"].location != NSNotFound) {
            [self showSelectedEmailSuffix]; //显示
        } else {
            [self hideSelectedEmailSuffix]; //隐藏
        }
        
        //如果在输入@后显示与文本有@符号,则自动补全
        if (self.isAutoCompleterEmailSuffix) {
            if (self.color) {
                self.textColor = self.color;
            }
            if ([self.text rangeOfString:@"@"].location != NSNotFound) {
                [self showPlaceholderWithEmail];
            } else if (self.autoCompleterText) {
                self.text = [self.text stringByReplacingOccurrencesOfString:self.autoCompleterText withString:@""];
                self.autoCompleterText = nil;
            }
        }
        
    } else {
        [self hideSelectedEmailSuffix]; //隐藏
    }
}

//通知：textfield文本结束编辑时通知
- (void)textFieldTextDidEndEditingNotification:(NSNotification *)notification
{
    if (notification.object && notification.object != [NSNull null] && notification.object == self) {  //如果文本改变通知是自己
        if (self.isAutoCompleterEmailSuffix) {
            if (self.color) {
                self.textColor = self.color;
            }
            self.autoCompleterText = nil;
        }
    }
}

@end
