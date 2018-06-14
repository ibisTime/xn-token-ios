//
//  BuildWalletMineVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/8.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "BuildWalletMineVC.h"
#import "RevisePassWordVC.h"
#import "WalletImportVC.h"
@interface BuildWalletMineVC ()

@property (nonatomic ,strong) UIImageView *iconImage;

@property (nonatomic ,strong) UILabel *nameLable;

@property (nonatomic ,strong) UIButton *buildButton;

@property (nonatomic ,strong) UIButton *importButton;

@property (nonatomic ,strong) UIButton *introduceButton;

@end

@implementation BuildWalletMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    self.view.backgroundColor = kHexColor(@"#ffffff");
    self.iconImage = [[UIImageView alloc] init];
    [self.view addSubview:self.iconImage];
    self.iconImage.image = kImage(@"logoTHA");
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@72.5);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.equalTo(@75);
        
    }];
    
    self.nameLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:24];
//    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [self.view addSubview:self.nameLable];
    self.nameLable.text = [LangSwitcher switchLang:@"THA WALLET" key:nil];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_bottom).offset(28);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    
    self.buildButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text = [LangSwitcher switchLang:@"创建钱包" key:nil];
    [self.buildButton setTitle:text forState:UIControlStateNormal];
    self.buildButton.titleLabel.font = [UIFont systemFontOfSize:16];

    [self.buildButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.buildButton addTarget:self action:@selector(buildWallet) forControlEvents:UIControlEventTouchUpInside];
    [self.buildButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.view addSubview:self.buildButton];
    [self.buildButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(69);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@50);
        
    }];
    
    
    self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text2 = [LangSwitcher switchLang:@"导入钱包" key:nil];
    [self.importButton setTitle:text2 forState:UIControlStateNormal];
    self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];

    [self.importButton setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.importButton addTarget:self action:@selector(importWallet) forControlEvents:UIControlEventTouchUpInside];
    [self.importButton setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
    self.importButton.layer.borderColor = (kAppCustomMainColor.CGColor);
    self.importButton.layer.borderWidth = 1;
    self.importButton.clipsToBounds = YES;
    [self.view addSubview:self.importButton];
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buildButton.mas_bottom).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@50);
        
    }];
    
    self.introduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.introduceButton];
    NSString *text3 = [LangSwitcher switchLang:@"我已阅读并同意服务及隐私条款" key:nil];
    [self.introduceButton setTitle:text3 forState:UIControlStateNormal];
    [self.introduceButton addTarget:self action:@selector(html5Wallet) forControlEvents:UIControlEventTouchUpInside];
    self.introduceButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.introduceButton setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.introduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@30);
        
    }];

    
}
//创建钱包
- (void)buildWallet
{
    
    RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
    vc.title =  [LangSwitcher switchLang:@"创建钱包" key:nil];
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
    
}

//导入钱包
- (void)importWallet
{
//    RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
//    vc.title =  [LangSwitcher switchLang:@"创建钱包" key:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    WalletImportVC *vc = [[WalletImportVC alloc] init];
    vc.title =  [LangSwitcher switchLang:@"导入钱包" key:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//加载隐私条款
- (void)html5Wallet
{
    
    
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
