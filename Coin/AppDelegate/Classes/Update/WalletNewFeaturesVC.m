//
//  WalletNewFeaturesVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/14.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletNewFeaturesVC.h"
#import "Masonry.h"
#import "UILabel+Extension.h"
#import "UILable+convience.h"
#import "TLTextView.h"
#import "TLAlert.h"
#import "TLUpdateVC.h"
#import "TLNavigationController.h"
#import "TLTabBarController.h"

@interface WalletNewFeaturesVC ()
@property (nonatomic ,strong) UIButton *importButton;
@property (nonatomic ,strong) UIImageView *iconImage;
@property (nonatomic ,strong) UILabel *nameLable;

@end

@implementation WalletNewFeaturesVC

- (void)viewDidLoad {
    self.title = [LangSwitcher switchLang:@"导入成功" key:nil];

    [super viewDidLoad];
    [self initSubViews];
    // Do any additional setup after loading the view.
}


- (void)initSubViews
{
    self.iconImage = [[UIImageView alloc] init];
    [self.view addSubview:self.iconImage];
    self.iconImage.image = kImage(@"icon圆角");
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.equalTo(@75);
        
    }];
    
    self.nameLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18];
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [self.view addSubview:self.nameLable];
    self.nameLable.text = [LangSwitcher switchLang:@"导入成功" key:nil];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_bottom).offset(28);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text2 = [LangSwitcher switchLang:@"立即体验" key:nil];
    [self.importButton setTitle:text2 forState:UIControlStateNormal];
    self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.importButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.importButton addTarget:self action:@selector(importNow) forControlEvents:UIControlEventTouchUpInside];
    [self.importButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    self.importButton.layer.borderColor = (kAppCustomMainColor.CGColor);
    self.importButton.layer.borderWidth = 1;
    self.importButton.clipsToBounds = YES;
    [self.view addSubview:self.importButton];
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(50);
        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@(self.view.width - 30));
        make.height.equalTo(@50);
        
    }];
    
}

- (void)importNow
{
    //导入钱包 设置的交易密码
    TLUpdateVC *up = [[TLUpdateVC alloc] init];
    TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KISBuild];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIApplication sharedApplication].keyWindow.rootViewController = up;
    
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
