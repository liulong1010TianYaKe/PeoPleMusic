//
//  AutoScrollView.m
//  test-32-AutoScrollLabel
//
//  Created by Kyo on 13-8-19.
//  Copyright (c) 2013年 zhuniT All rights reserved.
//

#import "AutoScrollView.h"

#import <QuartzCore/QuartzCore.h>

@interface AutoScrollView()
{
    CGRect currentRect;
    CGSize titleSize;
}

@property (nonatomic, strong) CATextLayer *layer1;
@property (nonatomic, strong) CATextLayer *layer2;

@end

@implementation AutoScrollView

- (void)dealloc {
    [self.layer1 removeAllAnimations];
    [self.layer2 removeAllAnimations];
}

- (void)drawRect:(CGRect)rect
{
    self.clipsToBounds = YES;
    
    currentRect = self.frame;
    titleSize = KyoSizeWithFont(self.title, [UIFont systemFontOfSize:self.fontSize]);
    
    if (titleSize.width > currentRect.size.width)   //如果显示的内容宽度大于视图的宽，则让它滚动吧
    {
        self.layer1 = [CATextLayer layer];
        self.layer1.contentsScale = [[UIScreen mainScreen] scale];  //*设置contentsScale为当前屏幕的scale,以免字体模糊
        self.layer1.frame = CGRectMake(0, 0, titleSize.width + self.distance, titleSize.height);
        self.layer1.anchorPoint = CGPointMake(0, 0.5);
        self.layer1.position = CGPointMake(0, 0);
        
        self.layer1.string = self.title;
        self.layer1.fontSize = self.fontSize;
        self.layer1.foregroundColor = self.color.CGColor;
        [self.layer addSublayer:self.layer1];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.duration = self.duration;
        animation.repeatCount = INFINITY;
        animation.delegate = self;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, titleSize.width + self.distance, self.bounds.size.height / 2);
        CGPathAddLineToPoint(path, nil, -titleSize.width - self.distance, self.bounds.size.height / 2);
        animation.path = path;
        CGPathRelease(path);
        [self.layer1 addAnimation:animation forKey:@"position"];

        self.layer2 = [CATextLayer layer];
        self.layer2.contentsScale = [[UIScreen mainScreen] scale];  //*设置contentsScale为当前屏幕的scale,以免字体模糊
        self.layer2.frame = CGRectMake(0, 0, titleSize.width + self.distance, titleSize.height);
        self.layer2.anchorPoint = CGPointMake(0, 0.5);
        self.layer2.position = CGPointMake(0, self.bounds.size.height / 2);
        
        self.layer2.string = self.title;
        self.layer2.fontSize = self.fontSize;
        self.layer2.foregroundColor = self.color.CGColor;
        [self.layer addSublayer:self.layer2];
        
        CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation2.duration = self.duration;
        animation2.repeatCount = INFINITY;
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, nil, titleSize.width + self.distance, self.bounds.size.height / 2);
        CGPathAddLineToPoint(path2, nil, -titleSize.width - self.distance, self.bounds.size.height / 2);
        animation2.path = path2;
        CGPathRelease(path2);
        [self.layer2 addAnimation:animation2 forKey:@"position2"];
    }
    else
    {
        self.userInteractionEnabled = NO;
        
        self.layer1 = [CATextLayer layer];
        self.layer1.contentsScale = [[UIScreen mainScreen] scale];  //*设置contentsScale为当前屏幕的scale,以免字体模糊
        self.layer1.frame = CGRectMake(0, 0, currentRect.size.width, titleSize.height);
        self.layer1.anchorPoint = CGPointMake(0.5, 0.5);
        self.layer1.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        self.layer1.string = self.title;
        self.layer1.font = (CFStringRef)@"Helvetica";
        self.layer1.fontSize = self.fontSize;
        self.layer1.foregroundColor = self.color.CGColor;
        switch (self.alignmentType) //设置排列对齐方式
        {
            case TextAlignmentTypeLeft:
            {
                self.layer1.alignmentMode = kCAAlignmentLeft;
                break;
            }
            case TextAlignmentTypeCenter:
            {
                self.layer1.alignmentMode = kCAAlignmentCenter;
                break;
            }
            case TextAlignmentTypeRight:
            {
                self.layer1.alignmentMode = kCAAlignmentRight;
                break;
            }
            default:
                break;
        }
        
        [self.layer addSublayer:self.layer1];
    }
}

#pragma mark ---------------------------
#pragma mark - AnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    self.layer1.timeOffset = self.duration / 2; //因为开始滚动时，两个layer都是从右边滚动，所以先把第一个layer设置在中间,这样看起来才是连续的滚动
}

#pragma mark ---------------------------
#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    /*
     *暂停滚动
     */
    CFTimeInterval pausedTime = [self.layer1 convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer1.speed = 0.0;
    self.layer1.timeOffset = pausedTime;
    
    CFTimeInterval pausedTime2 = [self.layer2 convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer2.speed = 0.0;
    self.layer2.timeOffset = pausedTime2;

    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    /*
     *继续滚动
     */
    CFTimeInterval pausedTime1 = [self.layer1 timeOffset];
    self.layer1.speed = 1.0;
    self.layer1.timeOffset = 0.0;
    self.layer1.beginTime = 0.0;
    CFTimeInterval timeSincePause1= [self.layer1 convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime1;
    self.layer1.beginTime = timeSincePause1;
    
    CFTimeInterval pausedTime2 = [self.layer2 timeOffset];
    self.layer2.speed = 1.0;
    self.layer2.timeOffset = 0.0;
    self.layer2.beginTime = 0.0;
    CFTimeInterval timeSincePause2= [self.layer2 convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime2;
    self.layer2.beginTime = timeSincePause2;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    /*
     *继续滚动
     */
    CFTimeInterval pausedTime1 = [self.layer1 timeOffset];
    self.layer1.speed = 1.0;
    self.layer1.timeOffset = 0.0;
    self.layer1.beginTime = 0.0;
    CFTimeInterval timeSincePause1= [self.layer1 convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime1;
    self.layer1.beginTime = timeSincePause1;
    
    CFTimeInterval pausedTime2 = [self.layer2 timeOffset];
    self.layer2.speed = 1.0;
    self.layer2.timeOffset = 0.0;
    self.layer2.beginTime = 0.0;
    CFTimeInterval timeSincePause2= [self.layer2 convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime2;
    self.layer2.beginTime = timeSincePause2;
}

@end
