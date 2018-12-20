//
//  TLNewPwdVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/21.
//  Copyright © 2018年 chengdai. All rights reserved.
//
#define ACCOUNT_MARGIN 0;
#define ACCOUNT_HEIGHT 50;
#import "TLNewPwdVC.h"
#import "CaptchaView.h"
#import "NSString+Check.h"
#import "APICodeMacro.h"
#import "UIBarButtonItem+convience.h"
#import "ChooseCountryVc.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "CountryModel.h"
#import "NSString+Check.h"
#import <SecurityGuardSDK/JAQ/SecurityVerification.h>
#import <MSAuthSDK/MSAuthVCFactory.h>
#import <MSAuthSDK/MSAuthSDK.h>
#import <SecurityGuardSDK/JAQ/SecurityVerification.h>


@interface TLNewPwdVC ()<MSAuthProtocol>
@property (nonatomic,strong) TLTextField *phoneTf;

@property (nonatomic,strong) TLTextField *pwdTf;

@property (nonatomic,strong) TLTextField *rePwdTf;
@property (nonatomic,strong) TLTextField *surePwdTf;

@property (nonatomic, strong) CaptchaView *captchaView;
@property (nonatomic ,strong) UILabel *titlePhpne;
@property (nonatomic ,strong) UILabel *PhoneCode;
@property (nonatomic ,strong) UIImageView *accessoryImageView;
@property (nonatomic ,strong) UIImageView *pic;

@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;

@end

@implementation TLNewPwdVC

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
        self.title = [LangSwitcher switchLang:@"修改交易密码" key:nil];
 
    
    self.view.backgroundColor = kWhiteColor;
    
    [self initSubviews];
//    [self loadData];
    
}

- (void)initSubviews {
    
    self.view.backgroundColor = kWhiteColor;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    
    CGFloat btnMargin = 15;
   
    
    
  
    
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin,  10, w, h) leftTitle:[LangSwitcher switchLang:@"旧密码" key:nil] titleWidth:80 placeholder:[LangSwitcher switchLang:@"请输入密码" key:nil]];
    //    pwdTf.keyboardType = UIKeyboardTypePhonePad;
//    pwdTf.returnKeyType = UIReturnKeyNext;
    pwdTf.secureTextEntry = YES;
    [self.view addSubview:pwdTf];
    self.pwdTf = pwdTf;
    UIView *phone3 = [[UIView alloc] init];
    [self.view addSubview:phone3];
    phone3.backgroundColor = kLineColor;
    phone3.frame = CGRectMake(btnMargin, pwdTf.yy, w-30, 1);
    
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pwdTf.yy + 1, w, h) leftTitle:[LangSwitcher switchLang:@"新密码" key:nil] titleWidth:80 placeholder:[LangSwitcher switchLang:@"请输入密码" key:nil]];
    //    rePwdTf.keyboardType = UIKeyboardTypePhonePad;
    rePwdTf.secureTextEntry = YES;

//    rePwdTf.returnKeyType = UIReturnKeyNext;
    [rePwdTf addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:rePwdTf];
    self.rePwdTf = rePwdTf;
    UIView *phone4 = [[UIView alloc] init];
    [self.view addSubview:phone4];
    phone4.backgroundColor = kLineColor;
    phone4.frame = CGRectMake(btnMargin, rePwdTf.yy, w-30, 1);
    
    TLTextField *surePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, rePwdTf.yy + 1, w, h) leftTitle:[LangSwitcher switchLang:@"确认密码" key:nil] titleWidth:80 placeholder:[LangSwitcher switchLang:@"请输入密码" key:nil]];
    //    rePwdTf.keyboardType = UIKeyboardTypePhonePad;
    surePwdTf.secureTextEntry = YES;

    surePwdTf.returnKeyType = UIReturnKeyDone;
    [rePwdTf addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:surePwdTf];
    self.surePwdTf = surePwdTf;
    UIView *phone5 = [[UIView alloc] init];
    [self.view addSubview:phone5];
    phone5.backgroundColor = kLineColor;
    phone5.frame = CGRectMake(btnMargin, surePwdTf.yy, w-30, 1);
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确认" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(btnMargin);
        make.width.mas_equalTo(kScreenWidth - 2*btnMargin);
        make.height.mas_equalTo(h - 5);
        make.top.mas_equalTo(surePwdTf.mas_bottom).mas_equalTo(20);
        
    }];
}
- (void)chooseCountry
{
    
    //选择国家 设置区号
    CoinWeakSelf;
    ChooseCountryVc *countryVc = [ChooseCountryVc new];
    countryVc.selectCountry = ^(CountryModel *model) {
        //更新国家 区号
        weakSelf.titlePhpne.text = model.chineseName;
        weakSelf.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
    } ;
    [self presentViewController:countryVc animated:YES completion:nil];
}

