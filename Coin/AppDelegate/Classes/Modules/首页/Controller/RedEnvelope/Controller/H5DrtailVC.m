//
//  H5DrtailVC.m
//  Coin
//
//  Created by shaojianfei on 2018/9/17.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "H5DrtailVC.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
@interface H5DrtailVC ()<UIWebViewDelegate>

@end

@implementation H5DrtailVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.contentWeb loadHTMLString:self.model.answer baseURL:nil];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"Theia红包说明" key:nil];
    UIButton *_backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _backButton.frame = CGRectMake(10, 20, 0, 44);
    [_backButton setTitle:[LangSwitcher switchLang:@"" key:nil] forState:(UIControlStateNormal)];
    _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _backButton.titleLabel.font = Font(14);
    [_backButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_backButton setImage:kImage(@"返回1-1") forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIButton *titleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    titleButton.frame = CGRectMake(20,20, 120, 44);
    [titleButton setTitle:[LangSwitcher switchLang:@"Theia红包说明" key:nil] forState:(UIControlStateNormal)];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    titleButton.titleLabel.font = Font(16);
    [titleButton setTitleColor:kTextBlack forState:(UIControlStateNormal)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(kScreenWidth/2-60, 0, 120, 50)];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    
    titleText.textColor=kTextColor;
    
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    
    [titleText setText:[LangSwitcher switchLang:@"Theia红包说明" key:nil]];
    
    self.navigationItem.titleView=titleText;
    self.view.backgroundColor = kWhiteColor;
    UILabel *ask = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    ask.text = [LangSwitcher switchLang:@"问" key:nil];
    ask.frame = CGRectMake(15, 20, 40, 22);
    [self.view addSubview:ask];
    
    UILabel *askDetail = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:16];
    askDetail.text = self.model.question;
    askDetail.frame = CGRectMake(15+40+10, 20, kScreenWidth-15+40+10, 22);
    [self.view addSubview:askDetail];
    
    UILabel *asnwer = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    asnwer.text = [LangSwitcher switchLang:@"答" key:nil];
    asnwer.frame = CGRectMake(15, 70, 40, 22);
    [self.view addSubview:asnwer];

    self.contentWeb = [[UIWebView alloc] init];
    self.contentWeb.backgroundColor = kWhiteColor;

    [self.view addSubview:self.contentWeb];
    [self.contentWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(60, 60, 0, 15));
    }];
    self.contentWeb.delegate = self;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backbuttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    }

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self.contentWeb stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    
    //字体颜色
    
    [self.contentWeb stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#666666'"];
    
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
