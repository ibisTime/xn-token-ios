//
//  RedEnvelopeVC.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "RedEnvelopeVC.h"
#import "RedEnvelopeHeadView.h"
#import "SendRedEnvelopeView.h"

#import "RedEnvelopeShoreVC.h"
#import "MySugarPacketsVC.h"

#import "CurrencyModel.h"
#import "TLPwdRelatedVC.h"
#import "AssetPwdView.h"
#import "UIButton+Custom.h"
#import "UIButton+EnLargeEdge.h"
#import "HTMLStrVC.h"
#import "TLPwdRelatedVC.h"
#import "AddAccoutMoneyVc.h"
#import "FilterView.h"
@interface RedEnvelopeVC ()<SendRedEnvelopeDelegate,RedEnvelopeHeadDelegate>

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;
@property (nonatomic, strong) FilterView *filterPicker;

@property (nonatomic , strong)SendRedEnvelopeView *sendView;

@end

@implementation RedEnvelopeVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;

    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    
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
    // Do any additional setup after loading the view.
//    self.title = [LangSwitcher switchLang:@"" key:nil];

    self.title = [LangSwitcher switchLang:@"Theia红包" key:nil];
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
    [titleButton setTitle:[LangSwitcher switchLang:@"Theia红包" key:nil] forState:(UIControlStateNormal)];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    titleButton.titleLabel.font = Font(16);
    [titleButton setTitleColor:kTextBlack forState:(UIControlStateNormal)];
//    [titleButton addTarget:self action:@selector(backbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
//     *tit = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
//
//    tit.frame = CGRectMake(kScreenWidth/2-60, 20, 120, 20);
//    tit.text = [LangSwitcher switchLang:@"Theia红包" key:nil];

   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];

    UIButton *_recordButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _recordButton.frame = CGRectMake(10, 0, 0, 44);
    [_recordButton setTitle:[LangSwitcher switchLang:@"" key:nil] forState:(UIControlStateNormal)];
    _recordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _recordButton.titleLabel.font = Font(14);
    [_recordButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_recordButton setImage:kImage(@"topbar_more") forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:_recordButton]];
    [_recordButton sizeToFit];
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(kScreenWidth/2-60, 0, 120, 50)];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    
    titleText.textColor=kTextColor;
    
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    
    [titleText setText:@"Theia红包"];
    
    self.navigationItem.titleView=titleText;
    

//    UIView *vie = [UIView new];
//    [vie addSubview:tit];
//    tit.frame = vie.bounds;
//    tit.text = [LangSwitcher switchLang:@"Theia红包" key:nil];

//    self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(100, 10, 120, 44)];


    _sendView = [[SendRedEnvelopeView alloc]initWithFrame:CGRectMake(0, - kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT + kNavigationBarHeight)];
    CoinWeakSelf;
    
    self.sendView.transBlock = ^(CurrencyModel *model) {
        AddAccoutMoneyVc *monyVc = [[AddAccoutMoneyVc alloc] init];
        monyVc.isRedPage = YES;
        monyVc.currentModels = weakSelf.currencys;
        [weakSelf.navigationController pushViewController:monyVc animated:YES];
        monyVc.select = ^(NSMutableArray *model) {
          
            NSLog(@"%@",model);
        };
        monyVc.curreryBlock = ^(CurrencyModel *model) {
//            model.currency = model.symbol;
            [weakSelf.sendView Platform:model];
        };
    };
    _sendView.transFormBlock = ^(CurrencyModel *model) {
        RechargeCoinVC *coinVC = [RechargeCoinVC new];
        
        TLNavigationController * navigation = [[TLNavigationController alloc]initWithRootViewController:coinVC];
        coinVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        coinVC.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
        coinVC.currency = model;
        [weakSelf presentViewController:navigation animated:YES completion:nil];

    };
    _sendView.redPackBlock = ^{
        HTMLStrVC *htmlVC = [[HTMLStrVC alloc] init];
        weakSelf.navigationController.navigationBar.hidden = NO;
        
        htmlVC.type = HTMLTypeRed_packet_rule;
//        [weakSelf presentViewController:htmlVC animated:YES completion:nil];
        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
    };
    _sendView.delegate = self;
    [self.view addSubview:_sendView];
    
    AssetPwdView *pwdView =[[AssetPwdView alloc] init];
    self.pwdView = pwdView;
    pwdView.HiddenBlock = ^{
        self.pwdView.hidden = YES;
//        [self.pwdView removeFromSuperview];
    };
    self.pwdView.forgetBlock = ^{
        
        weakSelf.pwdView.hidden = YES;

        TLPwdRelatedVC *vc  = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeTradeReset];

        [weakSelf.navigationController pushViewController:vc animated:YES];
        
        
    };
    pwdView.hidden = YES;
    pwdView.frame = self.view.bounds;
    [self.view addSubview:pwdView];
    RedEnvelopeHeadView *headView = [[RedEnvelopeHeadView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, 44)];
    headView.delegate = self;
    [_sendView addSubview:headView];
    [self LoadData];
}

