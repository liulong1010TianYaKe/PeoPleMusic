//
//  UIImage-RoundCorner.m
//  SwapApp
//
//  Created by Yang Gaofeng on 14-9-23.
//  Copyright (c) 2014年 zhunit. All rights reserved.
//

#import "UIImage-RoundCorner.h"

@implementation UIImage (RoundCorner)
- (UIImage*)imageWithRadius:(float) radius
                      width:(float)width
                     height:(float)height
{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(c);
    CGContextMoveToPoint  (c, width, height/2);
    CGContextAddArcToPoint(c, width, height, width/2, height,   radius);
    CGContextAddArcToPoint(c, 0,         height, 0,           height/2, radius);
    CGContextAddArcToPoint(c, 0,         0,         width/2, 0,           radius);
    CGContextAddArcToPoint(c, width, 0,         width,   height/2, radius);
    CGContextClosePath(c);
    
    CGContextClip(c);
    
    [self drawAtPoint:CGPointZero];
    UIImage *converted = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return converted;
}

- (UIImage*)imageWithTopRadius:(float)radius
                         width:(float)width
                        height:(float)height
{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(c);
    CGContextMoveToPoint  (c, width, height/2);
    CGContextAddLineToPoint(c, width, height);
    CGContextAddLineToPoint(c, 0, height);
    CGContextAddLineToPoint(c, 0, height/2);
    CGContextAddArcToPoint(c, 0,         0,         width/2, 0,           radius);
    CGContextAddArcToPoint(c, width, 0,         width,   height/2, radius);
    CGContextClosePath(c);
    
    CGContextClip(c);
    
    [self drawAtPoint:CGPointZero];
    UIImage *converted = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return converted;
}

- (UIImage*)imageWithBottomRadius:(float) radius
                            width:(float)width
                           height:(float)height
{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(c);
    CGContextMoveToPoint  (c, width, height/2);
    CGContextAddArcToPoint(c, width, height, width/2, height,   radius);
    CGContextAddArcToPoint(c, 0,         height, 0,           height/2, radius);
    CGContextAddLineToPoint(c, 0, 0);
    CGContextAddLineToPoint(c, width, 0);
    CGContextAddLineToPoint(c, width, height/2);
    CGContextClosePath(c);
    
    CGContextClip(c);
    
    [self drawAtPoint:CGPointZero];
    UIImage *converted = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return converted;
}
- (UIImage*)imageWithLeftRadius:(float) radius
                          width:(float)width
                         height:(float)height
{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(c);
    CGContextMoveToPoint  (c, width/2, 0);
    CGContextAddLineToPoint(c, width, 0);
    CGContextAddLineToPoint(c, width, height);
    CGContextAddLineToPoint(c, width/2, height);
    CGContextAddArcToPoint(c, 0,         height, 0,           height/2, radius);
    CGContextAddArcToPoint(c, 0,         0,         width/2, 0,           radius);
    CGContextClosePath(c);
    
    CGContextClip(c);
    
    [self drawAtPoint:CGPointZero];
    UIImage *converted = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return converted;
}

- (UIImage*)imageWithRightRadius:(float) radius
                           width:(float)width
                          height:(float)height
{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(c);
    CGContextMoveToPoint  (c, width/2, 0);
    CGContextAddLineToPoint(c, 0, 0);
    CGContextAddLineToPoint(c, 0, height);
    CGContextAddLineToPoint(c, width/2, height);
    CGContextAddArcToPoint(c, width,         height, width,           height/2, radius);
    CGContextAddArcToPoint(c, width,         0,         width/2, 0,           radius);
    CGContextClosePath(c);
    
    CGContextClip(c);
    
    [self drawAtPoint:CGPointZero];
    UIImage *converted = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return converted;
}

- (UIImage*)resizeImageWithNewSize:(CGSize)newSize
{
    CGFloat newWidth = newSize.width;
    CGFloat newHeight = newSize.height;
    // Resize image if needed.
    float width  = self.size.width;
    float height = self.size.height;
    // fail safe
    if (width == 0 || height == 0)
        return self;
    
    //float scale;
    
    if (width != newWidth || height != newHeight) {
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        
        UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //NSData *jpeg = UIImageJPEGRepresentation(image, 0.8);
        return resized;
    }
    return self;
}
-(UIImage *)imageWithShadow:(UIColor*)_shadowColor
                 shadowSize:(CGSize)_shadowSize
                       blur:(CGFloat)_blur {
    if (_blur == 0 && _shadowSize.width == 0 && _shadowSize.height == 0) {
        return self;
    }
    _shadowColor = _shadowColor ? _shadowColor : [UIColor blackColor];
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat w = _shadowSize.width > 0 ? _shadowSize.width : -_shadowSize.width;
    CGFloat h = _shadowSize.height > 0 ? _shadowSize.height : -_shadowSize.height;
    CGFloat x = _shadowSize.width > 0 ? 0 : -_shadowSize.width;
    CGFloat y = _shadowSize.height > 0 ? 0 : -_shadowSize.height;
    if (w < _blur * 2) {
        w = _blur * 2;
    }
    if (h < _blur * 2) {
        h = _blur * 2;
    }
    if (x < _blur) {
        x = _blur;
    }
    if (y < _blur) {
        y = _blur;
    }
    
    CGSize imageSize = self.size;
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, self.size.width + w, self.size.height + h, CGImageGetBitsPerComponent(self.CGImage), 0,
                                                       colourSpace, kCGBitmapAlphaInfoMask);
    CGColorSpaceRelease(colourSpace);
    
    CGContextSetShadowWithColor(shadowContext, _shadowSize, _blur, _shadowColor.CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(x, y, imageSize.width, imageSize.height), self.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    
    return shadowedImage;
}

- (UIImage *)imageWithWidth:(CGFloat)width height:(CGFloat)height startPoint:(CGPoint)point
{
    if (point.x + width > self.size.width || point
        .y + height > self.size.height)
    {
        return self;
    }
    else
    {
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(c, -point.x, -point.y);
        [self drawAtPoint:CGPointZero];
        UIImage *converted = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return converted;
    }
    return nil;
}
    
@end
