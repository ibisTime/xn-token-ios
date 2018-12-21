//
//  LoginVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/15.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "LoginVC.h"
#import "SearchCountriesVC.h"
#import "RegisterVC.h"
#import <UMMobClick/MobClick.h>
#import "TLTabBarController.h"

#import "ForgotPasswordVC.h"
@interface LoginVC ()
{
    UIButton *isSelectBtn;
    UIView *registerLineView;
    NSString *phone;
    NSString *email;
}
@property (nonatomic , strong)UIButton *phoneAreaCodeBtn;
@property (nonatomic , strong)UITextField *phoneTextFid;
@property (nonatomic , strong)UITextField *codeTextFid;
@property (nonatomic , strong)UILabel *codeLabel;
@property (nonatomic , strong)UIView *lineView;
@end


@implementation LoginVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}

-(void)initView
{
    
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:backView];
    
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"登录Theia个人账户" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    

    NSArray *array = @[[LangSwitcher switchLang:@"手机登录" key:nil],[LangSwitcher switchLang:@"邮箱登录" key:nil]];
    for (int i = 0; i < 2; i ++) {
        UIButton *phoneAndEmailRegister = [UIButton buttonWithTitle:array[i] titleColor:kHexColor(@"d6d5d5") backgroundColor:kClearColor titleFont:16];
        [phoneAndEmailRegister setTitleColor:kWhiteColor forState:(UIControlStateSelected)];
        phoneAndEmailRegister.frame = CGRectMake(35 + i %2*((SCREEN_WIDTH - 70)/2), 160 - 64 + kNavigationBarHeight, (SCREEN_WIDTH - 70)/2, 16);
        if (i == 0) {
            phoneAndEmailRegister.selected = YES;
            isSelectBtn = phoneAndEmailRegister;
            
            registerLineView = [[UIView alloc]initWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + 30, (SCREEN_WIDTH - 70)/2, 1)];
            registerLineView.backgroundColor = kWhiteColor;
            [backView addSubview:registerLineView];
        }
        phoneAndEmailRegister.titleLabel.font = HGboldfont(16);
        [phoneAndEmailRegister addTarget:self action:@selector(phoneAndEmailRegisterClick:) forControlEvents:(UIControlEventTouchUpInside)];
        phoneAndEmailRegister.tag = 100 + i;
        [backView addSubview:phoneAndEmailRegister];
    }
    
    _phoneAreaCodeBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    
    _phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, 0, 15);
    _phoneAreaCodeBtn.titleLabel.font = HGboldfont(15);
    [_phoneAreaCodeBtn sizeToFit];
    _phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, _phoneAreaCodeBtn.frame.size.width + 6.5, 15);
    [_phoneAreaCodeBtn setImage:kImage(@"矩形4") forState:(UIControlStateNormal)];
    CGFloat imageW = _phoneAreaCodeBtn.imageView.image.size.width;
    CGFloat titleW = _phoneAreaCodeBtn.titleLabel.frame.size.width;
    CGFloat imageOffset = titleW + 0.5 * 3;
    CGFloat titleOffset = imageW + 0.5 * 3;
    _phoneAreaCodeBtn.imageEdgeInsets = UIEdgeInsetsMake(6.5, imageOffset, 0, - imageOffset);
    _phoneAreaCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
    [_phoneAreaCodeBtn addTarget:self action:@selector(phoneAreaCodeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [backView addSubview:_phoneAreaCodeBtn];
    
    
    
    _phoneTextFid = [[UITextField alloc]initWithFrame:CGRectMake(_phoneAreaCodeBtn.xx + 15, registerLineView.yy + 50, SCREEN_WIDTH - _phoneAreaCodeBtn.xx - 60, 15)];
    _phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的手机号码" key:nil];
    //    phoneTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [_phoneTextFid setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
    _phoneTextFid.font = FONT(14);
    _phoneTextFid.textColor = [UIColor whiteColor];
    [_phoneTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTextFid.clearsOnBeginEditing = NO;
    _phoneTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:_phoneTextFid];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, _phoneTextFid.yy + 13, SCREEN_WIDTH - 70, 1)];
    lineView.backgroundColor = kWhiteColor;
    [backView addSubview:lineView];
    
    UILabel *codeLabel = [UILabel labelWithFrame:CGRectMake(46, lineView.yy + 29, 0, 15) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(15) textColor:kWhiteColor];
    codeLabel.text = [LangSwitcher switchLang:@"密码" key:nil];
    [codeLabel sizeToFit];
    if (codeLabel.width >= 100) {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, 100, 15);
    }else
    {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, codeLabel.width, 15);
    }
    
    [backView addSubview:codeLabel];

    
    _codeTextFid = [[UITextField alloc]initWithFrame:CGRectMake(codeLabel.xx + 15, lineView.yy + 29, SCREEN_WIDTH - codeLabel.xx - 15 - 45, 15)];
    _codeTextFid.placeholder = [LangSwitcher switchLang:@"请输入密码" key:nil];
    //    codeTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [_codeTextFid setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
    _codeTextFid.font = FONT(14);
    _codeTextFid.textColor = [UIColor whiteColor];
    [_codeTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    _codeTextFid.clearsOnBeginEditing = NO;
    _codeTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTextFid.secureTextEntry = YES;
    [backView addSubview:_codeTextFid];
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(35, codeLabel.yy + 13, SCREEN_WIDTH - 70, 1)];
    lineView1.backgroundColor = kWhiteColor;
    [backView addSubview:lineView1];

    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"登录" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:18];
    confirmBtn.frame = CGRectMake(35, lineView1.yy + 45, SCREEN_WIDTH - 70, 50);
    kViewRadius(confirmBtn, 10);
    [confirmBtn setBackgroundImage:kImage(@"矩形5-1") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(BtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    confirmBtn.tag = 100;
    [backView addSubview:confirmBtn];
    
    
    UIButton *registeredBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"立即注册" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:15];
    registeredBtn.frame = CGRectMake(0, confirmBtn.yy + 10, SCREEN_WIDTH/2 - 15, 30);
    registeredBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registeredBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:3.5 imagePositionBlock:^(UIButton *button) {
        [button setImage:kImage(@"矩形5-2") forState:(UIControlStateNormal)];
    }];
    [registeredBtn addTarget:self action:@selector(BtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    registeredBtn.tag = 101;
    [backView addSubview:registeredBtn];
    
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 0.5, confirmBtn.yy + 10 + 7.5, 1, 15)];
    lineView2.backgroundColor = kWhiteColor;
    [backView addSubview:lineView2];
    
    
    UIButton *forgotPasswordBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"忘记密码" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:15];
    [forgotPasswordBtn addTarget:self action:@selector(BtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    forgotPasswordBtn.tag = 102;
    forgotPasswordBtn.frame = CGRectMake(SCREEN_WIDTH/2 + 15, confirmBtn.yy + 10, SCREEN_WIDTH/2 - 15, 30);
    forgotPasswordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgotPasswordBtn SG_imagePositionStyle:(SGImagePositionStyleRight) spacing:3.5 imagePositionBlock:^(UIButton *button) {
        [button setImage:kImage(@"矩形5-2") forState:(UIControlStateNormal)];
    }];
    [backView addSubview:forgotPasswordBtn];
    
}


