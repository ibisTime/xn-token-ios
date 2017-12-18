//
//  ZMAuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ZMAuthVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "ZMAuthResultVC.h"

#import "TLTextField.h"
#import "NSString+Check.h"
#import "AppMacro.h"

#define IsZMCertVideo false

@interface ZMAuthVC ()

@property (nonatomic, strong) TLTextField *realName;    //真实姓名
@property (nonatomic, strong) TLTextField *idCard;      //身份证

@end

@implementation ZMAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameAuth:) name:@"RealNameAuthResult" object:nil];
    
}

#pragma mark - Init
- (void)initSubviews {
    
    BOOL isRealNameExist = [[TLUser user].realName valid];

    CGFloat leftMargin = 15;
    
    self.realName = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:[LangSwitcher switchLang:@"姓名" key:nil] titleWidth:105 placeholder:[LangSwitcher switchLang:@"请输入姓名" key:nil]];
    
    self.realName.returnKeyType = UIReturnKeyNext;
    
    self.realName.enabled = !isRealNameExist;

    STRING_NIL_NULL([TLUser user].realName);
    
    self.realName.text = [TLUser user].realName;
    
    [self.realName addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:self.realName];
    
    self.idCard = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.realName.yy + 1, kScreenWidth, 50) leftTitle:[LangSwitcher switchLang:@"身份证号码" key:nil] titleWidth:105 placeholder:[LangSwitcher switchLang:@"请输入身份证号码" key:nil]];
    
    STRING_NIL_NULL([TLUser user].idNo);
    
    self.idCard.text = [TLUser user].idNo;
    
    [self.view addSubview:self.idCard];
    
    
    UIColor *bgColor = isRealNameExist ? kPlaceholderColor: kAppCustomMainColor;

    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确定" key:nil] titleColor:kWhiteColor backgroundColor:bgColor titleFont:15.0 cornerRadius:45/2.0];
    
    confirmBtn.frame = CGRectMake(leftMargin, self.idCard.yy + 40, kScreenWidth - 2*leftMargin, 45);
    
    confirmBtn.enabled = !isRealNameExist;

    [confirmBtn addTarget:self action:@selector(confirmIDCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    
    
}

#pragma mark - Notification

- (void)realNameAuth:(NSNotification *)notification {
    
    if ([notification.object isEqualToString:@"1"]) {
        
        [TLUser user].realName = self.realName.text;
        
        [TLUser user].idNo = self.idCard.text;
        
        if (self.success) {
            
            self.success();
        }
    
    } else {
    
        [TLAlert alertWithError:[LangSwitcher switchLang:@"认证失败, 请重新认证" key:nil]];
    }
    
}

#pragma mark - Events

- (void)next:(UITextField *)sender {
    
    [self.idCard becomeFirstResponder];
}

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
    
    //芝麻认证
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805195";
    http.parameters[@"idNo"] = self.idCard.text;
    http.parameters[@"realName"] = self.realName.text;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"returnUrl"] = @"Bcoin://certi.back";
    http.parameters[@"localCheck"] = @"0";
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([responseObject[@"errorCode"] isEqual:@"0"]) {
            
            NSString *bizNo = responseObject[@"data"][@"bizNo"];

            [TLUser user].tempBizNo = bizNo;

            NSString *urlStr = responseObject[@"data"][@"url"];
            
            [self doVerify:urlStr];

        } else {
            
            ZMAuthResultVC *authResultVC = [ZMAuthResultVC new];
            
            authResultVC.title = [LangSwitcher switchLang:@"实名认证结果" key:nil];
            
            authResultVC.result = NO;
            
            authResultVC.realName = self.realName.text;
            
            authResultVC.idCard = self.idCard.text;
            
            authResultVC.failureReason = responseObject[@"errorInfo"];
            
            [self.navigationController pushViewController:authResultVC animated:YES];
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 跳转到支付宝认证
- (void)doVerify:(NSString *)url {
    
    // 这里使用固定appid 20000067
    NSString *alipayUrl = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000067&url=%@",
                           [self URLEncodedStringWithUrl:url]];
    
    if ([self canOpenAlipay]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl]];
        
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alipayUrl] options:@{} completionHandler:nil];
        
    } else {
        
        [TLAlert alertWithTitle:[LangSwitcher switchLang:@"是否下载并安装支付宝完成认证?" key:nil] msg:[LangSwitcher switchLang:@"" key:nil] confirmMsg:[LangSwitcher switchLang:@"好的" key:nil] cancleMsg:[LangSwitcher switchLang:@"取消" key:nil] cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            NSString *appstoreUrl = @"itms-apps://itunes.apple.com/app/id333206289";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];
            
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl] options:@{} completionHandler:nil];
            
        }];
        
    }
}

- (NSString *)URLEncodedStringWithUrl:(NSString *)url {
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef) @"!'();:@&=+$,%#[]|",kCFStringEncodingUTF8));
    
    return encodedString;
}

- (BOOL)canOpenAlipay {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
