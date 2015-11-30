//
//  KyoSelectedMultiColumnTableView.m
//  YWCat
//
//  Created by Kyo on 3/28/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoSelectedMultiColumnTableView.h"
#import "KyoSelectedColumnCell.h"

@interface KyoSelectedMultiColumnTableView()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary *_dictColumnTitles;    //每一列的数组title
    NSMutableDictionary *_dictColumnCurrentSelected; //当前选择的每一column的cell的index
    CGFloat _maxHeight; /**< 最大高度 */
}

@property (nonatomic, strong) UIView *supView;

@property (nonatomic, strong) UIButton *btnBG;
@property (nonatomic, strong) NSMutableDictionary *dictTableView;

- (void)btnBGTouchIn:(UIButton *)btn;

- (void)initialization; //初始化
- (NSInteger)reloadTableViewWithColumn:(NSInteger)column;    //重置第column列数据
- (void)doneSelected;   //完成选择

@end

@implementation KyoSelectedMultiColumnTableView

#pragma mark -----------------------
#pragma mark - CycLife

- (instancetype)initWithColumn:(NSInteger)column withFrame:(CGRect)frame withTargetDelegate:(id<KyoSelectedMultiColumnTableViewDelegate>)target withArrayColumnDefaultIndex:(NSArray *)arrayColumnDefaultIndex
{
    CGRect rectBG = CGRectZero;
    UIView *supView = nil;
    if ([target isKindOfClass:[UIViewController class]]) {
        rectBG = ((UIViewController *)target).view.bounds;
        supView = ((UIViewController *)target).view;
    } else if ([target isKindOfClass:[UIView class]]) {
        rectBG = ((UIView *)target).bounds;
        supView = (UIView *)target;
    }
    self = [super initWithFrame:rectBG];
    if (self) {
        
        self.delegate = target;
        self.column = column;
        self.tableViewCountFrame = frame;
        _maxHeight = frame.size.height;
        self.supView = supView;
        self.arrayColumnDefaultIndex = arrayColumnDefaultIndex;
        self.isShowArrow = YES;
        self.isShowSegmentationLine = YES;
        self.direction = KyoSelectedMultiColumnTableViewCellDirectionLeft;
        self.isShowSelectedColor = YES;
        self.titleColor = YYColor(102, 102, 102);
        self.titleSelectedColor = YYColor(102, 102, 102);
        
        [self initialization];
    }
    
    return self;
}

#pragma mark -----------------------
#pragma mark - Events

- (void)btnBGTouchIn:(UIButton *)btn
{
    [self close:NO];
}

#pragma mark --------------------
#pragma mark - Settings

- (void)setIsShowSegmentationLine:(BOOL)isShowSegmentationLine {
    _isShowSegmentationLine = isShowSegmentationLine;
    
    for (NSInteger i = 0; i < self.dictTableView.count; i++) {
        UITableView *tableView = self.dictTableView.allValues[i];
        tableView.separatorStyle = self.isShowSegmentationLine ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
    }
}


#pragma mark -----------------------
#pragma mark - Methods

//初始化
- (void)initialization
{
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClear.frame = self.bounds;
    [btnClear setBackgroundColor:[UIColor clearColor]];
    [btnClear addTarget:self action:@selector(btnBGTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClear];
    
    UIButton *btnBG = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBG.frame = CGRectMake(0, self.tableViewCountFrame.origin.y, self.bounds.size.width, self.bounds.size.height - self.tableViewCountFrame.origin.y);
    [btnBG setBackgroundColor:YYColorRGBA(0, 0, 0, 0.4)];
    [btnBG addTarget:self action:@selector(btnBGTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBG];
    self.btnBG.alpha = 0;
    self.btnBG = btnBG;
    
    for (NSInteger i = 0; i < self.column; i++) {
        NSInteger colorValue = 250 - 15 * i;
        NSInteger separatorColorValue = 230 - 15 * i;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.tableViewCountFrame.size.width / self.column * i, self.tableViewCountFrame.origin.y, self.tableViewCountFrame.size.width / self.column, 0) style:UITableViewStylePlain];
        tableView.backgroundColor = YYColor(colorValue, colorValue, colorValue);
        tableView.separatorColor = YYColor(separatorColorValue, separatorColorValue, separatorColorValue);
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.hidden = YES;
        [tableView registerNib:[UINib nibWithNibName:@"KyoSelectedColumnCell" bundle:nil] forCellReuseIdentifier:kKyoSelectedColumnCellIdentifier];
        kTableViewRemoveSeparatorPpace(tableView); //分割线居左
        tableView.separatorStyle = self.isShowSegmentationLine ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        
        if (!self.dictTableView) {
            self.dictTableView = [NSMutableDictionary dictionary];
        }
        [self.dictTableView setObject:tableView forKeyedSubscript:@(i)];
    }
}

