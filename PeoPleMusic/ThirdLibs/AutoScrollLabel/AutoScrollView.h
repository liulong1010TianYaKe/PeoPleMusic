//
//  AutoScrollView.h
//  test-32-AutoScrollLabel
//
//  Created by Kyo on 13-8-19.
//  Copyright (c) 2013年 zhuniT All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TextAlignmentTypeLeft = 0,
    TextAlignmentTypeCenter = 1,
    TextAlignmentTypeRight = 2
}TextAlignmentType;

@interface AutoScrollView : UIView

@property (nonatomic, assign) NSInteger distance;   //滚动间距
@property (nonatomic, assign) CGFloat fontSize; //文字字体大小
@property (nonatomic, strong) UIColor *color; //文字字体大小
@property (nonatomic, strong) NSString *title;  //显示文字内容
@property (nonatomic, assign) CFTimeInterval duration;  //滚动一次的总时间
@property (nonatomic, assign) TextAlignmentType alignmentType;  //只有当不滚动时（文字内容宽不大于AutoScrollView的宽度时，不滚动）,这个TextAligmentType才有效

@end
