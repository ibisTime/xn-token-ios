//
//  GoodMallVC.m
//  Coin
//
//  Created by 蔡卓越 on 2018/3/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "GoodMallVC.h"
//V
#import "TLPlaceholderView.h"

@interface GoodMallVC ()
//
@property (nonatomic, strong) TLPlaceholderView *placeholderView;
@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UILabel *contentLab;
@end

@implementation GoodMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"余币宝" key:nil];
    //敬请期待
    [self initPlaceHolderView];
}

#pragma mark - Init
- (void)initPlaceHolderView {
    self.titleLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self.view addSubview:self.titleLable];
    self.titleLable.numberOfLines = 0;
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kHeight(20)));
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(@10);
        
    }];
    self.titleLable.text = @"余币宝是THA Wallet旗下的数字货币增值服务和活期数字货币管理服务产品。特点是操作简便、低门槛、零手续费、可随取随用，让您更灵活的管理数字资产";
    self.contentLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self.view addSubview:self.contentLab];
    self.contentLab.numberOfLines = 0;
    self.contentLab.text = @"Yubibao is the digital currency value-added service and demand digital money managemen service product of THA wallet. It is easy to operate, has low threshold, without handling fees,  and are available with access, so that you can manage your digital assets with more flexibility.";
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(20);
        make.right.equalTo(@-10);
        make.left.equalTo(@10);
    }];
//    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:nil text:[LangSwitcher switchLang:@" 敬请期待!" key:nil] textColor:kTextColor];
//
//    [self.view addSubview:self.placeholderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