#pragma mark - Events
- (void)sendCaptcha {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
        
        return;
    }
    

    
    LangType type = [LangSwitcher currentLangType];
    NSString *lang;
    if (type == LangTypeSimple || type == LangTypeTraditional) {
        lang = @"zh_CN";
    }else if (type == LangTypeKorean)
    {
        lang = @"nil";


    }else{
        lang = @"en";

    }
    UIViewController *vc = [MSAuthVCFactory simapleVerifyWithType:(MSAuthTypeSlide) language:lang Delegate:self authCode:@"0335" appKey:nil];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)verifyDidFinishedWithResult:(t_verify_reuslt)code Error:(NSError *)error SessionId:(NSString *)sessionId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            NSLog(@"验证失败 %@", error);
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证失败" key:nil]];
        } else {
            NSLog(@"验证通过 %@", sessionId);
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = CAPTCHA_CODE;
            http.parameters[@"bizType"] = USER_FIND_PWD_CODE;
            http.parameters[@"sessionId"] = sessionId;
            http.parameters[@"mobile"] = self.phoneTf.text;
            http.parameters[@"interCode"] = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];
            http.parameters[@"client"] = @"ios";

            [http postWithSuccess:^(id responseObject) {

                [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证码已发送,请注意查收" key:nil]];

                [self.captchaView.captchaBtn begin];

            } failure:^(NSError *error) {


            }];

        }
        [self.navigationController popViewControllerAnimated:YES];
        //将sessionid传到经过app服务器做二次验证
    });
}

- (void)changePwd {
    
    if (!self.pwdTf.text || [self.pwdTf.text isBlank]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入旧密码" key:nil]];
        return;
    }
    
    
    if (!self.rePwdTf.text || [self.rePwdTf.text isBlank]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入新密码" key:nil]];
        return;
    }
    
    if (self.rePwdTf.text.length < 6) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码不得小于6位数" key:nil]];
        return;
    }
    
    if (!self.surePwdTf.text|| [self.surePwdTf.text isBlank]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入新密码" key:nil]];
        return;
    }
    
    if (![self.rePwdTf.text isEqualToString:self.surePwdTf.text]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"输入的密码不一致" key:nil]];
        return;
        
    }
    
//    TLDataBase *dataBase = [TLDataBase sharedManager];
//    NSString *word;
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT PwdKey from THAUser where userId = '%@'",[TLUser user].userId];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            word = [set stringForColumn:@"PwdKey"];
//            if ([word isEqualToString:@""]) {
//                word = @"111111";
//            }
//
//        }
//        [set close];
//    }
//    [dataBase.dataBase close];
    
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:MNEMONICPASSWORD] isEqualToString:self.pwdTf.text]) {
        [TLAlert alertWithError:[LangSwitcher switchLang:@"交易密码错误" key:nil]];
        return;
    }
    
//    TLDataBase *db = [TLDataBase sharedManager];
//    if ([db.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"UPDATE THAUser SET PwdKey = '%@' WHERE userId = '%@'",self.rePwdTf.text,[TLUser user].userId];
//        BOOL sucess = [db.dataBase executeUpdate:sql];
//
////        NSLog(@"导入钱包交易密码%d",sucess);
//
//    }
//    [db.dataBase close];
    [[NSUserDefaults standardUserDefaults] setObject:self.pwdTf.text forKey:MNEMONICPASSWORD];
    [self.view endEditing:YES];
    [TLAlert alertWithSucces:[LangSwitcher switchLang:@"修改成功" key:nil]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}

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
