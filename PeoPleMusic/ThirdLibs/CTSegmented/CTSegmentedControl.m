//
//  CTSegmentedControl.m
//  MulScreenMual
//
//  Created by lingmin on 11-12-27.
//  Copyright 2011 Shenzhen iDooFly Technology Co., Ltd. All rights reserved.
//

#import "CTSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define SIZE_WITH_FONT(_font) sizeWithAttributes:@{NSFontAttributeName: _font}
#define SIZE_WITH_ATTRIBUTEDSTRING(_attributedString) [_attributedString boundingRectWithSize:CGSizeMake(1000, self.width) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size
#else
#define SIZE_WITH_FONT(_font) sizeWithFont:_font
#endif

@interface CTSegmentedControl ()
{
    CGRect _validFrame;
    CGPoint _pointToSelf;
}

@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) NSMutableArray *btnControls;
@property (nonatomic, strong) UIButton *btnSelected;
@property (nonatomic, assign, readwrite) CurrentDisplayAllow currentDisplayAllow;

@end

@implementation CTSegmentedControl

#pragma mark - Lifecycle

-(void)initData
{
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.frame=CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.backgroundImageView];
    
	self.mScrollView = [[UIScrollView alloc] init];
	self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.delegate = self;
    [self addSubview:self.mScrollView];

	self.btnControls = [[NSMutableArray alloc] init];
	
    self.highlightedBackgroundImageView = [[UIImageView alloc] init];
	[self addSubview:self.highlightedBackgroundImageView];
    
	self.selectedBackgroundImageView = [[UIImageView alloc] init];
//	self.selectedBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit; //让其图片不受到frame影响
	[self.mScrollView addSubview:self.selectedBackgroundImageView];
	[self.mScrollView sendSubviewToBack:self.selectedBackgroundImageView];
    
	self.titleFont = [UIFont systemFontOfSize:14];
    
	self.animationType = SegmentedControlAnimationTypeMove;
    
    self.selectedIndex = -1;
    self.closeAniamtion = YES;
    self.enable = YES;
    self.isAutoChangeSelectedBackgroundimageViewWidth = YES;
    self.isBackGroundImageViewWithIsFull = YES;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self){
		[self initData];
	}
    
	return self;
}

- (id)init
{
    self = [super init];
    if (self) {
		[self initData];
	}
    
    return self;
}

#pragma mark - Methods

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    
}

-(void)_setSelectedBG:(UIImage *)image
{
	if(self.btnSelected){
		[self.btnSelected setBackgroundImage:image forState:UIControlStateNormal];
    }
}

-(void)_setBtnBG:(UIImage *)image
{
	for (UIButton *oneButton in self.btnControls){
		if(oneButton != self.btnSelected){
			[oneButton setBackgroundImage:image forState:UIControlStateNormal];
        }
	}
}

- (void)highlightButton:(UIButton *)button
{
    for (UIButton *oneButton in self.btnControls) {
        if (button == oneButton) {
            self.highlightedBackgroundImageView.frame = oneButton.frame;
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = 0.5f;
            [self.layer addAnimation:transition forKey:nil];
            [UIView animateWithDuration:0.5f animations:^{
                self.highlightedBackgroundImageView.hidden = NO;
            }];
        }
    }
}

- (void)highlightButtonCancel:(UIButton *)button
{
    for (UIButton *oneButton in self.btnControls) {
        if (button == oneButton) {
            self.highlightedBackgroundImageView.frame = oneButton.frame;
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = 0.5f;
            [self.layer addAnimation:transition forKey:nil];
            [UIView animateWithDuration:0.5f animations:^{
                self.highlightedBackgroundImageView.hidden = YES;
            }];
        }
    }
}

- (void)buttonTouchedDown:(UIButton *)button
{
    [self highlightButton:button];
}

- (void)buttonTouchedOther:(UIButton *)button
{
    [self highlightButtonCancel:button];
}

