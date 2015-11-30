//
//  KyoTagView.m
//  XFLH
//
//  Created by Kyo on 7/23/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoTagView.h"
#include <objc/runtime.h>

@interface KyoTagView()

@property (strong, nonatomic) UIButton *btn;


- (void)btnTouchIn:(UIButton *)btn;

- (void)setupDefault;   //设置默认属性值
- (NSMutableAttributedString *)getAttributedStringTitle:(NSString *)title;  //根据文字获得attributedstring
- (NSMutableAttributedString *)getAttributedStringAttributedTitle:(NSMutableAttributedString *)attributedTitle;  //根据文字获得attributedstring
- (NSDictionary *)getPropertyNameList;  //获取所有属性
- (void)observeAllProperty; //监听所有属性变化
- (void)removeObserveAllProperty;   //移除监听所有属性变化
- (UIImage *)createImageWithColor:(UIColor *)color; //将UIColor变换为UIImage

@end

@implementation KyoTagView

#pragma mark --------------------
#pragma mark - CycLife

- (id)initWithTitle:(id)title withPoint:(CGPoint)point withMargin:(CGSize)marginSize {
    return [self initWithTitle:title withPoint:point withMargin:marginSize withIcon:nil];
}

- (id)initWithTitle:(id)title withPoint:(CGPoint)point withMargin:(CGSize)marginSize withIcon:(UIImage *)imageIcon {
    return [self initWithTitle:title withPoint:point withMargin:marginSize withIcon:imageIcon withFontSize:9];
}

- (id)initWithTitle:(id)title withPoint:(CGPoint)point withMargin:(CGSize)marginSize withIcon:(UIImage *)imageIcon withFontSize:(CGFloat)fontSize {
    self = [super init];
    if (self) {
        _title = [title isKindOfClass:[NSString class]] ? title : nil;
        _attributedTitle = [title isKindOfClass:[NSAttributedString class]] ? title : nil;
        _imageIcon = imageIcon;
        _fontSize = fontSize;
        [self setupDefault];
        
        //计算size
        NSMutableAttributedString *attributedStringTitle = _title ? [self getAttributedStringTitle:_title] : [self getAttributedStringAttributedTitle:_attributedTitle];
        CGSize titleSize = [attributedStringTitle boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size;
        CGSize iconSize = _imageIcon ? _imageIcon.size : CGSizeZero;  //icon的size
        CGSize maxSize = CGSizeMake(fmax(titleSize.width, iconSize.width), fmax(titleSize.height, iconSize.height));  //标题size和图标size的最大size
        CGSize realSize = CGSizeMake(maxSize.width + marginSize.width + (imageIcon ? _space : 0),
                                     maxSize.height + marginSize.height);  //真实size
        self.frame = CGRectMake(point.x, point.y, realSize.width, realSize.height);
    }
    
    return self;
}

- (id)initWithTitle:(id)title withFrame:(CGRect)frame {
    return [self initWithTitle:title withFrame:frame withIcon:nil];
}

- (id)initWithTitle:(id)title withFrame:(CGRect)frame withIcon:(UIImage *)imageIcon {
    self = [super initWithFrame:frame];
    if (self) {
        _title = [title isKindOfClass:[NSString class]] ? title : nil;
        _attributedTitle = [title isKindOfClass:[NSAttributedString class]] ? title : nil;
        _imageIcon = imageIcon;
        _fontSize = 9;
        [self setupDefault];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefault];
    }
    
    return self;
}

- (void)dealloc {
    if ([UIApplication sharedApplication].delegate) {
        [self removeObserveAllProperty];    //移除监听所有属性变化
    }
}

