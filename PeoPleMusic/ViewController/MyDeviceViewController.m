//
//  MyDeviceViewController.m
//  PeoPleMusic
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 zhuniT All rights reserved.
//

#import "MyDeviceViewController.h"

@interface MyDeviceViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgScan;

@property (weak, nonatomic) IBOutlet UILabel *lblAssist;
@end

@implementation MyDeviceViewController

+ (MyDeviceViewController *)createMyDeviceViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"UserCenter" bundle:nil];
    MyDeviceViewController *controller = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MyDeviceViewController class])];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setupView{
    self.title = @"我的音响";
    self.lblTitle.font = [UIFont boldSystemFontOfSize:15];
    self.lblTitle.text = @"人人点歌－2号音响";
    self.imgScan.image = [UIImage imageNamed:@"logo_76"];
    [self erweima];
    
}



-(void)erweima

{
    
    //二维码滤镜
    
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    
//    NSData *data=[@"http://user.qzone.qq.com/576272411/infocenter?ptsig=Dm6Nl39A*rcF*REn7b7Q59p-YZaEUDw0tYjYAEy13v8_" dataUsingEncoding:NSUTF8StringEncoding];
    
    DeviceInfor *deviceInfo = [[KyoDataCache sharedWithType:KyoDataCacheTypeTempPath] readDataWithFolderName:YM_HEAD_CMDTYPE_REGISTERED_FEEDBACK];
    
//    NSData *data=[@"123asdkhf我回家阿维塞哦啊我还是当初哇额武器jsadjljo428342" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data=[deviceInfo.name dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    
    _imgScan.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0];
    
    
    
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    
    _imgScan.layer.shadowOffset=CGSizeMake(0, 0.5);//设置阴影的偏移量
    
    _imgScan.layer.shadowRadius=1;//设置阴影的半径
    
    _imgScan.layer.shadowColor=[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    
    _imgScan.layer.shadowOpacity=0.3;
    
    
    
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}
@end