- (void)selectButton:(UIButton *)button
{
    for (UIButton *oneButton in self.btnControls){
        if (button == oneButton){
            if (self.animationType == SegmentedControlAnimationTypeFade) {
                CATransition *transition = [CATransition animation];
                transition.type = kCATransitionFade;
                transition.duration = 0.3f;
                [self.layer addAnimation:transition forKey:nil];
                self.selectedBackgroundImageView.hidden = YES;
                self.selectedBackgroundImageView.frame = oneButton.frame;
                [UIView animateWithDuration:0.3f animations:^{
                    oneButton.selected = YES;
                    self.selectedBackgroundImageView.hidden = NO;
                    self.highlightedBackgroundImageView.hidden = YES;
                }];
            } else if (self.animationType == SegmentedControlAnimationTypeMove) {
                CGSize oneButtonSize = [oneButton.titleLabel.text SIZE_WITH_FONT(oneButton.titleLabel.font)];   //new
                [UIView animateWithDuration:0.3f animations:^{
                    oneButton.selected = YES;
                    if (self.isAutoChangeSelectedBackgroundimageViewWidth) {
                        self.selectedBackgroundImageView.frame = CGRectMake(oneButton.center.x-oneButtonSize.width/2, self.selectedBackgroundImageView.frame.origin.y,  oneButtonSize.width, self.selectedBackgroundImageView.frame.size.height);
                    } else {
                        self.selectedBackgroundImageView.center =CGPointMake(oneButton.center.x, self.selectedBackgroundImageView.center.y);
                    }
                    
//                    self.selectedBackgroundImageView.center =CGPointMake(oneButton.center.x, self.selectedBackgroundImageView.center.y); //new
                    self.highlightedBackgroundImageView.hidden = YES;
                }];
            } else if(self.animationType == SegmentedControlAnimationTypeMoveUpDown) {
                oneButton.selected = YES;
                self.selectedBackgroundImageView.frame = CGRectMake(0.0, oneButton.frame.origin.y+(oneButton.frame.size.height-self.selectedBackgroundImageView.frame.size.height)/2, self.selectedBackgroundImageView.frame.size.width, self.selectedBackgroundImageView.frame.size.height);
                self.highlightedBackgroundImageView.hidden = YES;
            }else {
                oneButton.selected = YES;
                self.selectedBackgroundImageView.frame = oneButton.frame;
                self.highlightedBackgroundImageView.hidden = YES;
            }
        }else {
            oneButton.selected = NO;
        }
    }
}

