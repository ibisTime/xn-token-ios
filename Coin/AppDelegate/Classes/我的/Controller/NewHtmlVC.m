//
//  NewHtmlVC.m
//  Coin
//
//  Created by shaojianfei on 2018/9/14.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "NewHtmlVC.h"
#import <WebKit/WebKit.h>
#import "UIScrollView+TLAdd.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface NewHtmlVC ()<WKNavigationDelegate>


@property (nonatomic, strong) WKWebView *webView;

@end

@implementation NewHtmlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kClearColor;
    self.title = [LangSwitcher switchLang:@"抽奖" key:nil];

    [self initWebView];
    // Do any additional setup after loading the view.
}

- (void)initWebView {
    
    
//    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
//
//    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//
//    WKUserContentController *wkUCC = [WKUserContentController new];
//
//    [wkUCC addUserScript:wkUserScript];
//
//    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
//
//    wkConfig.userContentController = self;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    [_webView.scrollView adjustsContentInsets];
    [self.view addSubview:_webView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [_webView loadHTMLString:self.h5string baseURL:nil];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5string]]];
    [self loadWebWithString:self.h5string];
    
     
}

- (void)loadWebWithString:(NSString *)string {
    
    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, string];
    
    [_webView loadHTMLString:html baseURL:nil];
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