-(void)phoneAreaCodeBtnClick
{
    if (isSelectBtn.tag == 101) {
        return;
    }
    SearchCountriesVC *vc = [SearchCountriesVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)phoneAndEmailRegisterClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        registerLineView.frame = CGRectMake(35 + (sender.tag - 100)*(SCREEN_WIDTH - 70)/2, 160 - 64 + kNavigationBarHeight + 30, (SCREEN_WIDTH - 70)/2, 1);
    }];
    sender.selected = !sender.selected;
    isSelectBtn.selected = !isSelectBtn.selected;
    isSelectBtn = sender;
    [self PageShowsUI:sender];
}


-(void)PageShowsUI:(UIButton *)sender
{
    if (sender.tag == 100) {
        NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
        CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_phoneAreaCodeBtn setTitle:[NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]] forState:(UIControlStateNormal)];
        [_phoneAreaCodeBtn sizeToFit];
        _phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, _phoneAreaCodeBtn.frame.size.width + 6.5, 15);
        [_phoneAreaCodeBtn setImage:kImage(@"矩形4") forState:(UIControlStateNormal)];
        CGFloat imageW = _phoneAreaCodeBtn.imageView.image.size.width;
        CGFloat titleW = _phoneAreaCodeBtn.titleLabel.frame.size.width;
        CGFloat imageOffset = titleW + 0.5 * 3;
        CGFloat titleOffset = imageW + 0.5 * 3;
        _phoneAreaCodeBtn.imageEdgeInsets = UIEdgeInsetsMake(6.5, imageOffset, 0, - imageOffset);
        _phoneAreaCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
        _phoneTextFid.frame = CGRectMake(_phoneAreaCodeBtn.xx + 15, registerLineView.yy + 50, SCREEN_WIDTH - _phoneAreaCodeBtn.xx - 60, 15);
        _phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的手机号码" key:nil];
        
        email = _phoneTextFid.text;
        _phoneTextFid.text = phone;
    }
    else
    {
        
        [_phoneAreaCodeBtn setTitle:[LangSwitcher switchLang:@"邮箱" key:nil] forState:(UIControlStateNormal)];
        [_phoneAreaCodeBtn sizeToFit];
        
        [_phoneAreaCodeBtn setImage:kImage(@"") forState:(UIControlStateNormal)];
        _phoneAreaCodeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _phoneAreaCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, _phoneAreaCodeBtn.width, 15);
        
        _phoneTextFid.frame = CGRectMake(_phoneAreaCodeBtn.xx + 10, registerLineView.yy + 50, SCREEN_WIDTH - _phoneAreaCodeBtn.xx - 60, 15);
        _phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的邮箱账号" key:nil];
        phone = _phoneTextFid.text;
        _phoneTextFid.text = email;
    }
}