-(void)buttonAction:(UIButton*)button
{
    if (!self.enable) {
        return;
    }
    
    //准备选择委托，判断是否能够选择
    if(self.delegate && [self.delegate respondsToSelector:@selector(segmented:willSelectedIndex:)]){
        if (![self.delegate segmented:self willSelectedIndex:button.tag]) {
            return;
        }
    }
    
	//获取该button相对于self的坐标
	if(!button || ![button isKindOfClass:[UIButton class]]){
        return;
    }
    
	CGPoint point = CGPointMake(button.center.x-self.mScrollView.contentOffset.x, button.center.y);
	CGPoint newPoing = [self convertPoint:point toView:self];
	_pointToSelf = newPoing;
    //如果是富文本的按钮标题，把当前选择的按钮先还原成默认样式，因为下面要改变当前选择的按钮
    if (self.attributedTitles && self.attributedTitles.count > self.btnSelected.tag) {
        [self.btnSelected setAttributedTitle:self.attributedTitles[self.btnSelected.tag] forState:UIControlStateNormal];
    }
    if (self.attributedHightlightTitles && self.attributedHightlightTitles.count > self.btnSelected.tag) {
        [self.btnSelected setAttributedTitle:self.attributedHightlightTitles[self.btnSelected.tag] forState:UIControlStateHighlighted];
    }
	[self selectButton:button];
	if(self.btnSelected){
		[self.btnSelected setBackgroundImage:nil forState:UIControlStateNormal];
        [self.btnSelected setEnabled:YES];
		if(self.titleColor){
            [self.btnSelected setTitleColor:self.titleColor forState:UIControlStateNormal];
        } else if (self.arrayTitlesColor && self.arrayTitlesColor.count > self.btnSelected.tag) {
            [self.btnSelected setTitleColor:self.arrayTitlesColor[self.btnSelected.tag] forState:UIControlStateNormal];
        }
	}
	self.btnSelected = button;
	if(self.selectedBG){
        [self _setSelectedBG:self.selectedBG];
    }
	if(self.btnBG){
        [self _setBtnBG:self.btnBG];
    }
	if(self.selectedTitleColor){
        [button setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
    } else if (self.arraySelectedTitlesColor && self.arraySelectedTitlesColor.count > button.tag) {
        [button setTitleColor:self.arraySelectedTitlesColor[button.tag] forState:UIControlStateNormal];
    }
    
    if (self.attributedHightlightTitles && self.attributedHightlightTitles.count > button.tag) {
        [button setAttributedTitle:self.attributedHightlightTitles[button.tag] forState:UIControlStateNormal];
    }
    
    if (self.arrayHiddenSelectedBackgroundImageViewIndex && [self.arrayHiddenSelectedBackgroundImageViewIndex containsObject:[NSString stringWithFormat:@"%ld",(long)button.tag]]) {
        self.selectedBackgroundImageView.hidden = YES;
    } else {
        self.selectedBackgroundImageView.hidden = NO;
    }
    
    _selectedIndex = button.tag;
    
	if(self.delegate && [self.delegate respondsToSelector:@selector(segmented:selectedIndex:)]){
		[self.delegate segmented:self selectedIndex:button.tag];
    }
}

#pragma mark -
#pragma mark set month

-(void)setTitles:(NSArray *)array
{
    self.backgroundImageView.frame=CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    _titles = array;
    
	//清除
	for (int i=0; i < [self.btnControls count]; i++) {
		UIButton *button = [self.btnControls objectAtIndex:i];
		if(button){
			[button removeFromSuperview];
        }
	}
	self.btnSelected = nil;
	[self.btnControls removeAllObjects];
	
	if(_validFrame.size.width != 0 && _validFrame.size.height != 0){
		self.mScrollView.frame = _validFrame;
	}else {
		self.mScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	}

//    if ([array count]) {
//        [self.backgroundImageView setHidden:NO];
//    }else {
//        [self.backgroundImageView setHighlighted:YES];
//    }
	
	//添加按钮
	float currentWidth = self.leftMarage;
	float currentHeight = 0;
	int count = (int)[array count];
	for(int i=0; i<count; i++){
		UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i;
        if(self.titleColor){
            [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        } else if (self.arrayTitlesColor && self.arrayTitlesColor.count > button.tag) {
            [button setTitleColor:self.arrayTitlesColor[button.tag] forState:UIControlStateNormal];
        }
        if(self.titleFont){
            button.titleLabel.font=self.titleFont;
        }
        //设置image在文字左边或右边,前提是有image图片
        if(self.buttonImageIcons != nil && [self.buttonImageIcons count] > i && ![[self.buttonImageIcons objectAtIndex:i] isEqualToString:@""]){
            UIImage *buttonImageIcon=[UIImage imageNamed:[self.buttonImageIcons objectAtIndex:i]];
            if (buttonImageIcon) {
                if (!UIEdgeInsetsEqualToEdgeInsets(self.iconInsets, UIEdgeInsetsZero) || !UIEdgeInsetsEqualToEdgeInsets(self.titleInsets, UIEdgeInsetsZero)) {
                    button.imageEdgeInsets = self.iconInsets;
                    button.titleEdgeInsets = self.titleInsets;
                } else {
                    if (!self.arrayBtnImageOrientation || self.arrayBtnImageOrientation.count <= i || [self.arrayBtnImageOrientation[i] integerValue] == CurrentDisplayAllowLeft) { //左边
                        button.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
                        button.titleEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
                    } else {    //右边
                        NSString *title = [array objectAtIndex:i];
                        CGSize size = [title SIZE_WITH_FONT(button.titleLabel.font)];
                        button.titleEdgeInsets = UIEdgeInsetsMake(0, -buttonImageIcon.size.width * 2 - 3, 0, 0);
                        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -size.width * 2 - 3);
                    }
                }
            }
        }
        
		[self.btnControls addObject:button];//将控件添加到数组中 便于管理
		
		//如果加载的数据对象为图片
		if([[array objectAtIndex:i] isKindOfClass:[UIImage class]]){
			[button setImage:[array objectAtIndex:i] forState:UIControlStateNormal];
		}else if([[array objectAtIndex:i] isKindOfClass:[NSString class]]){//如果加载的数据对象为字符串
			NSString *title = [array objectAtIndex:i];
			//设置排列模式（横或纵）
			if(self.orientationType != 1){//为横向情况下
				if(self.btnSize.width != 0 && self.btnSize.height != 0){
					button.frame = CGRectMake(currentWidth, 0, self.btnSize.width, self.btnSize.height);
					currentWidth += (self.btnSize.width+self.distance);
                } else if (self.arrayBtnSize && self.arrayBtnSize.count >= i + 1) {
                    CGSize size = CGSizeFromString(self.arrayBtnSize[i]);
                    button.frame = CGRectMake(currentWidth, 0, size.width, size.height);
                    currentWidth += (size.width+self.distance);
                } else {
					CGSize size = [title SIZE_WITH_FONT(button.titleLabel.font)];
					button.frame = CGRectMake(currentWidth, 0, size.width+10, size.height+10);
					currentWidth+=(size.width+self.distance);
				}
				button.center = CGPointMake(button.center.x, self.frame.size.height*0.5);
			}else {
				if(self.btnSize.width != 0 && self.btnSize.height != 0){
					button.frame = CGRectMake(0, currentHeight, self.btnSize.width, self.btnSize.height);
					currentHeight += self.btnSize.height+self.distance;
                } else if (self.arrayBtnSize && self.arrayBtnSize.count >= i + 1) {
                    CGSize size = CGSizeFromString(self.arrayBtnSize[i]);
                    button.frame = CGRectMake(currentWidth, 0, size.width, size.height);
                    currentWidth += (size.width+self.distance);
                } else {
					CGSize size = [title SIZE_WITH_FONT(button.titleLabel.font)];
					button.frame = CGRectMake(0, currentHeight, size.width+10, size.height+10);
					currentHeight += (size.height+10);
				}
				button.center=CGPointMake(self.frame.size.width*0.5,button.center.y);
			}
            
			button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
			button.titleLabel.textAlignment = NSTextAlignmentCenter;
			[button setTitle:title forState:UIControlStateNormal];
			if([title isEqualToString:@""]){
                button.hidden=YES;
            }
			if(self.btnBG){
				button.backgroundColor=[UIColor colorWithPatternImage:self.btnBG];
            }
		}
        
        if (!self.closeAniamtion) {
            [button addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchDragInside];
            [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchDragOutside];
        }
		[button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
		
		//添加左图标
		if(self.buttonImageIcons != nil && [self.buttonImageIcons count] > i && ![[self.buttonImageIcons objectAtIndex:i] isEqualToString:@""]){
            UIImage *buttonImageIcon=[UIImage imageNamed:[self.buttonImageIcons objectAtIndex:i]];
            [button setImage:buttonImageIcon forState:UIControlStateNormal];
            [button setImage:buttonImageIcon forState:UIControlStateHighlighted];
		}
        if (self.buttonImageSelectedIcons && [self.buttonImageSelectedIcons count] > i && ![[self.buttonImageSelectedIcons objectAtIndex:i] isEqualToString:@""]) {
            UIImage *buttonImageSelectedIcon=[UIImage imageNamed:[self.buttonImageSelectedIcons objectAtIndex:i]];
            [button setImage:buttonImageSelectedIcon forState:UIControlStateSelected];
            [button setImage:buttonImageSelectedIcon forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
		[self.mScrollView addSubview:button];
        
		if(self.selectedIndex == i){
			self.btnSelected = button;
			self.highlightedBackgroundImageView.frame = button.frame;
			self.selectedBackgroundImageView.center = CGPointMake(button.center.x, self.selectedBackgroundImageView.center.y);
		}
	}
    
    //添加分割线
    if (self.imgSep) {
        for(NSInteger i = 0; i < count - 1; i++) {
            UIButton *btn = self.btnControls[i];
            UIImageView *imgvSep = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x + btn.frame.size.width, 0, 1, self.bounds.size.height)];
            imgvSep.contentMode = UIViewContentModeCenter;
            imgvSep.image = self.imgSep;
            [self.mScrollView addSubview:imgvSep];
        }
    }
    
	[self buttonAction:self.btnSelected];
    
	if(self.orientationType != 1){//0为横向 1为枞向
		currentWidth = currentWidth-self.distance;
        CGRect rect = self.backgroundImageView.frame;
        if (self.isBackGroundImageViewWithIsFull) {
            self.backgroundImageView.frame=CGRectMake(rect.origin.x,rect.origin.y,self.frame.size.width,self.frame.size.height);
        } else {
            if(currentWidth < self.frame.size.width && currentWidth > 0){
                self.backgroundImageView.frame=CGRectMake(rect.origin.x,rect.origin.y,currentWidth,rect.size.height);
            }
        }
        if (CGSizeEqualToSize(self.btnSize, CGSizeZero) || self.btnSize.width <= 0) {   //如果没设置按钮size，则加10间距
            self.mScrollView.contentSize=CGSizeMake(currentWidth+self.distance,self.frame.size.height);
        } else {
            self.mScrollView.contentSize=CGSizeMake(currentWidth,self.frame.size.height);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmented:withCurrentDisplayAllow:)]) {
            if (self.mScrollView.contentSize.width <= self.mScrollView.frame.size.width) {
                [self.delegate segmented:self withCurrentDisplayAllow:CurrentDisplayAllowNo];
            }else{
                [self scrollViewDidScroll:self.mScrollView];
            }
        }
	}else {
		self.mScrollView.contentSize=CGSizeMake(self.frame.size.width,currentHeight);
	}
}

