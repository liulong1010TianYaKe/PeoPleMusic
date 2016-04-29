//
//  NSString+Size.m
//  JuMi
//
//  Created by zhunit on 15/8/27.
//  Copyright (c) 2015年 zhunit. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)boundingRectWithSize:(CGSize)size withFont:(UIFont *)font
{
    
    CGSize retSize = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
     retSize = [self boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
#else
    retSize = [self sizeWithFont:font constrainedToSize:size)];
#endif
    
    return retSize;
}


- (CGFloat)contentCellHeightWithText:(NSString *)text withSize:(CGSize)size withFont:(UIFont *)font{
    
    return [self boundingRectWithSize:size withFont:font].height;

}


- (CGFloat)heightForStringWithfontSize:(float)fontSize andWidth:(float)width {
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:fontSize]].height;
}
- (long long)fileSize
{
    // 1.文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL fileExists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (fileExists == NO) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:self error:nil];
        long long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            totalSize += [fullSubpath fileSize];
        }
        return totalSize;
    } else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *attr = [mgr attributesOfItemAtPath:self error:nil];
        return [attr[NSFileSize] longLongValue];
    }
}

@end