- (void)drawRect:(CGRect)rect {
    if (_isShowBorder) {
        if (_imageBorder) {
            _imageBorder = [_imageBorder resizableImageWithCapInsets:UIEdgeInsetsMake(_imageBorder.size.height/2 - 1, _imageBorder.size.width/2 - 1, _imageBorder.size.height/2 - 1, _imageBorder.size.width/2 - 1)];
            [_imageBorder drawInRect:rect];
        } else if (_color) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 1.0);
            CGContextSetStrokeColorWithColor(context, _color.CGColor);
            CGPathRef pathBorder = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(_radius, _radius)].CGPath;
            CGContextAddPath(context, pathBorder);
            CGContextDrawPath(context, kCGPathStroke);
            
            self.layer.cornerRadius = _radius;
            self.layer.masksToBounds = YES;
        }
    }
    
    if ((_title && _color) ||
        (_attributedTitle && _color)) {
        NSMutableAttributedString *attributedStringTitle = _title ? [self getAttributedStringTitle:_title] : [self getAttributedStringAttributedTitle:_attributedTitle];
        CGSize titleSize = [attributedStringTitle boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size;
        CGFloat titleTop = (rect.size.height - titleSize.height) / 2.0;
        CGFloat titleLeft = (rect.size.width - titleSize.width) / 2.0;
        if (_imageIcon) {
            if (_direction == KyoTagViewIconDirectionLeft) {
                titleLeft += _space / 2.0;
            } else {
                titleLeft -= _space / 2.0;
            }
        }
        [attributedStringTitle drawAtPoint:CGPointMake(titleLeft, titleTop)];
    }
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.translatesAutoresizingMaskIntoConstraints = NO;
        [_btn addTarget:self action:@selector(btnTouchIn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        NSDictionary *dictViews = @{@"subView" : _btn};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[subView]-(==0)-|" options:0 metrics:nil views:dictViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[subView]-(==0)-|" options:0 metrics:nil views:dictViews]];
    }
    
    if (_touchColor) {
        [_btn setBackgroundImage:[self createImageWithColor:_touchColor] forState:UIControlStateHighlighted];
    } else {
        [_btn setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
    
    if (_disableColor) {
        [_btn setBackgroundImage:[self createImageWithColor:_disableColor] forState:UIControlStateDisabled];
    } else {
        [_btn setBackgroundImage:nil forState:UIControlStateDisabled];
    }
}

#pragma mark --------------------
#pragma mark - Settings

- (void)setTitle:(NSString *)title {
    _title = title;
    
    if (title) {
        _attributedTitle = nil;
    }
}

- (void)setAttributedTitle:(NSMutableAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    
    if (attributedTitle) {
        _title = nil;
    }
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    
    if (_btn) {
        _btn.enabled = enable;
    }
}

#pragma mark --------------------
#pragma mark - Events

- (void)btnTouchIn:(UIButton *)btn {
    if (_kyoTagViewDelegate && [_kyoTagViewDelegate respondsToSelector:@selector(kyoTagViewTouchIn:)]) {
        [_kyoTagViewDelegate kyoTagViewTouchIn:self];
    }
}


#pragma mark --------------------
#pragma mark - Methods

- (void)setupDefault {
    _color = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    _radius = 4;
    _space = 2;
    _iconYInset = 0;
    _isShowBorder = YES;
    _enable = YES;
    
    if ([UIApplication sharedApplication].delegate) {
        [self observeAllProperty];  //监听所有属性变化
    }
}

//根据文字获得attributedstring
- (NSMutableAttributedString *)getAttributedStringTitle:(NSString *)title {
    UIFont *font = [UIFont systemFontOfSize:_fontSize];
    NSMutableAttributedString *attributedStringTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:_color}];
    if (_imageIcon) {
        NSTextAttachment *textAttachmentIcon = [[NSTextAttachment alloc] init];
        textAttachmentIcon.image = _imageIcon;
        if (_direction == KyoTagViewIconDirectionLeft) {
            textAttachmentIcon.bounds = CGRectMake(-_space, _iconYInset, textAttachmentIcon.image.size.width, textAttachmentIcon.image.size.height);
            NSAttributedString *attributedStringArrow = [NSAttributedString attributedStringWithAttachment:textAttachmentIcon];
            [attributedStringTitle insertAttributedString:attributedStringArrow atIndex:0];
        } else {
            textAttachmentIcon.bounds = CGRectMake(_space, _iconYInset, textAttachmentIcon.image.size.width, textAttachmentIcon.image.size.height);
            NSAttributedString *attributedStringArrow = [NSAttributedString attributedStringWithAttachment:textAttachmentIcon];
            [attributedStringTitle insertAttributedString:attributedStringArrow atIndex:title.length];
        }
    }
    
    return attributedStringTitle;
}

//根据文字获得attributedstring
- (NSMutableAttributedString *)getAttributedStringAttributedTitle:(NSMutableAttributedString *)attributedTitle {
    if (_imageIcon) {
        NSTextAttachment *textAttachmentIcon = [[NSTextAttachment alloc] init];
        textAttachmentIcon.image = _imageIcon;
        if (_direction == KyoTagViewIconDirectionLeft) {
            textAttachmentIcon.bounds = CGRectMake(-_space, _iconYInset, textAttachmentIcon.image.size.width, textAttachmentIcon.image.size.height);
            NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:textAttachmentIcon];
            [attributedTitle insertAttributedString:attributedString atIndex:0];
        } else {
            textAttachmentIcon.bounds = CGRectMake(_space, _iconYInset, textAttachmentIcon.image.size.width, textAttachmentIcon.image.size.height);
            NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:textAttachmentIcon];
            [attributedTitle insertAttributedString:attributedString atIndex:attributedTitle.length];
        }
    }
    
    return attributedTitle;
}

//获取所有属性
- (NSDictionary *)getPropertyNameList {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *propertyNameDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *propertyAttributes = property_getAttributes(properties[i]);
        const char *propertyName = property_getName(properties[i]);
        [propertyNameDictionary setObject:[NSString stringWithUTF8String: propertyAttributes] forKey:[NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertyNameDictionary;
}

//监听所有属性变化
- (void)observeAllProperty {
    NSDictionary *dictProperty = [self getPropertyNameList];
    for (NSInteger i = 0; i < dictProperty.allKeys.count; i++) {
        [self addObserver:self forKeyPath:dictProperty.allKeys[i] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
}

//移除监听所有属性变化
- (void)removeObserveAllProperty {
    NSDictionary *dictProperty = [self getPropertyNameList];
    for (NSInteger i = 0; i < dictProperty.allKeys.count; i++) {
        [self removeObserver:self forKeyPath:dictProperty.allKeys[i]];
    }
    
}

//将UIColor变换为UIImage
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,[UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark ----------------
#pragma mark - KVC/KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}


@end
