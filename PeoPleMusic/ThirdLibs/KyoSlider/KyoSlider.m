//
//  KyoSlider.m
//  KyoSliderDemo
//
//  Created by Kyo on 25/9/15.
//  Copyright © 2015 hzins. All rights reserved.
//

#import "KyoSlider.h"
#include <objc/runtime.h>

@interface KyoSlider()
{
    UIImage *_imgSlider; /**< 滑块图片 */
    UIImage *_imgSelected;   /**< 滑块填充图 */
}

- (void)setupDefault;
- (NSDictionary *)getPropertyNameList;  //获取所有属性
- (void)observeAllProperty; //监听所有属性变化
- (void)removeObserveAllProperty;   //移除监听所有属性变化
- (BOOL)checkCanChangeValueWithTouch:(CGPoint)point;    /**< 判断当前点中的坐标是否能改变滑块值 */

@end

@implementation KyoSlider

#pragma mark --------------------
#pragma mark - CycLife

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
    //圆角
    self.layer.cornerRadius = _radius;
    self.layer.masksToBounds = YES;
    
    //画背景
    if (_imgBackground) {
        [_imgBackground drawInRect:self.bounds];
    }
    
    //判断如果有设置段，且每段图片不一样，则需要根据当前所在段更换图片
    if (_arrayImageSection && _sectionCount > 0) {
        if (_currentValue == 0) {
            _imgSelected = _imgDefaultSelected;
            _imgSlider = _imgDefaultSlider;
        } else {
            NSInteger currentSection = _currentValue / (_maxValue / (CGFloat)_sectionCount);
//            currentSection = currentSection > _arrayImageSection.count - 1 ? _arrayImageSection.count - 1 : currentSection;
//            if (_arrayImageSection.count > currentSection) {
//                NSDictionary *dictImage = _arrayImageSection[currentSection];
//                _imgSelected = dictImage[@"imgSelected"];
//                _imgSlider = dictImage[@"imgSlider"];
//            }
            KyoLog(@" -- %f",_currentValue);
            NSDictionary *dictImage = nil;
            if (_arrayImageSection.count >= 3)
            {
                switch (currentSection) {
                    case 0:
                    case 1:
                        dictImage = _arrayImageSection[0];
                        break;
                    case 2:
                    case 3:
                        dictImage = _arrayImageSection[1];
                        break;
                    case 4:
                    case 5:
                        dictImage = _arrayImageSection[2];
                        break;
                    default:
                        break;
                }
                //处理正好2分，显示很差情况
                if (_currentValue == 2.0)
                {
                    dictImage = _arrayImageSection[0];
                }
                //
                if ( 3.5 < _currentValue && _currentValue < 4.0)
                {
                    dictImage = _arrayImageSection[2];
                }
                _imgSelected = dictImage[@"imgSelected"];
                _imgSlider = dictImage[@"imgSlider"];
            }
        }
    } else {
        _imgSelected = _imgDefaultSelected;
        _imgSlider = _imgDefaultSlider;
    }
    
    //画选中部分
    CGFloat scoreScale = _currentValue / _maxValue;
    CGFloat scoreWidth = (self.bounds.size.width - _sliderSize.width) * scoreScale + _sliderSize.width;
    if ((NSInteger)scoreWidth == (NSInteger)_sliderSize.width) {
        scoreWidth += 2;
    }
    if (_imgSelected) {
        [_imgSelected drawInRect:CGRectMake(0, 0, scoreWidth, self.bounds.size.height)];
    }
    
    //画分段
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);    //设置画笔为1像素
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor);   //设置画笔颜色
    for (NSInteger i = 1; i < _sectionCount; i++) {
        CGFloat x = i * self.bounds.size.width / _sectionCount;
        CGContextMoveToPoint(context, x, 0);    //设置开始坐标
        CGContextAddLineToPoint(context, x, self.bounds.size.height);   //设置结束坐标
        CGContextStrokePath(context);   //开始画到画布上
    }
    
    //画滑块那个圆
    if (_imgSlider && !CGSizeEqualToSize(_sliderSize, CGSizeZero)) {
        CGFloat sliderX = (self.bounds.size.width - _sliderSize.width) * scoreScale;
        if (sliderX < 1) {
            sliderX += 2;
        }
        [_imgSlider drawInRect:CGRectMake(sliderX + _sliderInset.x, 0 + _sliderInset.y, _sliderSize.width, _sliderSize.height)];
    }
}

#pragma mark --------------------
#pragma mark - Methods

- (void)setupDefault {
    if ([UIApplication sharedApplication].delegate) {
        [self observeAllProperty];  //监听所有属性变化
    }
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

/**< 判断当前点中的坐标是否能改变滑块值 */
- (BOOL)checkCanChangeValueWithTouch:(CGPoint)point {
    CGFloat scoreScale = _currentValue / _maxValue;
    CGFloat scoreWidth = (self.bounds.size.width - _sliderSize.width) * scoreScale + _sliderSize.width;
    if ((NSInteger)scoreWidth == (NSInteger)_sliderSize.width) {
        scoreWidth += 2;
    }
    if (_imgSlider && !CGSizeEqualToSize(_sliderSize, CGSizeZero)) {
        CGFloat sliderX = (self.bounds.size.width - _sliderSize.width) * scoreScale;
        if (sliderX < 1) {
            sliderX += 2;
        }
        
        if (sliderX <= point.x &&
            sliderX + _sliderSize.width >= point.x) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark ----------------
#pragma mark - KVC/KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}

#pragma mark --------------------
#pragma mark - UITouch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //判断如果当前点击在滑块上，则不改变值
    if (![self checkCanChangeValueWithTouch:point]) {
        return;
    }
    
    CGFloat value = point.x * _maxValue / self.bounds.size.width;
    value = value > _maxValue ? _maxValue : value;
    value = value < _minValue ? _minValue : value;
    self.currentValue = value;
    
    if (self.kyoSliderDelegate &&
        [self.kyoSliderDelegate respondsToSelector:@selector(kyoSliderValueChange:)]) {
        [self.kyoSliderDelegate kyoSliderValueChange:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    CGFloat value = point.x * _maxValue / self.bounds.size.width;
    value = value > _maxValue ? _maxValue : value;
    value = value < _minValue ? _minValue : value;
    self.currentValue = value;
    
    if (self.kyoSliderDelegate &&
        [self.kyoSliderDelegate respondsToSelector:@selector(kyoSliderValueChange:)]) {
        [self.kyoSliderDelegate kyoSliderValueChange:self];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //判断如果当前点击在滑块上，则不改变值
    if (![self checkCanChangeValueWithTouch:point]) {
        return;
    }

    CGFloat value = point.x * _maxValue / self.bounds.size.width;
    value = value > _maxValue ? _maxValue : value;
    value = value < _minValue ? _minValue : value;
    self.currentValue = value;
    
    if (self.kyoSliderDelegate &&
        [self.kyoSliderDelegate respondsToSelector:@selector(kyoSliderValueChange:)]) {
        [self.kyoSliderDelegate kyoSliderValueChange:self];
    }
}


@end
