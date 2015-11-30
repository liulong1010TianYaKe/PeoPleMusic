//
//  UIImage+Antialiase.m
//  ImageAntialiase
//
//  Created by 谌启亮 on 12-10-25.
//  Copyright (c) 2012年 谌启亮. All rights reserved.
//

#import "UIImage+Antialiase.h"
#import "UIImage-RoundCorner.h"

@implementation UIImage (Antialiase)

//创建抗锯齿头像
- (UIImage*)antialiasedImage{
    return [self antialiasedImageOfSize:self.size scale:self.scale];
}

//创建抗锯齿头像,并调整大小和缩放比。
- (UIImage*)antialiasedImageOfSize:(CGSize)size scale:(CGFloat)scale{
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(1, 1, size.width-2, size.height-2)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//根据尺寸缩放拉伸图片
- (UIImage *)shrinkImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageWithRedius:(float)radius withURLString:(NSString *)url placeholderUrl:(NSString *)placeUrl{
    UIImageView *imgView = [[UIImageView alloc] init];

    UIImage *img = [UIImage imageNamed:placeUrl];
    UIImage * placeholderImg  =  [img imageWithRadius:radius width:radius*2 height:radius*2];
    [imgView setImageWithURL:[NSURL URLWithString: url] placeholderImage:placeholderImg];
    
    return imgView.image;
}
@end
