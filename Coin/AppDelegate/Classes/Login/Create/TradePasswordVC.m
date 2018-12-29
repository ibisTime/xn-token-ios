//
//  TradePasswordVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/16.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TradePasswordVC.h"
#import "ImportWalletVC.h"
#import "CreateWalletVC.h"
#import "WhetherBackupVC.h"
#import "PrivacyPolicyView.h"
@interface TradePasswordVC ()

@property (nonatomic , strong)WSTextField *passWordWSText;
@property (nonatomic , strong)WSTextField *conPassWordWSText;
@property (nonatomic ,strong)PrivacyPolicyView *privacyView;
@end

@implementation TradePasswordVC

-(PrivacyPolicyView *)privacyView
{
    if (!_privacyView) {
        _privacyView = [[PrivacyPolicyView alloc]initWithFrame:CGRectMake(50, SCREEN_HEIGHT, SCREEN_WIDTH - 100, 60 + SCREEN_WIDTH - 160 + 64)];
        _privacyView.backgroundColor = kWhiteColor;
        kViewRadius(_privacyView, 6.5);
        [_privacyView.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
//        [[UserModel user]showPopAnimationWithAnimationStyle:1 showView:self.privacyView];
    }
    return _privacyView;
}


-(void)confirmBtnClick
{
    [[UserModel user].cusPopView dismiss];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"设置交易密码" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    
    [self.view addSubview:self.privacyView];
    
    _privacyView.frame = CGRectMake(50, SCREEN_HEIGHT/2 - (60 + SCREEN_WIDTH - 160 + 64)/2, SCREEN_WIDTH - 100, 60 + SCREEN_WIDTH - 160 + 64);
    [[UserModel user]showPopAnimationWithAnimationStyle:1 showView:self.privacyView];
    
    
    
    [self initView];
}


-(void)initView
{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:passwordView];
    
    NSArray *passWordArray = @[[LangSwitcher switchLang:@"输入交易密码" key:nil],[LangSwitcher switchLang:@"确认交易密码" key:nil]];
    NSArray *placArray = @[[LangSwitcher switchLang:@"请输入交易密码" key:nil],[LangSwitcher switchLang:@"请确认交易密码" key:nil]];
    
    for (int i = 0; i < 2; i ++) {
        UILabel *passWordLbl = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + i % 2 * 108, SCREEN_WIDTH - 70, 16) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
        passWordLbl.text = passWordArray[i];
        [passwordView addSubview:passWordLbl];
        
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, passWordLbl.yy + 31 - 1.5, 10, 15)];
        iconImage.image = kImage(@"安全组拷贝");
        [passwordView addSubview:iconImage];
        
//        UITextField *passWordFid = [[UITextField alloc]initWithFrame:CGRectMake(iconImage.xx + 15, passWordLbl.yy + 21 - 1.5, SCREEN_WIDTH - iconImage.xx - 40 , 15)];
//        passWordFid.placeholder = placArray[i];
//        passWordFid.secureTextEntry = YES;
//        [passWordFid setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
//        passWordFid.font = FONT(14);
//        passWordFid.textColor = [UIColor whiteColor];
//        [passWordFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
//        passWordFid.clearsOnBeginEditing = NO;
//        passWordFid.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [passwordView addSubview:passWordFid];
//
//        if (i == 0) {
//            _passWord = passWordFid;
//        }else
//        {
//            _conPassWord = passWordFid;
//        }
        
        
        WSTextField *passWordFid = [[WSTextField alloc]initWithFrame:CGRectMake(iconImage.xx + 15, passWordLbl.yy + 31 - 1.5 - 10, SCREEN_WIDTH - iconImage.xx - 40 , 35)];
        passWordFid.ly_placeholder = placArray[i];
//        passWordFid.textField.tag = 10000 + i;
//        passWordFid.textField.delegate = self;
        //        [passWordFid.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
        passWordFid.placeholderSelectStateColor = [UIColor whiteColor];
        passWordFid.placeholderNormalStateColor = [UIColor whiteColor];
        [passWordFid.textField setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
        passWordFid.textField.font = FONT(14);
        passWordFid.textField.clearsOnBeginEditing = NO;
        passWordFid.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        passWordFid.textField.secureTextEntry = YES;
        passWordFid.textField.keyboardType = UIKeyboardTypeEmailAddress;
        if (i == 0) {
            _passWordWSText = passWordFid;
        }else
        {
            _conPassWordWSText = passWordFid;
        }
        [passwordView addSubview:passWordFid];
        
        
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5 - 10, SCREEN_WIDTH - 70, 1)];
        lineView.backgroundColor = kLineColor;
        [passwordView addSubview:lineView];
        
        if (i == 0) {
            UILabel *label = [UILabel labelWithFrame:CGRectMake(passWordFid.x, lineView.yy + 5, SCREEN_WIDTH - passWordFid.x, 10) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(10) textColor:kHexColor(@"d6d5d5")];
            label.text = [LangSwitcher switchLang:@"密码为6位以上数字或字母" key:nil];
            [passwordView addSubview:label];
        }
        
        
    }
    
    
    UILabel *note = [UILabel labelWithFrame:CGRectMake(35, _conPassWordWSText.yy + 10, 0, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
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
    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [passwordView addSubview:confirmBtn];
}


-(void)nextBtn
{
    if (![_passWordWSText.textField.text isPhoneNum]) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入交易密码" key:nil]];
        return;
    }
    if (![_conPassWordWSText.textField.text isPhoneNum]) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请确认交易密码" key:nil]];
        return;
    }
    if (![_conPassWordWSText.textField.text isEqualToString:_passWordWSText.textField.text]) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码不一致" key:nil]];
        return;
    }
    if (_passWordWSText.textField.text.length < 6) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码至少为6位以上的数字或字母" key:nil]];
        return;
    }
    
    
    if ([_state isEqualToString:@"1"]) {
        
        NSString *mnemonics = [MnemonicUtil getGenerateMnemonics];
        
        NSArray *words = [mnemonics componentsSeparatedByString:@" "];
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        
        for (unsigned i = 0; i < [words count]; i++){
            
            if ([categoryArray containsObject:[words objectAtIndex:i]] == NO){
                
                [categoryArray addObject:[words objectAtIndex:i]];
                
            }
        }
        
        
//        [[NSUserDefaults standardUserDefaults]setObject:categoryArray forKey:MNEMONIC];
        
        [[NSUserDefaults standardUserDefaults]setObject:mnemonics forKey:MNEMONIC];
        [[NSUserDefaults standardUserDefaults]setObject:_passWordWSText.textField.text forKey:MNEMONICPASSWORD];
        
        WhetherBackupVC *vc = [WhetherBackupVC new];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else
    {
        ImportWalletVC *vc = [ImportWalletVC new];
        vc.passWord = _passWordWSText.textField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
