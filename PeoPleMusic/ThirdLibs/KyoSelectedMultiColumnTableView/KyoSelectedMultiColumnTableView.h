//
//  KyoSelectedMultiColumnTableView.h
//  YWCat
//
//  Created by Kyo on 3/28/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kyoNotSelectedCell -1   //没有默认选择的cell

typedef enum {
    KyoSelectedMultiColumnTableViewCellDirectionLeft = 0,   //cell文字方向剧左
    KyoSelectedMultiColumnTableViewCellDirectionCenter = 1  //cell文字剧中
} KyoSelectedMultiColumnTableViewCellDirection;

@protocol KyoSelectedMultiColumnTableViewDelegate;

@interface KyoSelectedMultiColumnTableView : UIView

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) CGRect tableViewCountFrame;
@property (nonatomic, strong) NSArray *arrayColumnDefaultIndex;   //每一列默认选择的cell项
@property (nonatomic, assign) id<KyoSelectedMultiColumnTableViewDelegate> delegate;

@property (assign, nonatomic) BOOL isShowSegmentationLine;  /**< 是否显示分割线，默认显示 */
@property (assign, nonatomic) BOOL isShowArrow; /**< 是否显示选中箭头，默认显示 */
@property (assign, nonatomic) KyoSelectedMultiColumnTableViewCellDirection direction;   /**< cell文字排版样式，默认居左 */
@property (assign, nonatomic) BOOL isShowSelectedColor; /**< 是否显示选中cell的颜色 */
@property (strong, nonatomic) UIColor *titleColor;  /**< 标题正常颜色 */
@property (strong, nonatomic) UIColor *titleSelectedColor;  /**< 标题选中的颜色 */
@property (strong, nonatomic) UIFont *titleFont;  /**< 标题字体 */
@property (assign, nonatomic) BOOL isAutoHeight;    /**< 是否自动显示高度（有最大值，初始化传入的就是最大高度），默认为no */

- (instancetype)initWithColumn:(NSInteger)column withFrame:(CGRect)frame withTargetDelegate:(id<KyoSelectedMultiColumnTableViewDelegate>)target withArrayColumnDefaultIndex:(NSArray *)arrayColumnDefaultIndex;
- (void)show;
- (void)close:(BOOL)isHadDone;  //关闭，ishadone是否选择完成了

@end


@protocol KyoSelectedMultiColumnTableViewDelegate <NSObject>

//- (NSInteger)kyoSelectedMultiColumnTableView:(KyoSelectedMultiColumnTableView *)kyoSelectedMultiColumnTableView defaultSelectedWithColoumIndex:(NSInteger)coloumIndex; //设置第coloumIndex列的默认选择项,如果不需要默认选择项则设置－1
- (NSArray *)kyoSelectedMultiColumnTableView:(KyoSelectedMultiColumnTableView *)kyoSelectedMultiColumnTableView reloadDataWithColoumIndex:(NSInteger)coloumIndex  withCurrentSelected:(NSArray *)arraySelected;    //重载第coloumIndex列数据,arraySelected是前面选择数据
- (void)kyoSelectedMultiColumnTableViewClose:(KyoSelectedMultiColumnTableView *)kyoSelectedMultiColumnTableView;    //没选择cell就关闭
- (void)kyoSelectedMultiColumnTableViewDone:(KyoSelectedMultiColumnTableView *)kyoSelectedMultiColumnTableView withCurrentSelected:(NSArray *)arraySelected;    //选择完成cell后关闭

@end