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
//@property (nonatomic,strong) TLTextField *phoneTf;

@property (nonatomic,strong) UITextField *pwdTf;

@property (nonatomic,strong) UITextField *rePwdTf;
@property (nonatomic,strong) UITextField *surePwdTf;

@property (nonatomic, strong) CaptchaView *captchaView;
//@property (nonatomic ,strong) UILabel *titlePhpne;
//@property (nonatomic ,strong) UILabel *PhoneCode;
//@property (nonatomic ,strong) UIImageView *accessoryImageView;
//@property (nonatomic ,strong) UIImageView *pic;

@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;

@end

@implementation TLNewPwdVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self navigationSetDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
        self.title = [LangSwitcher switchLang:@"修改交易密码" key:nil];
 
    
    self.view.backgroundColor = kWhiteColor;
    
    [self initSubviews];
//    [self loadData];
    
}

- (void)initSubviews {
    
    
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"设置交易密码" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    
    
    
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:passwordView];
    
    NSArray *passWordArray = @[[LangSwitcher switchLang:@"旧密码" key:nil],[LangSwitcher switchLang:@"输入交易密码" key:nil],[LangSwitcher switchLang:@"确认交易密码" key:nil]];
    NSArray *placArray = @[[LangSwitcher switchLang:@"请输入旧密码" key:nil],[LangSwitcher switchLang:@"请输入交易密码" key:nil],[LangSwitcher switchLang:@"请确认交易密码" key:nil]];
    
    for (int i = 0; i < 3; i ++) {
        UILabel *passWordLbl = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + i % 3 * 108, SCREEN_WIDTH - 70, 16) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
        passWordLbl.text = passWordArray[i];
        [passwordView addSubview:passWordLbl];
        
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, passWordLbl.yy + 21 - 1.5, 10, 15)];
        iconImage.image = kImage(@"安全组拷贝");
        [passwordView addSubview:iconImage];
        
        UITextField *passWordFid = [[UITextField alloc]initWithFrame:CGRectMake(iconImage.xx + 15, passWordLbl.yy + 21 - 1.5, SCREEN_WIDTH - iconImage.xx - 40 , 15)];
        passWordFid.placeholder = placArray[i];
        passWordFid.secureTextEntry = YES;
        [passWordFid setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
        passWordFid.font = FONT(14);
        passWordFid.textColor = [UIColor whiteColor];
        [passWordFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
        passWordFid.clearsOnBeginEditing = NO;
        passWordFid.clearButtonMode = UITextFieldViewModeWhileEditing;
        [passwordView addSubview:passWordFid];
        
        if (i == 0) {
            _pwdTf = passWordFid;
        }else if (i == 1)
        {
            _rePwdTf = passWordFid;
        }else
        {
            _surePwdTf = passWordFid;
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5, SCREEN_WIDTH - 70, 1)];
        lineView.backgroundColor = kLineColor;
        [passwordView addSubview:lineView];
        
        if (i == 0) {
            UILabel *label = [UILabel labelWithFrame:CGRectMake(passWordFid.x, lineView.yy + 5, SCREEN_WIDTH - passWordFid.x, 10) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(10) textColor:kHexColor(@"d6d5d5")];
            label.text = [LangSwitcher switchLang:@"密码为6位以上数字或字母" key:nil];
            [passwordView addSubview:label];
        }
        
        
    }
    
    
    UILabel *note = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + 108 * 3 - 40, 0, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    note.text = [LangSwitcher switchLang:@"注：" key:nil];
    [note sizeToFit];
    [passwordView addSubview:note];
    
    NSArray *securityArray = @[[LangSwitcher switchLang:@"密码，用户解锁钱包和法币" key:nil],[LangSwitcher switchLang:@"交易密码为本地密码，请妥善保管，丢失将无法找回" key:nil],[LangSwitcher switchLang:@"可通过删除私钥钱包重新导入助记词设置新密码" key:nil]];
    
    UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(note.xx, note.yy + 8, 4, 4)];
    pointView.backgroundColor = kWhiteColor;
    kViewRadius(pointView, 2);
    [passwordView addSubview:pointView];
    
    UILabel *securityLbl = [UILabel labelWithFrame:CGRectMake(pointView.xx + 6, pointView.y - 4, SCREEN_WIDTH - pointView.xx - 6 - 10, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    securityLbl.text = securityArray[0];
    securityLbl.tag = 200;
    securityLbl.numberOfLines = 0;
    [securityLbl sizeToFit];
    [passwordView addSubview:securityLbl];
    
    
    
    
    UIView *pointView1 = [[UIView alloc]initWithFrame:CGRectMake(note.xx, securityLbl.yy + 10, 4, 4)];
    pointView1.backgroundColor = kWhiteColor;
    kViewRadius(pointView1, 2);
    [passwordView addSubview:pointView1];
    
    UILabel *securityLbl1 = [UILabel labelWithFrame:CGRectMake(pointView1.xx + 6, pointView1.y - 4, SCREEN_WIDTH - pointView1.xx - 6 - 10, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    securityLbl1.text = securityArray[1];
    securityLbl1.tag = 201;
    securityLbl1.numberOfLines = 0;
    [securityLbl1 sizeToFit];
    [passwordView addSubview:securityLbl1];
    
    UIView *pointView2 = [[UIView alloc]initWithFrame:CGRectMake(note.xx, securityLbl1.yy + 10, 4, 4)];
    pointView2.backgroundColor = kWhiteColor;
    kViewRadius(pointView2, 2);
    [passwordView addSubview:pointView2];
    
    UILabel *securityLbl2 = [UILabel labelWithFrame:CGRectMake(pointView2.xx + 6, pointView2.y - 4, SCREEN_WIDTH - pointView2.xx - 6 - 10, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    securityLbl2.text = securityArray[2];
    securityLbl2.tag = 202;
    securityLbl2.numberOfLines = 0;
    [securityLbl2 sizeToFit];
    [passwordView addSubview:securityLbl2];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, securityLbl2.yy + 30, 50, 50);
    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(changePwd) forControlEvents:(UIControlEventTouchUpInside)];
    [passwordView addSubview:confirmBtn];
}


//- (void)chooseCountry{
//
//    //选择国家 设置区号
//    CoinWeakSelf;
//    ChooseCountryVc *countryVc = [ChooseCountryVc new];
//    countryVc.selectCountry = ^(CountryModel *model) {
//        //更新国家 区号
//        weakSelf.titlePhpne.text = model.chineseName;
//        weakSelf.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
//    } ;
//    [self presentViewController:countryVc animated:YES completion:nil];
//}

#pragma mark - Events
//- (void)sendCaptcha {
//
//    if (![self.phoneTf.text isPhoneNum]) {
//
//        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
//
//        return;
//    }
//
//
//
//    LangType type = [LangSwitcher currentLangType];
//    NSString *lang;
//    if (type == LangTypeSimple || type == LangTypeTraditional) {
//        lang = @"zh_CN";
//    }else if (type == LangTypeKorean)
//    {
//        lang = @"nil";
//
//
//    }else{
//        lang = @"en";
//
//    }
//    UIViewController *vc = [MSAuthVCFactory simapleVerifyWithType:(MSAuthTypeSlide) language:lang Delegate:self authCode:@"0335" appKey:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//
//}

//-(void)verifyDidFinishedWithResult:(t_verify_reuslt)code Error:(NSError *)error SessionId:(NSString *)sessionId{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (error) {
//            NSLog(@"验证失败 %@", error);
//            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证失败" key:nil]];
//        } else {
//            NSLog(@"验证通过 %@", sessionId);
//            TLNetworking *http = [TLNetworking new];
//            http.showView = self.view;
//            http.code = CAPTCHA_CODE;
//            http.parameters[@"bizType"] = USER_FIND_PWD_CODE;
//            http.parameters[@"sessionId"] = sessionId;
//            http.parameters[@"mobile"] = self.phoneTf.text;
//            http.parameters[@"interCode"] = [NSString stringWithFormat:@"00%@",[self.PhoneCode.text substringFromIndex:1]];
//            http.parameters[@"client"] = @"ios";
//
//            [http postWithSuccess:^(id responseObject) {
//
//                [TLAlert alertWithSucces:[LangSwitcher switchLang:@"验证码已发送,请注意查收" key:nil]];
//
//                [self.captchaView.captchaBtn begin];
//
//            } failure:^(NSError *error) {
//
//
//            }];
//
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//        //将sessionid传到经过app服务器做二次验证
//    });
//}

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
    [[NSUserDefaults standardUserDefaults] setObject:self.rePwdTf.text forKey:MNEMONICPASSWORD];
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
