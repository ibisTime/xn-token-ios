//
//  RechargeCoinVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "RechargeCoinVC.h"
#import "CoinHeader.h"
#import "UIButton+EnLargeEdge.h"
#import "SGQRCodeTool.h"

@interface RechargeCoinVC ()

@property (nonatomic, strong) UIView *topView;

@end

@implementation RechargeCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"充币";
    
    [self initTopView];

    [self initSubviews];
}

#pragma mark - Init

- (void)initTopView {
    
    CGFloat topH = kScreenWidth > 375 ? kHeight(50): 50;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topH)];
    
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#fdfbed"];
    
    [self.view addSubview:self.topView];
    
    UIButton *cancelBtn = [UIButton buttonWithImageName:@"删除"];
    
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn setEnlargeEdge:15];
    
    [self.topView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.equalTo(@15);
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-15));
        
    }];
    
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:12.0];
    
    promptLbl.text = @"ETH钱包地址禁止充值除ETH之外的其他资产, 任何ETH资产充值将不可找回";
    
    promptLbl.frame = CGRectMake(0, 0, kScreenWidth, 50);
    
    promptLbl.numberOfLines = 0;
    
    [self.topView addSubview:promptLbl];
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(cancelBtn.mas_left).offset(-10);
        make.height.equalTo(@50);
        make.top.equalTo(@0);
        
    }];
}

- (void)initSubviews {
    
    
}

#pragma mark - Events
- (void)clickCancel {
    
    [UIView animateWithDuration:0.2 animations:^{
        
//        self.dataView.y = 0;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
