//
//  HTMLStrVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "HTMLStrVC.h"
#import <WebKit/WebKit.h>
#import "APICodeMacro.h"
#import "UIScrollView+TLAdd.h"

@interface HTMLStrVC ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HTMLStrVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //

    [self requestContent];
}

#pragma mark - Data

- (void)requestContent {
    
    NSString *name = @"";
    
    NSString *ckey = @"";
    
    switch (self.type) {
            
        case HTMLTypeAboutUs: {
            
            ckey = @"about_us";
            
            name = [LangSwitcher switchLang:@"关于我们" key:nil];
            
        } break;
            
        case HTMLTypeRegProtocol: {
            
            ckey = @"reg_protocol";
            
            name = [LangSwitcher switchLang:@"注册协议" key:nil];
            
        } break;
            
        case HTMLTypeCommonProblem: {
            
            ckey = @"questions";
            
            name = [LangSwitcher switchLang: @"常见问题" key:nil];
            
        } break;
            
        case HTMLTypeLinkService: {
            
            ckey = @"service";
            
            name =  [LangSwitcher switchLang:@"联系客服" key:nil];
            
        } break;
            
        case HTMLTypeTradeRemind: {
            
            ckey = @"trade_remind";
            
            name = [LangSwitcher switchLang:@"交易提醒" key:nil];
            
        } break;
    }

    self.title = name;
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[SYS_KEY] = ckey;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.htmlStr = responseObject[@"data"][@"cvalue"];
        
        [self initWebView];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Init

- (void)initWebView {

    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    [_webView.scrollView adjustsContentInsets];
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
