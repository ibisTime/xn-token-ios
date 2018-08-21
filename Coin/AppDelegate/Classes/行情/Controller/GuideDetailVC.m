//
//  GuideDetailVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/30.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "GuideDetailVC.h"

#import <WebKit/WebKit.h>
#import "APICodeMacro.h"

@interface GuideDetailVC ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation GuideDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWebView];

}

#pragma mark - Setting
- (void)setGuide:(GuideModel *)guide {
    
    _guide = guide;
    
    self.title = guide.title;
    
    self.htmlStr = guide.content;
    
}

#pragma mark - Init

- (void)initWebView {
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUCC = [WKUserContentController new];
    [wkUCC addUserScript:wkUserScript];
    
    //
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    wkConfig.userContentController = wkUCC;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) configuration:wkConfig];
    _webView.backgroundColor = kWhiteColor;
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;

    [self.view addSubview:_webView];
    
    
    [self loadWebWithString:self.htmlStr];
}

- (void)loadWebWithString:(NSString *)string {
    
    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, string];
    
    [_webView loadHTMLString:html baseURL:nil];
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        [self changeWebViewHeight:string];
    }];
    
}

- (void)changeWebViewHeight:(NSString *)heightStr {
    
    CGFloat height = [heightStr integerValue];
    
    // 改变webView和scrollView的高度
    
    _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
