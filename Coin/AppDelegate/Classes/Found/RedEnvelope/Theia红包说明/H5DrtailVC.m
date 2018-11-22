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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;


}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
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
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(kScreenWidth/2-60, 0, 120, 50)];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=kTextColor;
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:[LangSwitcher switchLang:@"Theia红包说明" key:nil]];
    self.navigationItem.titleView=titleText;
    self.view.backgroundColor = kWhiteColor;

    UILabel *askDetail = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:16];
    askDetail.text = askDetail.text = [NSString stringWithFormat:@"%@  %@",[LangSwitcher switchLang:@"问" key:nil],self.model.question];
    askDetail.frame = CGRectMake(15, 20, kScreenWidth-30, 22);
    [self.view addSubview:askDetail];
    
    UILabel *asnwer = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:16];
    asnwer.text = [NSString stringWithFormat:@"%@",[LangSwitcher switchLang:@"答" key:nil]];
    asnwer.frame = CGRectMake(15, 70, 0, 22);
    [asnwer sizeToFit];
    [self.view addSubview:asnwer];

    self.contentWeb = [[UIWebView alloc] init];
    self.contentWeb.backgroundColor = [UIColor whiteColor];
    [self.contentWeb loadHTMLString:self.model.answer baseURL:nil];
    [self.view addSubview:self.contentWeb];
//    [self.contentWeb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(63, asnwer.xx + 10, 15, 15));
//    }];
    self.contentWeb.frame = CGRectMake(asnwer.xx + 5, 61, SCREEN_WIDTH - asnwer.xx - 20, SCREEN_HEIGHT - 61 - 15 - kNavigationBarHeight);
    self.contentWeb.delegate = self;

}

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
