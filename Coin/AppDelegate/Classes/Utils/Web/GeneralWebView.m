//
//  GeneralWebView.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/6.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "GeneralWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
@interface GeneralWebView ()<UIWebViewDelegate,UIWebViewDelegate>
{
    WYWebProgressLayer *_progressLayer; // 网页加载进度条
}

@property (nonatomic,strong) JSContext *jsContext;
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation GeneralWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    self.webView.delegate = self;
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_URL]]]];
    [self.view addSubview:self.webView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:self action:@selector(rightBtnClick)];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//
//    return YES;
//}

//对JS传来的值进行调用
//- (void)doSomeThingWithParamA:(id)paramA andParamB:(id)paramB{
//
//    NSLog(@"%@    %@", paramA, paramB);
//}

-(void)rightBtnClick
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_URL]]]];
}

@end
