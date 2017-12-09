//
//  IdAuthVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "IdAuthVC.h"
#import "CoinHeader.h"

#import "TLTextField.h"
#import "NSString+Check.h"

#import "AppMacro.h"

@interface IdAuthVC ()
//真实姓名
@property (nonatomic, strong) TLTextField *realName;
//身份证
@property (nonatomic, strong) TLTextField *idCard;

@end

@implementation IdAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LangSwitcher switchLang:@"身份认证" key:nil];
    
    [self initSubviews];

}

#pragma mark - Init
- (void)initSubviews {
    
    BOOL isRealNameExist = [[TLUser user].realName valid];
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat leftMargin = 15;
    
    self.realName = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50) leftTitle:[LangSwitcher switchLang:@"姓名" key:nil] titleWidth:105 placeholder:[LangSwitcher switchLang:@"请输入姓名" key:nil]];
    
    self.realName.enabled = !isRealNameExist;
    
    STRING_NIL_NULL([TLUser user].realName);
    
    self.realName.text = [TLUser user].realName;
    
    self.realName.returnKeyType = UIReturnKeyNext;

    [self.realName addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:self.realName];
    
    self.idCard = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.realName.yy + 1, kScreenWidth, 50) leftTitle:[LangSwitcher switchLang:@"身份证号码" key:nil] titleWidth:105 placeholder:[LangSwitcher switchLang:@"请输入身份证号码" key:nil]];
    
    self.idCard.enabled = !isRealNameExist;

    STRING_NIL_NULL([TLUser user].idNo);
    
    self.idCard.text = [TLUser user].idNo;

    [self.view addSubview:self.idCard];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确认" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:5];
    
    confirmBtn.frame = CGRectMake(leftMargin, self.idCard.yy + 40, kScreenWidth - 2*leftMargin, 45);
    
    [confirmBtn addTarget:self action:@selector(confirmIDCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
 
    confirmBtn.enabled = !isRealNameExist;

    confirmBtn.backgroundColor = isRealNameExist ? kPlaceholderColor: kAppCustomMainColor;
}

#pragma mark - Events
- (void)confirmIDCard:(UIButton *)sender {
    
    
    if (![self.realName.text valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入姓名" key:nil]];
        return;
    }
    
    if (![self.idCard.text valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入身份证号码" key:nil]];
        return;
    }
    
    if (self.idCard.text.length != 18) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入18位身份证号码" key:nil]];
        return;
        
    }
    
    [self.view endEditing:YES];

    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    
    http.code = @"805191";
    http.parameters[@"idKind"] = @"1";
    http.parameters[@"idNo"] = self.idCard.text;
    http.parameters[@"realName"] = self.realName.text;
    http.parameters[@"userId"] = [TLUser user].userId;
//    http.parameters[@"remark"] = @"";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLUser user].realName = self.realName.text;
        
        [TLUser user].idNo = self.idCard.text;
        
        if (self.success) {
            
            self.success();
            
        } else {
            
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"身份认证成功" key:nil]];

            [self.navigationController popViewControllerAnimated:YES];

        }
        
        
//        RealNameAuthResultVC *resultVC = [RealNameAuthResultVC new];
//
//        resultVC.title = @"二要素认证结果";
//
//        resultVC.realName = self.realName.text;
//
//        resultVC.idCard = self.idCard.text;
//
//        if ([responseObject[@"errorCode"] isEqual:@"0"]) {
//
//            resultVC.result = YES;
//
//        } else {
//
//            resultVC.result = NO;
//
//            resultVC.failureReason = responseObject[@"errorInfo"];
//
//        }
//
//        [self.navigationController pushViewController:resultVC animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)next:(UITextField *)sender {
    
    [self.idCard becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
