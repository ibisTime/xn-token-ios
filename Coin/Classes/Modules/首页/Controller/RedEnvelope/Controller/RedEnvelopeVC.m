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
@interface RedEnvelopeVC ()<SendRedEnvelopeDelegate,RedEnvelopeHeadDelegate>

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@property (nonatomic , strong)SendRedEnvelopeView *sendView;

@end

@implementation RedEnvelopeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = [LangSwitcher switchLang:@"" key:nil];


    _sendView = [[SendRedEnvelopeView alloc]initWithFrame:self.view.frame];
    _sendView.delegate = self;
    [self.view addSubview:_sendView];

    RedEnvelopeHeadView *headView = [[RedEnvelopeHeadView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, 44)];
    headView.delegate = self;
    [_sendView addSubview:headView];
    [self LoadData];
}

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
        self.currencys = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accountList"]];
        _sendView.platforms = self.currencys;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)SendRedEnvelopeButton:(NSInteger)tag currency:(NSString *)currency type:(NSString *)type count:(NSString *)count sendNum:(NSString *)sendNum greeting:(NSString *)greeting
{
    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
                        msg:@""
                 confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                placeHolder:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
                      maker:self cancle:^(UIAlertAction *action) {

                      } confirm:^(UIAlertAction *action, UITextField *textField) {

                          if ([textField.text isEqualToString:@""]) {
                              [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入资金密码" key:nil]];
                              return ;
                          }
                          NSLog(@"%@",textField.text);
                          TLNetworking *http = [TLNetworking new];
                          http.code = @"623000";
                          http.parameters[@"userId"] = [TLUser user].userId;
                          http.parameters[@"symbol"] = currency;
                          http.parameters[@"type"] = type;
                          http.parameters[@"count"] = count;
                          http.parameters[@"sendNum"] = sendNum;
                          http.parameters[@"greeting"] = greeting;
                          http.parameters[@"tradePwd"] = textField.text;
                          [http postWithSuccess:^(id responseObject) {

                              RedEnvelopeShoreVC *vc = [RedEnvelopeShoreVC new];
                              vc.code = responseObject[@"data"][@"code"];
                              [self presentViewController:vc animated:YES completion:nil];
                              NSLog(@"%@",responseObject);
                          } failure:^(NSError *error) {
                              NSLog(@"%@",error);
                          }];

                      }];



}

-(void)RedEnvelopeHeadButton:(NSInteger)tag
{
    switch (tag) {
        case 0:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 1:
        {
            MySugarPacketsVC *vc = [[MySugarPacketsVC alloc]init];
            UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:vc];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            vc.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:navigation animated:NO completion:nil];
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