-(void)BtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    switch (sender.tag - 100) {
        case 0:
        {
            
            if ([_phoneTextFid.text isEqualToString:@""]) {
                if (isSelectBtn.tag == 100) {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的手机号" key:nil]];
                }else
                {
                    
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的邮箱账号" key:nil]];
                }
                
                return;
            }
            
            if (isSelectBtn.tag != 100) {
                if ([self isValidateEmail:_phoneTextFid.text] == NO) {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的邮箱账号" key:nil]];
                    return;
                }
            }
            
            if ([_codeTextFid.text isEqualToString:@""]) {
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入密码" key:nil]];
                return;
            }
            
            
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
            CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            http.code = @"805051";
//            http.parameters[@"countryCode"] = model.code;
            if (isSelectBtn.tag == 100) {
                http.parameters[@"loginName"] = [NSString stringWithFormat:@"%@%@",model.interCode,self.phoneTextFid.text];
            }else
            {
                http.parameters[@"loginName"] = self.phoneTextFid.text;
            }
            
            http.parameters[@"loginPwd"] = self.codeTextFid.text;
            http.parameters[@"kind"] = APP_KIND;
            http.parameters[@"client"] = @"ios";
            
            [http postWithSuccess:^(id responseObject) {
                NSLog(@"========== %@",responseObject[@"data"]);
                
                [self requesUserInfoWithResponseObject:responseObject];
                [MobClick profileSignInWithPUID:responseObject[@"data"][@"userId"]];
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case 1:
        {
            RegisterVC *vc = [RegisterVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {

            ForgotPasswordVC *vc = [ForgotPasswordVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//邮箱地址的正则表达式
- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (void)requesUserInfoWithResponseObject:(id)responseObject {
    
    NSString *token = responseObject[@"data"][@"token"];
    NSString *userId = responseObject[@"data"][@"userId"];
    [TLUser user].userId = userId;
    [TLUser user].token = token;
    //保存用户账号和密码
    //    [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
    
    //1.获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
        [TLUser user].userId = userId;
        [TLUser user].token = token;
        
        //保存用户信息
        [[TLUser user] saveUserInfo:userInfo];
        //初始化用户信息
        [[TLUser user] setUserInfoWithDict:userInfo];
        
        TLTabBarController*tab   = [[TLTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
            
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
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
