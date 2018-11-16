//
//  TheInitialView.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/12.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TheInitialView.h"

@implementation TheInitialView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + kStatusBarHeight)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    UIImageView *backView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.image = kImage(@"安全组");
    [scrollView addSubview:backView];
    
    UILabel *personalWalletLb = [UILabel labelWithFrame:CGRectMake(0, kNavigationBarHeight + 4.5, SCREEN_WIDTH, 30) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(18) textColor:kHexColor(@"#ffffff")];
    personalWalletLb.text = [LangSwitcher switchLang:@"个人钱包" key:nil];
    [backView addSubview:personalWalletLb];
    
    
    UILabel *personalWalletIntroduceLb = [UILabel labelWithFrame:CGRectMake(31, personalWalletLb.yy + 10, SCREEN_WIDTH - 62, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#ffffff")];
    personalWalletIntroduceLb.numberOfLines = 0;
    personalWalletIntroduceLb.attributedText = [UserModel ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"便捷的资产管理，绝对安全的“存入即冷”托管模式。个人钱包还提供了稳定的资产理财方案和趣味应用" key:nil]];
    [personalWalletIntroduceLb sizeToFit];
    [backView addSubview:personalWalletIntroduceLb];
    
    
    UIButton *loginPersonalBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"登录个人账号" key:nil] titleColor:kHexColor(@"#0064ff") backgroundColor:kWhiteColor titleFont:16 cornerRadius:10];
    loginPersonalBtn.frame = CGRectMake(50, backView.yy - 90, SCREEN_WIDTH/2 - 57.5, 40);
    [loginPersonalBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    loginPersonalBtn.tag = 100;
    [scrollView addSubview:loginPersonalBtn];
    
    UIButton *createPersonalBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"创建个人账号" key:nil] titleColor:kHexColor(@"#a7a7a7") backgroundColor:kWhiteColor titleFont:16 cornerRadius:10];
    createPersonalBtn.frame = CGRectMake(SCREEN_WIDTH/2 + 7.5, backView.yy - 90, SCREEN_WIDTH/2 - 57.5, 40);
    [createPersonalBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    createPersonalBtn.tag = 101;
    [scrollView addSubview:createPersonalBtn];
    
    
    
    
    //    私钥
    UIImageView *backView1 =[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView1.image = kImage(@"安全组");
    [scrollView addSubview:backView1];
    
    UILabel *privateWalletLb = [UILabel labelWithFrame:CGRectMake(0, kNavigationBarHeight + 4.5, SCREEN_WIDTH, 30) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(18) textColor:kHexColor(@"#ffffff")];
    privateWalletLb.text = [LangSwitcher switchLang:@"私钥钱包" key:nil];
    [backView1 addSubview:privateWalletLb];
    
    
    UILabel *privateWalletIntroduceLb = [UILabel labelWithFrame:CGRectMake(31, privateWalletLb.yy + 10, SCREEN_WIDTH - 62, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#ffffff")];
    privateWalletIntroduceLb.numberOfLines = 0;
    privateWalletIntroduceLb.attributedText = [UserModel ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"Theia的私钥钱包是一款多链钱包，便捷的管理你的所有链上资产，私钥本地保存，安全可靠。" key:nil]];
    [privateWalletIntroduceLb sizeToFit];
    [backView1 addSubview:privateWalletIntroduceLb];
    
    UIButton *loginPrivateBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"创建私钥钱包" key:nil] titleColor:kHexColor(@"#0064ff") backgroundColor:kWhiteColor titleFont:16 cornerRadius:10];
    loginPrivateBtn.frame = CGRectMake(SCREEN_WIDTH + 50, backView1.yy - 90, SCREEN_WIDTH/2 - 57.5, 40);
    [loginPrivateBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    loginPrivateBtn.tag = 102;
    [scrollView addSubview:loginPrivateBtn];
    
    UIButton *createPrivateBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"导入助记词" key:nil] titleColor:kHexColor(@"#a7a7a7") backgroundColor:kWhiteColor titleFont:16 cornerRadius:10];
    createPrivateBtn.frame = CGRectMake( SCREEN_WIDTH+ SCREEN_WIDTH/2 + 7.5, backView1.yy - 90, SCREEN_WIDTH/2 - 57.5, 40);
    [createPrivateBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    createPrivateBtn.tag = 103;
    [scrollView addSubview:createPrivateBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT  - 90 - 30, 80, 4)];
    lineView.backgroundColor = kHexColor(@"#489fff");
    kViewRadius(lineView, 2);
    [self addSubview:lineView];
    
    UIView *dynamicLineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT - 90 - 30, 40, 4)];
    self.dynamicLineView = dynamicLineView;
    dynamicLineView.backgroundColor = kHexColor(@"#ffffff");
    kViewRadius(dynamicLineView, 2);
    [self addSubview:dynamicLineView];
    
}


-(void)btnClick:(UIButton *)sender
{
    [_delegate TheInitialViewBtnClick:sender.tag - 100];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat w = scrollView.contentOffset.x/SCREEN_WIDTH;
    NSLog(@"%.2f",scrollView.contentOffset.x);
    NSLog(@"%.2f",w);
    
    [UIView animateWithDuration:0.1 animations:^{
        self.dynamicLineView.frame = CGRectMake(SCREEN_WIDTH/2 - 40 + w * 40, SCREEN_HEIGHT - 90 - 30, 40, 4);
    }];
    
}


@end
