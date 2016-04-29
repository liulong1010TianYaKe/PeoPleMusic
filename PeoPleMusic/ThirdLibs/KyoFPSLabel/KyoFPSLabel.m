//
//  KyoFPSLabel.m
//  MainApp
//
//  Created by Kyo on 12/3/15.
//  Copyright © 2015 zhunit. All rights reserved.
//

#import "KyoFPSLabel.h"

@interface KyoFPSLabel()

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) NSUInteger count;
@property (assign, nonatomic) NSTimeInterval lastTime;

- (void)displayLinkAction:(CADisplayLink *)displayLink;

@end

@implementation KyoFPSLabel

#pragma mark --------------------
#pragma mark - CycLife

+ (KyoFPSLabel *)createInWindow:(CGRect)rect {
#ifdef DEBUG
    KyoFPSLabel *label = [[KyoFPSLabel alloc] initWithFrame:rect];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:label];
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:label selector:@selector(displayLinkAction:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];;
    label.displayLink = displayLink;
    
    return label;
#else
    return nil;
#endif
    
}

- (void)dealloc {
    [_displayLink invalidate];
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

#pragma mark --------------------
#pragma mark - Events

- (void)displayLinkAction:(CADisplayLink *)displayLink {
    if (_lastTime == 0) {
        _lastTime = displayLink.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = displayLink.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = displayLink.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    self.textColor = color;
    
    NSString *str = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    self.text = str;
}

#pragma mark --------------------
#pragma mark - Methods

#pragma mark --------------------
#pragma mark - Delegate

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC



@end
