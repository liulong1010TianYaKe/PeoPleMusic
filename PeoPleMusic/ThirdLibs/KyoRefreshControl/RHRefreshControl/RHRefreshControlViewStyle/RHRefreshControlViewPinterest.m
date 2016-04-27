//
//  RHRefreshControlViewPinterest.m
//  Example
//
//  Created by Ratha Hin on 2/2/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "RHRefreshControlViewPinterest.h"
#import "RHAnimator.h"

@interface RHRefreshControlViewPinterest ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) CALayer *iconLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation RHRefreshControlViewPinterest

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self commonSetupOnInit];
    }
    return self;
}

- (void)commonSetupOnInit {
    _fillColor = [UIColor clearColor];
    _strokeColor =    [UIColor redColor];  
    _imgContent = [UIImage imageNamed:@"com_refresh_icon"];
    
  CAShapeLayer *circle = [CAShapeLayer layer];
  circle.frame = CGRectMake(0, 0, 25.0f, 25.0f);
  circle.contentsGravity = kCAGravityCenter;
  
  UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:circle.position
                                                            radius:CGRectGetMidX(circle.bounds)
                                                        startAngle:0
                                                          endAngle:(360) / 180.0 * M_PI
                                                         clockwise:NO];
  circle.path = circlePath.CGPath;
  
  circle.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-10);    //设置动画圆圈坐标
  circle.fillColor = [UIColor clearColor].CGColor;
  circle.strokeColor = _strokeColor.CGColor;
  circle.lineWidth =2.0f;
  circle.strokeEnd = 0.0f;
    circle.opacity = 0.0f;
  [[self layer] addSublayer:circle];
  self.circleLayer = circle;
  
  CALayer *layer = [CALayer layer];
  layer.frame = CGRectMake(0, 0, 24.0f, 24.0f);
  layer.contentsGravity = kCAGravityCenter;
//    if ([[NSBundle mainBundle] pathForResource:@"com_refresh_icon" ofType:@".png"]) {
        layer.contents = (id)_imgContent.CGImage;
//    }
  
  layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-10); //设置刷新图片坐标
    layer.opacity = 0.0f;
  [[self layer] addSublayer:layer];
  self.iconLayer=layer;
  self.iconLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
  
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
    layer.contentsScale = [[UIScreen mainScreen] scale];
  }
#endif
  
  UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  view.frame = CGRectMake(0, 0, 20.0f, 20.0f);
  view.hidesWhenStopped = YES;
  view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-10);
  [self addSubview:view];
  self.activityView = view;
  
  self.backgroundColor = [UIColor clearColor];  //设置背景颜色
}

//重置子视图的坐标
- (void)reChangeSubViewOrgin {
    //设置position有显示动画，所以这里要关闭动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];//关闭动画
    
    if (self.circleLayer) {
        self.circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-10);    //设置动画圆圈坐标
    }
    
    if (self.iconLayer) {
        self.iconLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-10); //设置刷新图片坐标
    }
    
    [CATransaction commit];
    
    if (self.activityView) {
        self.activityView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-10);
    }
}

- (void)updateViewWithPercentage:(CGFloat)percentage state:(NSInteger)state {
  CGFloat deltaRotate = percentage * 180;
  CGFloat angelDegree = (180.0 - deltaRotate);
  
  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
  self.iconLayer.transform = CATransform3DMakeRotation((angelDegree) / 180.0 * M_PI, 0.0f, 0.0f, 1.0f);
  self.circleLayer.strokeEnd = percentage;
  if (state != RHRefreshStateLoading) {
    self.iconLayer.opacity = percentage;
    self.circleLayer.opacity = percentage;
  }
  [CATransaction commit];
}

- (void)updateViewOnNormalStatePreviousState:(NSInteger)state {
  if (state == RHRefreshStatePulling) {
    self.iconLayer.opacity = 0;
    self.circleLayer.opacity = 0;
  }
  
  [_activityView stopAnimating];
}

- (void)updateViewOnPullingStatePreviousState:(NSInteger)state {
  
}

- (void)updateViewOnLoadingStatePreviousState:(NSInteger)state {
  [self.activityView startAnimating];
  self.iconLayer.opacity = 0;
  self.circleLayer.opacity = 0;
  CATransform3D fromMatrix = CATransform3DMakeScale(0.0, 0.0, 0.0);
  CATransform3D toMatrix = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
  CAKeyframeAnimation *animation = [RHAnimator animationWithCATransform3DForKeyPath:@"transform"
                                                                     easingFunction:RHElasticEaseOut
                                                                         fromMatrix:fromMatrix
                                                                           toMatrix:toMatrix];
  animation.duration = 1.0f;
  animation.removedOnCompletion = NO;
  [self.activityView.layer addAnimation:animation forKey:@"transform"];
}

@end
