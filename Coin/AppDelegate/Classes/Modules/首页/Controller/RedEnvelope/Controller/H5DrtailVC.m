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


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.contentWeb loadHTMLString:self.h5 baseURL:nil];
}

- (void)viewDidLoad {
    self.title = [LangSwitcher switchLang:@"红包规则" key:nil];
    [super viewDidLoad];
    self.contentWeb = [[UIWebView alloc] init];
    [self.view addSubview:self.contentWeb];
    [self.contentWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 0, 15));
    }];
    self.contentWeb.delegate = self;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
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
