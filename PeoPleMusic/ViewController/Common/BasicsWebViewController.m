//
//  JMWebViewController.m
//  JuMi
//
//  Created by hzins on 15/7/14.
//  Copyright (c) 2015年 hzins. All rights reserved.
//

#import "BasicsWebViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "AppDelegate.h"
//#import "LoginViewController.h"

@interface BasicsWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *btnShare;

//js老的交互方法
-(void)JSClose;
-(void)JSToHome;
-(void)JSRefresh;

@end

@implementation BasicsWebViewController

#pragma mark - circleLife

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = NO;
    [self reSetBackButtonMethod:@selector(btnBackTouchIn:)];
    [self setupBarButtonItems];
    [self setupWebView];
    [KyoUtil setWebViewUserAgent:nil];   //设置webview的useragent
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [self clearCache];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Method

-(void)setupBarButtonItems
{
    UIImage *image = [UIImage imageNamed:@"webView_back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [itemButton setImage:image forState:UIControlStateNormal];
    //矫正返回按钮的坐标
    itemButton.imageEdgeInsets = UIEdgeInsetsMake(0, -12,0, 0);
    [itemButton addTarget:self action:@selector(btnBackTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:itemButton];
    
    
    UIButton *clsoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clsoseBtn setFrame:CGRectMake(0, 0, 40 , 22)];
    UIImage *closeImage = [UIImage imageNamed:@"webView_close"];
    [clsoseBtn setImage:closeImage forState:UIControlStateNormal];
    //矫正关闭按钮的坐标
    clsoseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [clsoseBtn addTarget:self action:@selector(btnCloseTouchIn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithCustomView:clsoseBtn];
    [self.navigationItem setLeftBarButtonItems:@[backButton, closeButton]];
    
    if (self.showShareItem) {
        UIBarButtonItem *btnBarShare = [UIBarButtonItem itemWithImageName:@"content_icon_share_normal" highImageName:nil target:self action:@selector(btnShareTouchIn:)];
        self.navigationItem.rightBarButtonItem = btnBarShare;
        self.btnShare = (UIButton *)btnBarShare.customView;
        self.btnShare.enabled = NO;
    }
    
}

-(void)setupWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    NSURL *url =[NSURL URLWithString:self.urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    //延时加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView loadRequest:request];
    });
}

#pragma mark - Events

-(void)btnShareTouchIn:(UIButton *)btn {}

- (void)btnBackTouchIn:(UIButton *)button
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.isPoppedBlock) {
            self.isPoppedBlock();
        }
    }
}

- (void)clearCache{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)btnCloseTouchIn:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.isPoppedBlock) {
        self.isPoppedBlock();
    }
}

#pragma mark --------------------
#pragma mark - Methods

//关联js异常
- (void)bingJSContextExceptionHandler {
    if (!self.context.exceptionHandler) {
        self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            NSLog(@"异常信息：%@", exceptionValue);
        };
    }
}

//通知h5是ios客户端
- (void)transferAppIdToH5 {
    @try {
        [self.webView stringByEvaluatingJavaScriptFromString:@"isAppIos()"];    //调用test方法，传入abc这个参数
    }
    @catch (NSException *exception) {}
}

#pragma mark --------------------
#pragma mark - JSOBJC

-(void)JSClose
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.isPoppedBlock) {
        self.isPoppedBlock();
    }
}

-(void)JSToHome
{
    [[KyoUtil getCurrentNavigationViewController] popToRootViewControllerAnimated:YES];
//    [KyoUtil getRootViewController].selectedIndex = 1;
}

-(void)JSRefresh
{

}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    //如果下标0是objc，说明是调用方法
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"]) {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@"//"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        if (1 == [arrFucnameAndParameter count]) {  // 没有参数的
            if ([self respondsToSelector:NSSelectorFromString(funcStr)]) {
                [self performSelector:NSSelectorFromString(funcStr) withObject:nil afterDelay:0];
            }
        } else if([arrFucnameAndParameter count] >= 2) {    //有参数的
            if ([self respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",funcStr])]) {
                NSString *param = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"objc://%@//", funcStr] withString:@""];
                [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",funcStr]) withObject:param afterDelay:0];
            }
        }
        return NO;
    };
    return YES;
}
  
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView { 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.showShareItem) {
        self.btnShare.enabled = YES;
    }
    
    //JavaScriptCode绑定交互
    [[KyoBasicsWebMutualHelp share] bingMutualHelpWithWebView:webView withJSContext:self.context];
    [self bingJSContextExceptionHandler];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
