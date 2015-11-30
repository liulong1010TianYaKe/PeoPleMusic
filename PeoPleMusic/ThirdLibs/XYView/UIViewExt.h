/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);




CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end

//typedef void (^JMWhenTappedBlock)();
//
//@interface UIView (JMWhenTappedBlocks) <UIGestureRecognizerDelegate>
//
//- (void)whenTapped:(JMWhenTappedBlock)block;
//- (void)whenDoubleTapped:(JMWhenTappedBlock)block;
//- (void)whenTwoFingerTapped:(JMWhenTappedBlock)block;
//- (void)whenTouchedDown:(JMWhenTappedBlock)block;
//- (void)whenTouchedUp:(JMWhenTappedBlock)block;
//
//@end

@interface UIView (Addition)

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 * The view controller whose view contains this view.
 */
- (UIViewController*)viewController;

- (id)subviewWithTag:(NSInteger)tag;

@end