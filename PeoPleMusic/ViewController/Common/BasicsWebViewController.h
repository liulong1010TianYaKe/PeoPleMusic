//
//  JMWebViewController.h
//  JuMi
//
//  Created by hzins on 15/7/14.
//  Copyright (c) 2015年 hzins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicsViewController.h"
#import "KyoBasicsWebMutualHelp.h"

typedef  void (^OperationBlock)();

@interface BasicsWebViewController : BasicsViewController
@property (copy, nonatomic) NSString *urlString;
@property (assign, nonatomic) BOOL showShareItem;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) JSContext *context;

@property (nonatomic,strong) OperationBlock isPoppedBlock;  // 当 webViewController 被pop时,执行block

- (void)btnShareTouchIn:(UIButton *)btn;
- (void)btnBackTouchIn:(UIButton *)button;
- (void)btnCloseTouchIn:(UIButton *)button;

- (void)bingJSContextExceptionHandler;   //关联js异常
- (void)clearCache;


- (void)transferAppIdToH5;  //通知h5是ios客户端
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

//提供js调用的几个方法 老版的，已弃用
-(void)JSClose; //关闭当前webView界面,注意调用这个方法后，将不再执行任何代码
-(void)JSToHome; //回到app首页 (这个少用，会重置所有界面)
-(void)JSRefresh; //调用刷新数据，对应于不同的界面

@end