- (void)backbuttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[[LangSwitcher switchLang:@"我的红包记录" key:nil],
                             [LangSwitcher switchLang:@"红包说明及常见问题" key:nil],
                             ];
        
        NSArray *typeArr = @[@"tt",
                             @"charge",
                             ];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        //        _filterPicker.title =  [LangSwitcher switchLang: @"请选择交易类型" key:nil];
        
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            [weakSelf pickerChoose:index];
//            [weakSelf.tableView beginRefreshing];
        };
        
        _filterPicker.tagNames = textArr;
        
    }
    
    return _filterPicker;
}

- (void)pickerChoose :(NSInteger)integer
{
    if (integer == 0) {
            MySugarPacketsVC *vc = [[MySugarPacketsVC alloc]init];
            UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:vc];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            vc.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:navigation animated:NO completion:nil];
    }else{
        
        HTMLStrVC *htmlVC = [[HTMLStrVC alloc] init];
        self.navigationController.navigationBar.hidden = NO;
        
        htmlVC.type = HTMLTypeRed_packet_rule;
        //        [weakSelf presentViewController:htmlVC animated:YES completion:nil];
        [self.navigationController pushViewController:htmlVC animated:YES];
        
    }
    
}

-(void)buttonClick
{
    
    [self.filterPicker show];

}


#pragma mark - 钱包网络请求
-(void)LoadData
{
    if (![TLUser user].isLogin) {
        return;
    }
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;

    [http postWithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.currencys = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accountList"]];
        _sendView.platforms = self.currencys;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)SendRedEnvelopeButton:(NSInteger)tag currency:(NSString *)currency type:(NSString *)type count:(NSString *)count sendNum:(NSString *)sendNum greeting:(NSString *)greeting
{
    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
        TLPwdType pwdType = TLPwdTypeSetTrade;
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        
        pwdRelatedVC.isWallet = YES;
        pwdRelatedVC.success = ^{
            
            [self GiveAnyRequestAndCurrency:currency type:type count:count sendNum:sendNum greeting:greeting];

            
        };
        
        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
        return;
    }else{
        [self GiveAnyRequestAndCurrency:currency type:type count:count sendNum:sendNum greeting:greeting];

    }

}

#pragma mark - 发红包
-(void)GiveAnyRequestAndCurrency:(NSString *)currency type:(NSString *)type count:(NSString *)count sendNum:(NSString *)sendNum greeting:(NSString *)greeting
{
    
    self.pwdView.hidden = NO;
    self.pwdView.password.textField.enabled = YES;
    CoinWeakSelf;
    self.pwdView.passwordBlock = ^(NSString *password) {
        if ([password isEqualToString:@""]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入您的交易密码" key:nil]];
            return ;
        }
        
        TLNetworking *http = [TLNetworking new];
        http.code = @"623000";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"symbol"] = currency;
        http.parameters[@"type"] = type;
        http.parameters[@"count"] = count;
        http.parameters[@"sendNum"] = sendNum;
        http.parameters[@"greeting"] = greeting;
        http.parameters[@"tradePwd"] = password;
        [http postWithSuccess:^(id responseObject) {
            weakSelf.pwdView.hidden = YES;
            [weakSelf.pwdView.password clearText];
            RedEnvelopeShoreVC *vc = [RedEnvelopeShoreVC new];
            vc.code = responseObject[@"data"][@"code"];
            vc.content = greeting;
            [weakSelf presentViewController:vc animated:YES completion:nil];
        } failure:^(id responseObject) {
            
             if ([responseObject[@"errorCode"] isEqual:@"3"])
            {
                if ([responseObject[@"errorCode"] isEqual:@"HB000001"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"超过红包最大个数限制" key:nil]];
                    
                }else if ([responseObject[@"errorCode"] isEqual:@"HB000002"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"超过红包最大金额限制" key:nil]];
                    
                }else if ([responseObject[@"errorCode"] isEqual:@"HB000003"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"单个红包不能小于0.001" key:nil]];
                    
                }else if ([responseObject[@"errorCode"] isEqual:@"HB000004"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"不存在的红包类型" key:nil]];
                    
                }else if ([responseObject[@"errorCode"] isEqual:@"HB000005"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"红包错误，请联系管理员" key:nil]];
                    
                }else if ([responseObject[@"errorCode"] isEqual:@"HB000006"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"红包已过期，下次记得早点来" key:nil]];
                    
                }else if ([responseObject[@"errorCode"] isEqual:@"HB000007"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"红包已抢完" key:nil]];
                    
                }else if ([responseObject[@"errorCode"] isEqual:@"HB000008"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"红包不存在" key:nil]];
                    
                }
                else if ([responseObject[@"errorCode"] isEqual:@"HB000009"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"红包不存在" key:nil]];
                }
                else if ([responseObject[@"errorCode"] isEqual:@"AC000000"])
                {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"账户可用余额不足" key:nil]];
                }
                
            }
            
            
            weakSelf.pwdView.hidden = YES;

            [weakSelf.pwdView.password clearText];

        }];
    };

}

-(void)RedEnvelopeHeadButton:(NSInteger)tag
{
    switch (tag) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 1:
        {

        }
            break;

        default:
            break;
    }
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//
//}

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
