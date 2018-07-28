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
#import "APPLanguage.h"
@interface HTMLStrVC ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *nameLbl;
@property (nonatomic, strong) UILabel *versionLbl;
@property (nonatomic, strong) UILabel *versionLbl2;
@property (nonatomic, strong) UILabel *versionLbl3;

@property (nonatomic, strong) UILabel *lastVersionLbl;
@property (nonatomic, strong) UILabel *banQuanLbl;
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UILabel *phoneNumber;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong)  UIView *line;

@property (nonatomic, strong)  UIView *line2;
@end

@implementation HTMLStrVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //

    [self requestContent];
}

#pragma mark - Data

- (void)requestContent {
    
    self.bgImage = [[UIImageView alloc] init];
    self.bgImage.contentMode = UIViewContentModeScaleToFill;
    self.bgImage.userInteractionEnabled = YES;
    self.bgImage.image = kImage(@"我的 背景");
    [self.view  addSubview:self.bgImage];
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    //
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.backButton.frame = CGRectMake(15, kStatusBarHeight+5, 40, 40);
    [self.backButton setImage:kImage(@"返回1-1") forState:(UIControlStateNormal)];
    [self.backButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgImage addSubview:self.backButton];
    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, kStatusBarHeight+5, kScreenWidth - 108, 44)];
    self.nameLable.text = [LangSwitcher switchLang:@"帮助中心" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(16);
    self.nameLable.textColor = kTextBlack;
    [self.bgImage addSubview:self.nameLable];
    
    NSString *name = @"";
    
    NSString *ckey = @"";
    
    switch (self.type) {
            
        case HTMLTypeAboutUs: {
            ckey = [NSString stringWithFormat:@"questions_%@",[APPLanguage currentLanguage].currentLange];
            name = [LangSwitcher switchLang:@"关于我们" key:nil];
            
        } break;
            
        case HTMLTypeRegProtocol: {
            ckey = [NSString stringWithFormat:@"reg_protocol_%@",[APPLanguage currentLanguage].currentLange];
            name = [LangSwitcher switchLang:@"注册协议" key:nil];
            
        } break;
            
        case HTMLTypeCommonProblem: {
            
            ckey = @"questions";
            
            name = [LangSwitcher switchLang: @"帮助中心" key:nil];
            
        } break;
            
        case HTMLTypeLinkService: {
            
            ckey = @"service";
            
            name =  [LangSwitcher switchLang:@"联系客服" key:nil];
            
        } break;
            
        case HTMLTypeTradeRemind: {
            
            ckey = @"trade_remind";
            
            name = [LangSwitcher switchLang:@"交易提醒" key:nil];
            
        } break;
        case HTMLTypeMnemonic: {
            ckey = [NSString stringWithFormat:@"mnemonic_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"什么是助记词" key:nil];
            break;
        }
        case HTMLTypeCreate_wallet: {
            ckey = [NSString stringWithFormat:@"create_wallet_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"创建钱包流程" key:nil];
            break;
        }
        case HTMLTypeMnemonic_backup: {
            ckey = [NSString stringWithFormat:@"mnemonic_backup_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"如何备份助记词" key:nil];
            break;
        }
        case HTMLTypeRed_packet_rule: {
            ckey = [NSString stringWithFormat:@"red_packet_rule_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"红包规则" key:nil];
            break;
        }
        case HTMLTypePrivacy: {
            ckey = [NSString stringWithFormat:@"privacy_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"隐私政策" key:nil];
            break;
        }
        case HTMLTypeGlobal_master: {
            ckey = [NSString stringWithFormat:@"global_master_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"首创玩法" key:nil];
            break;
        }
        case HTMLTypeQuantitative_finance: {
            ckey = [NSString stringWithFormat:@"quantitative_finance_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"量化理财" key:nil];
            break;
        }
        case HTMLTypeYubibao: {
            ckey = [NSString stringWithFormat:@"yubibao_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"余币宝" key:nil];
            break;
        }
    }

    self.nameLable.text = name;
    
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
- (void)buttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)initWebView {
   

    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(15, kHeight(90), kScreenWidth-30, kSuperViewHeight) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    [_webView.scrollView adjustsContentInsets];
    [self.bgImage addSubview:_webView];
    
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
