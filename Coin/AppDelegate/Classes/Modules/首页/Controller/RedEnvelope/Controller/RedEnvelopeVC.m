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
@interface RedEnvelopeVC ()<SendRedEnvelopeDelegate,RedEnvelopeHeadDelegate>

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

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

    [self LoadData];
    
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

    self.title = [LangSwitcher switchLang:@"发红包" key:nil];


    UIButton *_recordButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _recordButton.frame = CGRectMake(0, 0, 0, 44);
    [_recordButton setTitle:[LangSwitcher switchLang:@"我的红包" key:nil] forState:(UIControlStateNormal)];
    _recordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _recordButton.titleLabel.font = Font(14);
    [_recordButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_recordButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:_recordButton]];
    [_recordButton sizeToFit];


    _sendView = [[SendRedEnvelopeView alloc]initWithFrame:CGRectMake(0, - kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT + kNavigationBarHeight)];
    CoinWeakSelf;
    
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


-(void)buttonClick
{
    MySugarPacketsVC *vc = [[MySugarPacketsVC alloc]init];
    UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navigation animated:NO completion:nil];
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
    }
    [self GiveAnyRequestAndCurrency:currency type:type count:count sendNum:sendNum greeting:greeting];

}

#pragma mark - 发红包
-(void)GiveAnyRequestAndCurrency:(NSString *)currency type:(NSString *)type count:(NSString *)count sendNum:(NSString *)sendNum greeting:(NSString *)greeting
{
    
    self.pwdView.hidden = NO;
    self.pwdView.password.textField.enabled = YES;
    CoinWeakSelf;
    self.pwdView.passwordBlock = ^(NSString *password) {
        if ([password isEqualToString:@""]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入资金密码" key:nil]];
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
        } failure:^(NSError *error) {
            weakSelf.pwdView.hidden = YES;

            [weakSelf.pwdView.password clearText];

            NSLog(@"%@",error);
        }];
    };
//    return;
//    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
//                        msg:@""
//                 confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
//                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
//                placeHolder:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
//                      maker:self cancle:^(UIAlertAction *action) {
//
//                      } confirm:^(UIAlertAction *action, UITextField *textField) {
//
//
//                          NSLog(@"%@",textField.text);
//
//
//                      }];
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
