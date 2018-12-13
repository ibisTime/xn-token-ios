
//
//  StrategyVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/12/13.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "StrategyVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
#import "YSActionSheetView.h"
#import <WeiboSDK.h>
@interface StrategyVC ()<UIWebViewDelegate,UIWebViewDelegate,PlatformButtonClickDelegate>
{
    WYWebProgressLayer *_progressLayer; // 网页加载进度条
    NSString *url;
    UILabel *nameLable;
}

//@property (nonatomic,strong)ShareActionView *actionView;

@property (nonatomic,strong) JSContext *jsContext;
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation StrategyVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = kWhiteColor;
    [self.view addSubview:backView];
    
    
    nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, kStatusBarHeight, kScreenWidth - 108, 44)];
    nameLable.text = [LangSwitcher switchLang:@"攻略" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = kTextBlack;
    self.navigationItem.titleView = nameLable;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    self.webView.delegate = self;
//    self.title = [LangSwitcher switchLang:@"攻略" key:nil];
    
    [self.view addSubview:self.webView];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setImage:kImage(@"转发") forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:button]];
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"660917";
    
    http.parameters[@"ckey"] = @"redPacketShareUrl";
    
    [http postWithSuccess:^(id responseObject) {
//        self.h5String = responseObject[@"data"][@"cvalue"];
        NSString *lang;
        switch ([LangSwitcher currentLangType]) {
            case LangTypeKorean:
                lang = @"KO";
                
                break;
            case LangTypeEnglish:
                lang = @"EN";
                
                break;
            case LangTypeSimple:
                lang = @"ZH_CN";
                
                break;
                
            default:
                break;
        }
        url = [NSString stringWithFormat:@"%@/public/strategy.html?strategyID=%@&userId=%@&lang=%@",responseObject[@"data"][@"cvalue"],self.strategyID,[TLUser user].userId,lang];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]]];
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)buttonClick
{
    YSActionSheetView * ysSheet=[[YSActionSheetView alloc]initNYSView];
    ysSheet.delegate=self;
    
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    
    [window addSubview:ysSheet];
}

- (void) customActionSheetButtonClick:(YSActionSheetButton *) btn
{
    switch (btn.tag)
    {
        case 0:
        {

            [TLWXManager wxShareWebPageWithScene:0 title:[LangSwitcher switchLang:@"分享" key:NSInternalInconsistencyException] desc:nil url:url];

        }
            break;
        case 1:
        {

            [TLWXManager wxShareWebPageWithScene:1 title:[LangSwitcher switchLang:@"分享" key:NSInternalInconsistencyException] desc:nil url:url];

        }
            break;
        case 2:
        {

            [TLWBManger sinaShareWithUrl:url];
        }
            break;
            
    }
    
    
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
