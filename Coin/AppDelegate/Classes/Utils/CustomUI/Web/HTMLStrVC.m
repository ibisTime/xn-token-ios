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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;

    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}





- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    //

    [self requestContent];
}

#pragma mark - Data

- (void)requestContent {
    
    self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgImage.contentMode = UIViewContentModeScaleToFill;
    self.bgImage.userInteractionEnabled = YES;
    self.bgImage.image = kImage(@"我的 背景");
    [self.view  addSubview:self.bgImage];

    
    self.nameLable = [[UILabel alloc]init];
//    self.nameLable.text = [LangSwitcher switchLang:@"帮助中心" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(16);
    self.nameLable.textColor = kTextBlack;
    self.navigationItem.titleView = self.nameLable;
//    [self.bgImage addSubview:self.nameLable];

    NSString *name = @"";
    NSString *ckey = @"";


    if (self.type == HTMLTypeAboutUs) {

    }

    switch (self.type) {
            
        case HTMLTypeAboutUs: {
            ckey = [NSString stringWithFormat:@"questions_%@",[APPLanguage currentLanguage].currentLange];
            name = [LangSwitcher switchLang:@"关于我们" key:nil];
            self.nameLable.text = name;
            break;
        }
            
        case HTMLTypeRegProtocol: {
            ckey = [NSString stringWithFormat:@"reg_protocol_%@",[APPLanguage currentLanguage].currentLange];
            name = [LangSwitcher switchLang:@"注册协议" key:nil];
            self.nameLable.text = name;
            break;
            
        }
            
        case HTMLTypeCommonProblem: {
            
             ckey = [NSString stringWithFormat:@"questions_%@",[APPLanguage currentLanguage].currentLange];
            name = [LangSwitcher switchLang: @"帮助中心" key:nil];
            self.nameLable.text = name;

            break;
        }
            
        case HTMLTypeLinkService: {
            
            ckey = @"service";
            
            name =  [LangSwitcher switchLang:@"联系客服" key:nil];
            self.nameLable.text = name;
            break;
        }
            
        case HTMLTypeTradeRemind: {
            
            ckey = @"trade_remind";
            
            name = [LangSwitcher switchLang:@"交易提醒" key:nil];
            self.nameLable.text = name;
            break;
            
        }
        case HTMLTypeMnemonic: {
            ckey = [NSString stringWithFormat:@"mnemonic_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"什么是助记词" key:nil];
            self.nameLable.text = name;
            break;
        }
        case HTMLTypeCreate_wallet: {
            ckey = [NSString stringWithFormat:@"create_wallet_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"创建钱包流程" key:nil];
            self.nameLable.text = name;
            break;
        }
        case HTMLTypeMnemonic_backup: {
            ckey = [NSString stringWithFormat:@"mnemonic_backup_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"如何备份钱包" key:nil];
            self.nameLable.text = name;
            break;
        }
        case HTMLTypeRed_packet_rule: {
            ckey = [NSString stringWithFormat:@"red_packet_rule_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"红包规则" key:nil];
            self.nameLable.text = name;
            break;
        }
        case HTMLTypePrivacy: {
            ckey = [NSString stringWithFormat:@"privacy_%@",[APPLanguage currentLanguage].currentLange];
            
            name = [LangSwitcher switchLang:@"隐私政策" key:nil];
            break;
        }
//        case HTMLTypeGlobal_master: {
//            ckey = [NSString stringWithFormat:@"global_master_%@",[APPLanguage currentLanguage].currentLange];
//            name = [LangSwitcher switchLang:@"首创玩法" key:nil];
//            self.htmlStr = self.des;
//
//            [self initWebView];
//            self.nameLable.text = name;
//
//            return;
//            break;
//        }
//        case HTMLTypeYubibao: {
//            ckey = [NSString stringWithFormat:@"yubibao_%@",[APPLanguage currentLanguage].currentLange];
//
//            name = [LangSwitcher switchLang:@"余币宝" key:nil];
//            self.htmlStr = self.des;
//
//            [self initWebView];
//            self.nameLable.text = name;
//
//            return;
//            break;
//        }
        case HTMLTypeQuantitativeFinance: {
            ckey = [NSString stringWithFormat:@"pop_protocol_%@",[APPLanguage currentLanguage].currentLange];

            name = [LangSwitcher switchLang:@"量化理财" key:nil];
            self.nameLable.text = name;

            break;
        }

        case HTMLTypeOther: {
            self.nameLable.text = self.name;
            [self initWebView];
            return;
            break;
        }


        default:
            break;

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
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)initWebView {


    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(15, kNavigationBarHeight + 15, kScreenWidth-30, kSuperViewHeight - 40) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    [_webView.scrollView adjustsContentInsets];
    [self.bgImage addSubview:_webView];
    if (self.des) {
        self.nameLable.text = self.name;
        [_webView loadHTMLString:self.des baseURL:nil];
    }else{
        [self loadWebWithString:self.htmlStr];

        
    }
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
