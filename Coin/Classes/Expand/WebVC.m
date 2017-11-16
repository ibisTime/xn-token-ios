//
//  WebVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>
#import "TLProgressHUD.h"

@interface WebVC ()<WKNavigationDelegate>

@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) configuration:webConfig];
    [self.view addSubview:webV];
    webV.navigationDelegate = self;
    
    NSURL *url = [[NSURL alloc] initWithString:self.url];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    
    [webV loadRequest:req];
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
    
    [TLAlert alertWithError:@"加载失败"];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        self.title = string;
    }];
}

@end
