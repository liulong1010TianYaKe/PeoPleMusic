//
//  UIImage+KIImage.h
//  Kitalker
//
//  Created by 杨 烽 on 12-8-3.
//
//

#import <UIKit/UIKit.h>

enum {
    enSvCropClip,               // clip模式下，旋转后的图片和原图一样大，部分图片区域会被裁剪掉
    enSvCropExpand,             // expand模式下，旋转后的图片可能会比原图大，所有的图片信息都会保留，剩下的区域会是全透明的
};
typedef NSInteger SvCropMode;

@interface UIImage (KIAdditions)

/*垂直翻转*/
- (UIImage *)flipVertical;

/*水平翻转*/
- (UIImage *)flipHorizontal;

/*改变size*/
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

/*裁切*/
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

/*图片旋转*/
- (UIImage*)rotateImageWithRadian:(CGFloat)radian cropMode:(SvCropMode)cropMode useScale:(BOOL)useScale;

/*等比例压缩*/
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**将UIColor变换为UIImage**/
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**将UIColor变换为UIImage,设置尺寸**/
+ (UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)size;

@end