-(void)setBtnBG:(UIImage *)image
{
    _btnBG = image;
	[self _setBtnBG:image];
}

-(void)setSelectedBG:(UIImage *)image
{
    _selectedBG = image;
	[self _setSelectedBG:image];
}

-(void)setSelectedTitleColor:(UIColor *)color
{
    _selectedTitleColor = color;
	if(self.btnSelected){
		[self.btnSelected setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
	}
}

-(void)setBtnSize:(CGSize)size
{
	_btnSize = size;
	int count = (int)[self.btnControls count];
	self.mScrollView.contentSize = CGSizeMake(count*(size.width+self.distance), self.mScrollView.frame.size.height);
	for (int i = 0; i < count; i++) {
		UIButton *oneButton = [self.btnControls objectAtIndex:i];
		if(oneButton){
			oneButton.frame = CGRectMake(i*size.width, 0, size.width, size.height);
			oneButton.center = CGPointMake(oneButton.center.x, self.frame.size.height*0.5);
		}
	}
}

- (void)setButtonImageIcons:(NSArray *)buttonImageIcons
{
    _buttonImageIcons = buttonImageIcons;
    
    if (self.btnControls && self.btnControls.count > 0) {
        for (NSInteger i = 0; i < self.btnControls.count; i++) {
            UIButton *button = self.btnControls[i];
            //添加左图标
            if(self.buttonImageIcons != nil && [self.buttonImageIcons count] > i && ![[self.buttonImageIcons objectAtIndex:i] isEqualToString:@""]){
                UIImage *buttonImageIcon=[UIImage imageNamed:[self.buttonImageIcons objectAtIndex:i]];
                [button setImage:buttonImageIcon forState:UIControlStateNormal];
                [button setImage:buttonImageIcon forState:UIControlStateHighlighted];
            }
        }
    }
}

- (void)setButtonImageSelectedIcons:(NSArray *)buttonImageSelectedIcons
{
    _buttonImageSelectedIcons = buttonImageSelectedIcons;
    
    if (self.btnControls && self.btnControls.count > 0) {
        for (NSInteger i = 0; i < self.btnControls.count; i++) {
            UIButton *button = self.btnControls[i];
            if (self.buttonImageSelectedIcons && [self.buttonImageSelectedIcons count] > i && ![[self.buttonImageSelectedIcons objectAtIndex:i] isEqualToString:@""]) {
                UIImage *buttonImageSelectedIcon=[UIImage imageNamed:[self.buttonImageSelectedIcons objectAtIndex:i]];
                [button setImage:buttonImageSelectedIcon forState:UIControlStateSelected];
                [button setImage:buttonImageSelectedIcon forState:UIControlStateSelected | UIControlStateHighlighted];
            }
        }
    }
}

- (void)setArrayBtnSize:(NSArray *)arrayBtnSize
{
    _arrayBtnSize = arrayBtnSize;
    
    if (arrayBtnSize) {
        self.mScrollView.contentSize = CGSizeZero;
        int count = (int)[self.btnControls count];
        for (int i = 0; i < count; i++) {
            UIButton *oneButton = [self.btnControls objectAtIndex:i];
            CGSize size = CGSizeFromString(arrayBtnSize[i]);
            if(oneButton){
                oneButton.frame = CGRectMake(self.mScrollView.contentSize.width, 0, size.width, size.height);
                oneButton.center = CGPointMake(oneButton.center.x, self.frame.size.height*0.5);
            }
            self.mScrollView.contentSize = CGSizeMake(self.mScrollView.contentSize.width+(size.width+self.distance), self.mScrollView.frame.size.height);
        }
    }
}

//创建button（在设置attributeedtitles后才能调用）
- (void)createButtonWithHadSetAttributedTitles {
    self.backgroundImageView.frame=CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    //清除
    for (int i=0; i < [self.btnControls count]; i++) {
        UIButton *button = [self.btnControls objectAtIndex:i];
        if(button){
            [button removeFromSuperview];
        }
    }
    self.btnSelected = nil;
    [self.btnControls removeAllObjects];
    
    if(_validFrame.size.width != 0 && _validFrame.size.height != 0){
        self.mScrollView.frame = _validFrame;
    }else {
        self.mScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    //添加按钮
    float currentWidth = self.leftMarage;
    float currentHeight = 0;
    int count = (int)[self.attributedTitles count];
    for(int i=0; i<count; i++){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i;
        if(self.titleColor){
            [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        } else if (self.arrayTitlesColor && self.arrayTitlesColor.count > button.tag) {
            [button setTitleColor:self.arrayTitlesColor[button.tag] forState:UIControlStateNormal];
        }
        if(self.titleFont){
            button.titleLabel.font=self.titleFont;
        }
        //设置image在文字左边或右边,前提是有image图片
        if(self.buttonImageIcons != nil && [self.buttonImageIcons count] > i && ![[self.buttonImageIcons objectAtIndex:i] isEqualToString:@""]){
            UIImage *buttonImageIcon=[UIImage imageNamed:[self.buttonImageIcons objectAtIndex:i]];
            if (buttonImageIcon) {
                if (!UIEdgeInsetsEqualToEdgeInsets(self.iconInsets, UIEdgeInsetsZero) || !UIEdgeInsetsEqualToEdgeInsets(self.titleInsets, UIEdgeInsetsZero)) {
                    button.imageEdgeInsets = self.iconInsets;
                    button.titleEdgeInsets = self.titleInsets;
                } else {
                    if (!self.arrayBtnImageOrientation || self.arrayBtnImageOrientation.count <= i || [self.arrayBtnImageOrientation[i] integerValue] == CurrentDisplayAllowLeft) { //左边
                        button.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
                        button.titleEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
                    } else {    //右边
                        NSMutableAttributedString *attributedTitle = [self.attributedTitles objectAtIndex:i];
                        CGSize size = SIZE_WITH_ATTRIBUTEDSTRING(attributedTitle);
                        button.titleEdgeInsets = UIEdgeInsetsMake(0, -buttonImageIcon.size.width * 2 - 3, 0, 0);
                        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -size.width * 2 - 3);
                    }
                }
            }
        }
        
        [self.btnControls addObject:button];//将控件添加到数组中 便于管理
        
        //如果加载的数据对象为图片
        if([[self.attributedTitles objectAtIndex:i] isKindOfClass:[UIImage class]]){
            [button setImage:[self.attributedTitles objectAtIndex:i] forState:UIControlStateNormal];
        }else if([[self.attributedTitles objectAtIndex:i] isKindOfClass:[NSAttributedString class]]){//如果加载的数据对象为字符串
            NSMutableAttributedString *attributedTitle = [self.attributedTitles objectAtIndex:i];
            //设置排列模式（横或纵）
            if(self.orientationType != 1){//为横向情况下
                if(self.btnSize.width != 0 && self.btnSize.height != 0){
                    button.frame = CGRectMake(currentWidth, 0, self.btnSize.width, self.btnSize.height);
                    currentWidth += (self.btnSize.width+self.distance);
                } else if (self.arrayBtnSize && self.arrayBtnSize.count >= i + 1) {
                    CGSize size = CGSizeFromString(self.arrayBtnSize[i]);
                    button.frame = CGRectMake(currentWidth, 0, size.width, size.height);
                    currentWidth += (size.width+self.distance);
                } else {
                    CGSize size = SIZE_WITH_ATTRIBUTEDSTRING(attributedTitle);
                    button.frame = CGRectMake(currentWidth, 0, size.width+10, size.height+10);
                    currentWidth+=(size.width+self.distance);
                }
                button.center = CGPointMake(button.center.x, self.frame.size.height*0.5);
            }else {
                if(self.btnSize.width != 0 && self.btnSize.height != 0){
                    button.frame = CGRectMake(0, currentHeight, self.btnSize.width, self.btnSize.height);
                    currentHeight += self.btnSize.height+self.distance;
                } else if (self.arrayBtnSize && self.arrayBtnSize.count >= i + 1) {
                    CGSize size = CGSizeFromString(self.arrayBtnSize[i]);
                    button.frame = CGRectMake(currentWidth, 0, size.width, size.height);
                    currentWidth += (size.width+self.distance);
                } else {
                    CGSize size = SIZE_WITH_ATTRIBUTEDSTRING(attributedTitle);
                    button.frame = CGRectMake(0, currentHeight, size.width+10, size.height+10);
                    currentHeight += (size.height+10);
                }
                button.center=CGPointMake(self.frame.size.width*0.5,button.center.y);
            }
            
            button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
            if(self.attributedHightlightTitles.count > i){
                [button setAttributedTitle:self.attributedHightlightTitles[i] forState:UIControlStateHighlighted];
            }
            if(self.btnBG){
                button.backgroundColor=[UIColor colorWithPatternImage:self.btnBG];
            }
        }
        
        if (!self.closeAniamtion) {
            [button addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchDragInside];
            [button addTarget:self action:@selector(buttonTouchedOther:) forControlEvents:UIControlEventTouchDragOutside];
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加左图标
        if(self.buttonImageIcons != nil && [self.buttonImageIcons count] > i && ![[self.buttonImageIcons objectAtIndex:i] isEqualToString:@""]){
            UIImage *buttonImageIcon=[UIImage imageNamed:[self.buttonImageIcons objectAtIndex:i]];
            [button setImage:buttonImageIcon forState:UIControlStateNormal];
            [button setImage:buttonImageIcon forState:UIControlStateHighlighted];
        }
        if (self.buttonImageSelectedIcons && [self.buttonImageSelectedIcons count] > i && ![[self.buttonImageSelectedIcons objectAtIndex:i] isEqualToString:@""]) {
            UIImage *buttonImageSelectedIcon=[UIImage imageNamed:[self.buttonImageSelectedIcons objectAtIndex:i]];
            [button setImage:buttonImageSelectedIcon forState:UIControlStateSelected];
            [button setImage:buttonImageSelectedIcon forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        [self.mScrollView addSubview:button];
        
        if(self.selectedIndex == i){
            self.btnSelected = button;
            self.highlightedBackgroundImageView.frame = button.frame;
            self.selectedBackgroundImageView.center = CGPointMake(button.center.x, self.selectedBackgroundImageView.center.y);
        }
    }
    
    //添加分割线
    if (self.imgSep) {
        for(NSInteger i = 0; i < count - 1; i++) {
            UIButton *btn = self.btnControls[i];
            UIImageView *imgvSep = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x + btn.frame.size.width, 0, 1, self.bounds.size.height)];
            imgvSep.contentMode = UIViewContentModeCenter;
            imgvSep.image = self.imgSep;
            [self.mScrollView addSubview:imgvSep];
        }
    }
    
    [self buttonAction:self.btnSelected];
    
    if(self.orientationType != 1){//0为横向 1为枞向
        currentWidth = currentWidth-self.distance;
        CGRect rect = self.backgroundImageView.frame;
        if (self.isBackGroundImageViewWithIsFull) {
            self.backgroundImageView.frame=CGRectMake(rect.origin.x,rect.origin.y,self.frame.size.width,self.frame.size.height);
        } else {
            if(currentWidth < self.frame.size.width && currentWidth > 0){
                self.backgroundImageView.frame=CGRectMake(rect.origin.x,rect.origin.y,currentWidth,rect.size.height);
            }
        }
        if (CGSizeEqualToSize(self.btnSize, CGSizeZero) || self.btnSize.width <= 0) {   //如果没设置按钮size，则加10间距
            self.mScrollView.contentSize=CGSizeMake(currentWidth+self.distance,self.frame.size.height);
        } else {
            self.mScrollView.contentSize=CGSizeMake(currentWidth,self.frame.size.height);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmented:withCurrentDisplayAllow:)]) {
            if (self.mScrollView.contentSize.width <= self.mScrollView.frame.size.width) {
                [self.delegate segmented:self withCurrentDisplayAllow:CurrentDisplayAllowNo];
            }else{
                [self scrollViewDidScroll:self.mScrollView];
            }
        }
    }else {
        self.mScrollView.contentSize=CGSizeMake(self.frame.size.width,currentHeight);
    }
}

-(void)setTitle:(id)object index:(NSInteger)index
{
	if([object isKindOfClass:[UIImage class]]){
		NSArray *array = [self.mScrollView subviews];
		UIButton *button = [array objectAtIndex:index];
		[button setImage:object forState:UIControlStateNormal];
	}
    

}


-(void)setSelectedIndex:(NSInteger)index
{
    if((NSInteger)[self.btnControls count] > index && index >= 0) {
        UIButton *button = [self.btnControls objectAtIndex:index];
        [self.mScrollView scrollRectToVisible:button.frame animated:YES];
        [self buttonAction:button];
    } else {
        self.selectedBackgroundImageView.hidden = YES;
        if(self.titleColor){
            [self.btnSelected setTitleColor:self.titleColor forState:UIControlStateNormal];
        } else if (self.arrayTitlesColor && self.arrayTitlesColor.count > self.btnSelected.tag) {
            [self.btnSelected setTitleColor:self.arrayTitlesColor[self.btnSelected.tag] forState:UIControlStateNormal];
        }
//        if (self.attributedTitles && self.attributedTitles.count > self.btnSelected.tag) {
//            [self.btnSelected setAttributedTitle:self.attributedTitles[self.btnSelected.tag] forState:UIControlStateNormal];
//        }
//        if (self.attributedHightlightTitles && self.attributedHightlightTitles.count > self.btnSelected.tag) {
//            [self.btnSelected setAttributedTitle:self.attributedHightlightTitles[self.btnSelected.tag] forState:UIControlStateHighlighted];
//        }
        self.btnSelected.selected = NO;
    }
    
	_selectedIndex = index;
}

#pragma mark ---------------------------------
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmented:withCurrentDisplayAllow:)]) {
        if (scrollView.contentOffset.x <= 0 && self.orientationType == 0){//横向模式且offset.x<=0,说明在最左边
            if (self.currentDisplayAllow != CurrentDisplayAllowRight){//显示箭头指向右边
                [self.delegate segmented:self withCurrentDisplayAllow:CurrentDisplayAllowRight];
                self.currentDisplayAllow = CurrentDisplayAllowRight;
            }
        }else if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)){//说明在最右边
            if (self.currentDisplayAllow != CurrentDisplayAllowLeft){
                [self.delegate segmented:self withCurrentDisplayAllow:CurrentDisplayAllowLeft]; //显示箭头指向左边
                self.currentDisplayAllow = CurrentDisplayAllowLeft;
            }
        }else{
            if (self.currentDisplayAllow != CurrentDisplayAllowAll){
                [self.delegate segmented:self withCurrentDisplayAllow:CurrentDisplayAllowAll]; //显示箭头指向左右两边
                self.currentDisplayAllow = CurrentDisplayAllowAll;
            }
        }
    }
}

@end
