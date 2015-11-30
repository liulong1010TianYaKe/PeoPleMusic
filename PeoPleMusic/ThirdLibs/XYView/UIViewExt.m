/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIViewExt.h"

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (ViewGeometry)

// Retrieve and set the origin
- (CGPoint) origin
{
	return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
	CGRect newframe = self.frame;
	newframe.origin = aPoint;
	self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
	return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
	CGRect newframe = self.frame;
	newframe.size = aSize;
	self.frame = newframe;
}

// Query other frame locations
- (CGPoint) bottomRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) topRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y;
	return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) height
{
	return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
	CGRect newframe = self.frame;
	newframe.size.height = newheight;
	self.frame = newframe;
}

- (CGFloat) width
{
	return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
	CGRect newframe = self.frame;
	newframe.size.width = newwidth;
	self.frame = newframe;
}

- (CGFloat) top
{
	return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
	CGRect newframe = self.frame;
	newframe.origin.y = newtop;
	self.frame = newframe;
}

- (CGFloat) left
{
	return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
	CGRect newframe = self.frame;
	newframe.origin.x = newleft;
	self.frame = newframe;
}

- (CGFloat) bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
	CGRect newframe = self.frame;
	newframe.origin.y = newbottom - self.frame.size.height;
	self.frame = newframe;
}

- (CGFloat) right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
	CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
	CGRect newframe = self.frame;
	newframe.origin.x += delta ;
	self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
	CGPoint newcenter = self.center;
	newcenter.x += delta.x;
	newcenter.y += delta.y;
	self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
	CGRect newframe = self.frame;
	newframe.size.width *= scaleFactor;
	newframe.size.height *= scaleFactor;
	self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
	CGFloat scale;
	CGRect newframe = self.frame;
	
	if (newframe.size.height && (newframe.size.height > aSize.height))
	{
		scale = aSize.height / newframe.size.height;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	if (newframe.size.width && (newframe.size.width >= aSize.width))
	{
		scale = aSize.width / newframe.size.width;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	self.frame = newframe;	
}
@end

//#import <objc/runtime.h>
//
//@interface UIView (JMWhenTappedBlocks_Private)
//
//- (void)runBlockForKey:(void *)blockKey;
//- (void)setBlock:(JMWhenTappedBlock)block forKey:(void *)blockKey;
//
//- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger) taps touches:(NSUInteger) touches selector:(SEL) selector;
//- (void) addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer;
//- (void) addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer;
//
//@end

//@implementation UIView (JMWhenTappedBlocks)
//
//static char kWhenTappedBlockKey;
//static char kWhenDoubleTappedBlockKey;
//static char kWhenTwoFingerTappedBlockKey;
//static char kWhenTouchedDownBlockKey;
//static char kWhenTouchedUpBlockKey;

//#pragma mark -
//#pragma mark Set blocks
//
//- (void)runBlockForKey:(void *)blockKey {
//    JMWhenTappedBlock block = objc_getAssociatedObject(self, blockKey);
//    if (block) block();
//}
//
//- (void)setBlock:(JMWhenTappedBlock)block forKey:(void *)blockKey {
//    self.userInteractionEnabled = YES;
//    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//#pragma mark -
//#pragma mark When Tapped
//
//- (void)whenTapped:(JMWhenTappedBlock)block {
//    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewWasTapped)];
//    [self addRequiredToDoubleTapsRecognizer:gesture];
//    
//    [self setBlock:block forKey:&kWhenTappedBlockKey];
//}
//
//- (void)whenDoubleTapped:(JMWhenTappedBlock)block {
//    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:2 touches:1 selector:@selector(viewWasDoubleTapped)];
//    [self addRequirementToSingleTapsRecognizer:gesture];
//    
//    [self setBlock:block forKey:&kWhenDoubleTappedBlockKey];
//}
//
//- (void)whenTwoFingerTapped:(JMWhenTappedBlock)block {
//    [self addTapGestureRecognizerWithTaps:1 touches:2 selector:@selector(viewWasTwoFingerTapped)];
//    
//    [self setBlock:block forKey:&kWhenTwoFingerTappedBlockKey];
//}
//
//- (void)whenTouchedDown:(JMWhenTappedBlock)block {
//    [self setBlock:block forKey:&kWhenTouchedDownBlockKey];
//}
//
//- (void)whenTouchedUp:(JMWhenTappedBlock)block {
//    [self setBlock:block forKey:&kWhenTouchedUpBlockKey];
//}

//#pragma mark -
//#pragma mark Callbacks
//
//- (void)viewWasTapped {
//    [self runBlockForKey:&kWhenTappedBlockKey];
//}
//
//- (void)viewWasDoubleTapped {
//    [self runBlockForKey:&kWhenDoubleTappedBlockKey];
//}
//
//- (void)viewWasTwoFingerTapped {
//    [self runBlockForKey:&kWhenTwoFingerTappedBlockKey];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [self runBlockForKey:&kWhenTouchedDownBlockKey];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//    [self runBlockForKey:&kWhenTouchedUpBlockKey];
//}
//
//#pragma mark -
//#pragma mark Helpers
//
//- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector {
//    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
//    tapGesture.delegate = self;
//    tapGesture.numberOfTapsRequired = taps;
//    tapGesture.numberOfTouchesRequired = touches;
//    [self addGestureRecognizer:tapGesture];
//    
//    return tapGesture;
//}
//
//- (void) addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer {
//    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
//        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
//            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
//            if (tapGesture.numberOfTouchesRequired == 1 && tapGesture.numberOfTapsRequired == 1) {
//                [tapGesture requireGestureRecognizerToFail:recognizer];
//            }
//        }
//    }
//}
//
//- (void) addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer {
//    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
//        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
//            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
//            if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
//                [recognizer requireGestureRecognizerToFail:tapGesture];
//            }
//        }
//    }
//}
//
//@end
//
//#pragma mark - 
//#pragma mark -viewExtention

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIView (Addition)

- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)subviewWithTag:(NSInteger)tag{
    
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    return nil;
}

@end
