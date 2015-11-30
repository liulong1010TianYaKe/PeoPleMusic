//
//  MAWebViewController.h
//  MainApp
//
//  Created by Kyo on 20/8/15.
//  Copyright (c) 2015 hzins. All rights reserved.
//

#import "BasicsWebViewController.h"


@interface MAWebViewController : BasicsWebViewController

- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end