- (void)show
{
    [self.supView addSubview:self];
    
    if (self.column <= 0) {
        return;
    }
    
    _dictColumnTitles = [NSMutableDictionary dictionary];
    _dictColumnCurrentSelected = [NSMutableDictionary dictionary];
    
    if (self.column <= 0) {
        return;
    }
    
    //重置数据
    if (!self.arrayColumnDefaultIndex) {
        [self reloadTableViewWithColumn:0]; //重置第0列数据
    } else {
        for (NSInteger i = 0; i < self.column; i++) {
            //如果当前列的子项为空，则隐藏子项的tableview
            NSInteger countTitle = [self reloadTableViewWithColumn:i];
            if (countTitle <= 0) {
                UITableView *tableview = self.dictTableView.allValues[i];
                tableview.hidden = YES;
            }
        }
    }
    self.arrayColumnDefaultIndex = nil; //重置完成数据后，清空默认选择项
    
    //判断是否自动设置高度
    if (self.isAutoHeight) {
        NSArray *arrayCurrentTitle = [_dictColumnTitles objectForKey:@(0)];
        CGFloat height = arrayCurrentTitle.count * kKyoSelectedColumnCellHeight;
        self.tableViewCountFrame = CGRectMake(self.tableViewCountFrame.origin.x, self.tableViewCountFrame.origin.y, self.tableViewCountFrame.size.width, height > _maxHeight ? _maxHeight : height);
    }
    
    for (NSInteger i = 0; i < self.dictTableView.allValues.count; i++) {
        UITableView *tableView = self.dictTableView.allValues[i];
        tableView.alpha = 0;
        [UIView animateWithDuration:0.35 animations:^{
            self.btnBG.alpha = 1;
            tableView.frame = CGRectMake(self.tableViewCountFrame.size.width / self.column * i, self.tableViewCountFrame.origin.y, self.tableViewCountFrame.size.width / self.column, self.tableViewCountFrame.size.height);
            tableView.alpha = 1;
        }];
    }
    
}

- (void)close:(BOOL)isHadDone
{
    [UIView animateWithDuration:0.25 animations:^{
        self.btnBG.alpha = 0;
        for (NSInteger i = 0; i < self.dictTableView.allValues.count; i++) {
            UITableView *tableView = self.dictTableView.allValues[i];
            tableView.frame = CGRectMake(self.tableViewCountFrame.size.width / self.column * i, self.tableViewCountFrame.origin.y, self.tableViewCountFrame.size.width / self.column, 0);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (!isHadDone) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(kyoSelectedMultiColumnTableViewClose:)]) {
                [self.delegate kyoSelectedMultiColumnTableViewClose:self];
            }
        }
    }];
}

