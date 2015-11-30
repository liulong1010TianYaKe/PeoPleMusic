//
//  MAWebViewController.m
//  MainApp
//
//  Created by Kyo on 20/8/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "MAWebViewController.h"
#import "MAWebMutualHelp.h"

@interface MAWebViewController ()

@end

@implementation MAWebViewController

#pragma mark --------------------
#pragma mark - CycLife

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

#pragma mark --------------------
#pragma mark - Events

#pragma mark --------------------
#pragma mark - Methods

#pragma mark --------------------
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [super webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(transferAppIdToH5) object:nil];
//    if ([self respondsToSelector:@selector(transferAppIdToH5)]) {
//        [self performSelector:@selector(transferAppIdToH5) withObject:nil afterDelay:0.5];
//    }
    
    //JavaScriptCode绑定交互
    [[MAWebMutualHelp share] bingMutualHelpWithWebView:webView withJSContext:self.context];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [super webView:webView didFailLoadWithError:error];
}

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC



@end
