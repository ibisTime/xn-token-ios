//
//  StoreDetailVC.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/14.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "StoreDetailVC.h"
//
#import <AssetsLibrary/ALAssetsLibrary.h>
//Category
#import "UIControl+Block.h"
#import "NSString+Check.h"
//M
#import "StoreModel.h"
//V
#import "StoreDetailHeaderView.h"
#import "DetailWebView.h"
#import "TLProgressHUD.h"
//C
#import "StorePayVC.h"
#import "TLPwdRelatedVC.h"
#import "TLUserLoginVC.h"
#import "TLNavigationController.h"

#define kBtnHeight   40
#define kBottomViewHeight 60

@interface StoreDetailVC ()
//头部
@property (nonatomic, strong) StoreDetailHeaderView *headerView;
//
@property (nonatomic, strong) UIScrollView *scrollView;
//底部按钮
@property (nonatomic, strong) UIView *bottomView;
//图文详情
@property (nonatomic, strong) DetailWebView *detailWebView;
//
@property (nonatomic, strong) StoreModel *store;

@end

@implementation StoreDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang:@"店铺详情" key:nil];
    //获取店铺详情
    [self requestStoreDetail];
    
}

#pragma mark - Init
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , kSuperViewHeight - kBottomViewHeight - kBottomInsetHeight)];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (DetailWebView *)detailWebView {
    
    if (!_detailWebView) {
        
        CoinWeakSelf;
        
        _detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        _detailWebView.webViewBlock = ^(CGFloat height) {
            
            [weakSelf setSubViewLayoutWithHeight:height];
        };
        
        _detailWebView.hidden = YES;
        
        [self.scrollView addSubview:_detailWebView];
    }
    return _detailWebView;
}

- (void)initHeaderView {
    
    self.headerView = [[StoreDetailHeaderView alloc] initWithFrame:CGRectZero];
    
    self.headerView.store = self.store;
    
    [self.scrollView addSubview:self.headerView];
    
    [self.detailWebView loadWebWithString:self.store.desc];
}

/**
 底部按钮
 */
- (void)initBottomBtn {
    
    CoinWeakSelf;
    
    CGFloat viewH = kBottomViewHeight + kBottomInsetHeight;
    CGFloat leftMargin = 15;
    CGFloat topMargin = 10;
    CGFloat btnW = (kScreenWidth - 3*15)/2.0;
    //
    self.bottomView = [[UIView alloc] init];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(viewH));
    }];
    
    //联系对方
    UIButton *lineBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"联系对方" key:nil]
                                       titleColor:kWhiteColor
                                  backgroundColor:kAppCustomMainColor
                                        titleFont:16.0
                                     cornerRadius:5];
    
    [lineBtn bk_addEventHandler:^(id sender) {
        //获取店主手机号
        if (![weakSelf.store.bookMobile valid]) {
            
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"暂无店主手机号" key:nil]];
            return ;
        }
        //
        NSString *mobile = [NSString stringWithFormat:@"telprompt://%@", weakSelf.store.bookMobile];
        NSURL *url = [NSURL URLWithString:mobile];
        [[UIApplication sharedApplication] openURL:url];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:lineBtn];
    [lineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(topMargin));
        make.left.equalTo(@(leftMargin));
        make.height.equalTo(@(kBtnHeight));
        make.width.equalTo(@(btnW));
    }];
    
    //支付
    UIButton *buyBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"我要支付" key:nil]
                                      titleColor:kWhiteColor
                                 backgroundColor:kAppCustomMainColor
                                       titleFont:16.0
                                    cornerRadius:5];
    
    [buyBtn addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(topMargin));
        make.right.equalTo(@(-leftMargin));
        make.height.equalTo(@(kBtnHeight));
        make.width.equalTo(@(btnW));
    }];
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    self.detailWebView.frame = CGRectMake(0, self.headerView.yy + 10, kScreenWidth, height);
    self.detailWebView.hidden = NO;
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.detailWebView.yy + 10);
    
    [TLProgressHUD dismiss];
}

#pragma mark - Events
- (void)clickPay {
    
    CoinWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf checkTradePwd];
        };
        
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    [self checkTradePwd];
}

- (void)checkTradePwd {
    
    CoinWeakSelf;
    //判断是否设置资金密码
    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
        
        TLPwdType pwdType = TLPwdTypeSetTrade;
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        pwdRelatedVC.isWallet = YES;
        pwdRelatedVC.success = ^{
            
            [weakSelf checkTradePwd];
        };
        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
        return ;
    }
    
    StorePayVC *payVC = [StorePayVC new];
    
    payVC.code = weakSelf.code;
    
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - Data
/**
 获取店铺详情
 */
- (void)requestStoreDetail {
    
    [TLProgressHUD show];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625328";
    http.parameters[@"code"] = self.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.store = [StoreModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //
        [self initHeaderView];
        //
        [self initBottomBtn];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
