//
//  PrivacyPolicyView.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/30.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "PrivacyPolicyView.h"
#import "APPLanguage.h"

@implementation PrivacyPolicyView
{
    NSString *ckey;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(10, 24, SCREEN_WIDTH - 120, 16) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(16) textColor:kHexColor(@"#0064ff")];
        nameLabel.text = [LangSwitcher switchLang:@"隐私服务协议及条款" key:nil];
        [self addSubview:nameLabel];
        
        UIButton *button = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确认" key:nil] titleColor:kWhiteColor backgroundColor:kHexColor(@"0064ff") titleFont:16 cornerRadius:6.5];
        button.frame = CGRectMake(SCREEN_WIDTH/2 - 100, 60 + SCREEN_WIDTH - 160, 100, 40);
        self.confirmBtn = button;
        [self addSubview:button];
        
        
        ckey = [NSString stringWithFormat:@"privacy_%@",[APPLanguage currentLanguage].currentLange];
        
//        name = [LangSwitcher switchLang:@"隐私政策" key:nil];
        TLNetworking *http = [TLNetworking new];
        http.showView = self;
        http.code = USER_CKEY_CVALUE;
        
        http.parameters[SYS_KEY] = ckey;
        
        [http postWithSuccess:^(id responseObject) {
            
            self.htmlStr = responseObject[@"data"][@"cvalue"];
            
            [self initWebView];
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    return self;
}

- (void)initWebView {
    
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH - 140, SCREEN_WIDTH - 160) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
//    [_webView.scrollView adjustsContentInsets];
    [self addSubview:_webView];
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

@end