//重置第column列数据
- (NSInteger)reloadTableViewWithColumn:(NSInteger)column
{
    NSInteger countTitle = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(kyoSelectedMultiColumnTableView:reloadDataWithColoumIndex:withCurrentSelected:)]) {
        NSMutableArray *arraySelected = [NSMutableArray array];
        for (NSInteger i = 0; i < self.column; i++) {
            if ([_dictColumnCurrentSelected objectForKey:@(i)]) {
                NSInteger value = [[_dictColumnCurrentSelected objectForKey:@(i)] integerValue];
                [arraySelected addObject:@(value)];
            } else {
                break;
            }
        }
        NSArray *arrayCurrentTitle = [self.delegate kyoSelectedMultiColumnTableView:self reloadDataWithColoumIndex:column withCurrentSelected:arraySelected];
        [_dictColumnTitles setObject:arrayCurrentTitle forKeyedSubscript:@(column)];
        countTitle = arrayCurrentTitle.count;
    }
    
    UITableView *tableView = [self.dictTableView objectForKey:@(column)];
    [tableView reloadData];
    tableView.hidden = NO;
    
    if (self.arrayColumnDefaultIndex && self.arrayColumnDefaultIndex.count > column) {  //默认选择项
        NSInteger currentColumnDefaultIndex = [self.arrayColumnDefaultIndex[column] integerValue];
        if (currentColumnDefaultIndex >= 0) {
            [_dictColumnCurrentSelected setObject:@(currentColumnDefaultIndex) forKeyedSubscript:@(column)];
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentColumnDefaultIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    //把column列后面的列都清空，且隐藏后面的tableview
    for (NSInteger i = 0; i < self.column; i++) {
        
        //清空当前选择的cell的index
        if (_dictColumnCurrentSelected.allKeys.count > i) {
            NSInteger tempColumn = [_dictColumnCurrentSelected.allKeys[i] integerValue];
            if (tempColumn > column) {
                [_dictColumnCurrentSelected removeObjectForKey:@(tempColumn)];
            }
        }
        
        //隐藏后面列的tableview
        if (i > column) {
            UITableView *tempTableView = [self.dictTableView objectForKey:@(i)];
            tempTableView.hidden = YES;
        }
    }
    
    //如果总标题为0，所以要调用done了，则移除后面的keyvalue，不然有多余的选择项
    if (countTitle <= 0) {
        @try {
            NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
            for (NSNumber *key in _dictColumnCurrentSelected.allKeys) {
                if ([key integerValue] < column) {
                    [dictTemp setObject:_dictColumnCurrentSelected[key] forKey:key];
                }
            }
            _dictColumnCurrentSelected = dictTemp;
        }
        @catch (NSException *exception) {}
    }
    
    return countTitle;
}

//完成选择
- (void)doneSelected
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(kyoSelectedMultiColumnTableViewDone:withCurrentSelected:)]) {
        NSMutableArray *arraySelected = [NSMutableArray array];
        for (NSInteger i = 0; i < self.column; i++) {
            if ([_dictColumnCurrentSelected objectForKey:@(i)]) {
                NSInteger value = [[_dictColumnCurrentSelected objectForKey:@(i)] integerValue];
                [arraySelected addObject:@(value)];
            } else {
                break;
            }
        }
        [self.delegate kyoSelectedMultiColumnTableViewDone:self withCurrentSelected:arraySelected];
    }
    
    [self close:YES];
}

#pragma mark -------------------------
#pragma mark - UITableViewSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger column = [self.dictTableView.allValues indexOfObject:tableView];
    NSArray *arrayCurrentTitle = [_dictColumnTitles objectForKey:@(column)];
    return arrayCurrentTitle.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kKyoSelectedColumnCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger column = [self.dictTableView.allValues indexOfObject:tableView];
    NSArray *arrayCurrentTitle = [_dictColumnTitles objectForKey:@(column)];
    NSInteger colorValue = 250 - 15 * column;
    NSInteger selectedColorValue = 250 - 15 * (column + 1);
    
    KyoSelectedColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:kKyoSelectedColumnCellIdentifier];
    kTableViewRemoveSeparatorPpace(cell);   //分割线居左
    cell.backgroundColor = YYColor(colorValue, colorValue, colorValue);
    cell.lblName.text = arrayCurrentTitle[indexPath.row];
    cell.imgvArrow.alpha = self.isShowArrow ? 1 : 0;
    cell.lblName.textAlignment = self.direction == KyoSelectedMultiColumnTableViewCellDirectionCenter ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    if (self.isShowSelectedColor) {
        cell.selectedColor = YYColor(selectedColorValue, selectedColorValue, selectedColorValue);
    } else {
        cell.selectedColor = [UIColor clearColor];
    }
    cell.titleColor = self.titleColor;
    cell.titleSelectedColor = self.titleSelectedColor;
    NSInteger currentColumnDefaultIndex = _dictColumnCurrentSelected && [_dictColumnCurrentSelected objectForKey:@(column)] ? [[_dictColumnCurrentSelected objectForKey:@(column)] integerValue] : -1;
    if (indexPath.row == currentColumnDefaultIndex) {
        cell.isHadSelected = YES;
    } else {
        cell.isHadSelected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    KyoSelectedColumnCell *cell = (KyoSelectedColumnCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.isHadSelected = YES;
    
    NSInteger column = [self.dictTableView.allValues indexOfObject:tableView];
    [_dictColumnCurrentSelected setObject:@(indexPath.row) forKeyedSubscript:@(column)];  //记录当前选择的项
    column = column + 1;  //需要加载的下一项
    if (column < self.column) { //如果有需要加载的下一项
        NSInteger countTitle = [self reloadTableViewWithColumn:column];
        if (countTitle <= 0) {  //如果下面没有选项了，则说明这个是“全部”或总类别，直接显示完成
            [self doneSelected];
        }
    } else {  //如果没有下一项需要加载了，则调用委托完成
        [self doneSelected];
    }
}

@end
