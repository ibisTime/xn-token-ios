//
//  PosMiningVC.m
//  Coin
//
//  Created by 蔡卓越 on 2018/3/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "PosMiningVC.h"
//V
#import "TLPlaceholderView.h"

@interface PosMiningVC ()
//
@property (nonatomic, strong) TLPlaceholderView *placeholderView;
@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UILabel *contentLab;
@end

@implementation PosMiningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"量化理财" key:nil];
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
        make.right.equalTo(@-10);
        make.left.equalTo(@10);
        
    }];
    self.titleLable.text = @"THA Wallet为用户提供多种类型的优质理财产品，用户可以使用比特币、以太坊等数字货币购买理财产品而获得收益";
    self.contentLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self.view addSubview:self.contentLab];
    self.contentLab.numberOfLines = 0;
    self.contentLab.text = @"THA Wallet provides users with a variety of quality management products, users can use Bitcoin, Ethernet and other digital currencies to buy money products and gain income.";
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(20);
        make.right.equalTo(@-10);
        make.left.equalTo(@10);
    }];
    
//    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:nil text:[LangSwitcher switchLang:@"暂未开放, 敬请期待!" key:nil] textColor:kHexColor(@"#fe8472")];
    
//    [self.view addSubview:self.placeholderView];
//    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:nil text:[LangSwitcher switchLang:@"敬请期待!" key:nil] textColor:kTextColor];
//    
//    [self.view addSubview:self.placeholderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
