//
//  KBSelectedEmailSuffixView.m
//  JuMi
//
//  Created by Kyo on 13/1/15.
//  Copyright (c) 2015 zhunit. All rights reserved.
//

#import "KyoSelectedEmailSuffixView.h"

#define kKBSelectedEmailSuffixViewMinHeight 45
#define kKBSelectedEmailSuffixViewMaxHeight 150

@interface KyoSelectedEmailSuffixView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) NSString *currentInputSuffix;
@property (nonatomic, assign) BOOL isMoreThanMinHeight;

@property (nonatomic, strong) NSMutableArray *arraySuffix;

- (void)initialize; //初始化

- (void)btnBGTouchIn:(UIButton *)btn;

@end

@implementation KyoSelectedEmailSuffixView

#pragma mark ----------------------
#pragma mark - CycLife

//根据目标view显示到对应位置
- (id)initWithTargerView:(UIView *)view withDelegate:(id<KBSelectedEmailSuffixViewDelegate>)delegate withCurrentText:(NSString *)currentText;
{
    self = [super initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    if (self) {
        self.targetView = view;
        self.delegate = delegate;
        if ([currentText rangeOfString:@"@"].location == NSNotFound) {
            self.currentInputSuffix = nil;
        } else {
            NSInteger location = [currentText rangeOfString:@"@"].location + 1;
            if (currentText.length <= location) {
                self.currentInputSuffix = nil;
            } else {
                self.currentInputSuffix = [NSString stringWithFormat:@"%@",[currentText substringFromIndex:location]];
            }
        }
        [self initialize];
    }
    return self;
}

#pragma mark ----------------------
#pragma mark - Events

- (void)btnBGTouchIn:(UIButton *)btn
{
    [self hide];
}

#pragma mark ----------------------
#pragma mark - Methods


//初始化
- (void)initialize
{
    //先得到要显示的位置和高度，如果高度不够，则跳出
    CGRect rectTarget = [KyoUtil relativeFrameForScreenWithView:self.targetView];  //得到目标view的坐标和大小
    NSInteger tableViewHeight = kWindowHeight - rectTarget.origin.y - rectTarget.size.height;
    self.isMoreThanMinHeight = tableViewHeight >= kKBSelectedEmailSuffixViewMinHeight ? YES : NO;
    if (!self.isMoreThanMinHeight) {    //如果小于最小高度，跳出
        return;
    } else if (tableViewHeight > kKBSelectedEmailSuffixViewMaxHeight) { //大于最大高度，则设置为等于最大高度
        tableViewHeight = kKBSelectedEmailSuffixViewMaxHeight;
    }
    
    //后缀
    self.arraySuffix = [kKBTextFieldEmailSuffix mutableCopy];
    //移除不包含现在输入过的后缀的邮箱后缀
    NSIndexSet *indexSet = [self.arraySuffix indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *suffix = obj;
        //如果当前输入的后缀为空或递归到的后缀包含当前输入的后缀，则不被移除
        if (!self.currentInputSuffix || [self.currentInputSuffix isEqualToString:@""] || [suffix rangeOfString:self.currentInputSuffix].location != NSNotFound) {
            return NO;
        } else {
            return YES;
        }
    }];
    [self.arraySuffix removeObjectsAtIndexes:indexSet];
    
    //背景按钮
    UIButton *btnBG = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBG.backgroundColor = [UIColor clearColor];
    btnBG.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    [btnBG addTarget:self action:@selector(btnBGTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBG];
    
    //tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(rectTarget.origin.x,
                                                                           rectTarget.origin.y + rectTarget.size.height,
                                                                           rectTarget.size.width,
                                                                           tableViewHeight)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tableView];
}

- (void)show
{
    if (!self.superview && self.isMoreThanMinHeight) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:self];
    }
}

- (void)hide
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark ----------------------
#pragma mark - UITableViewDataSource, UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arraySuffix.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.arraySuffix[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedEmailSuffixView:withSelectedEmailSuffix:)]) {
        [self.delegate selectedEmailSuffixView:self withSelectedEmailSuffix:self.arraySuffix[indexPath.row]];
    }
    
    [self hide];
}

@end
