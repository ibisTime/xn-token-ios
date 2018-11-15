//
//  LoginVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/15.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "LoginVC.h"
#import "SearchCountriesVC.h"
@interface LoginVC ()
{
    UIButton *isSelectBtn;
    UIView *registerLineView;
}
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
    nameLable.text = [LangSwitcher switchLang:@"新用户注册" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    

    NSArray *array = @[[LangSwitcher switchLang:@"手机注册" key:nil],[LangSwitcher switchLang:@"邮箱注册" key:nil]];
    for (int i = 0; i < 2; i ++) {
        UIButton *phoneAndEmailRegister = [UIButton buttonWithTitle:array[i] titleColor:kHexColor(@"d6d5d5") backgroundColor:kClearColor titleFont:16];
        [phoneAndEmailRegister setTitleColor:kWhiteColor forState:(UIControlStateSelected)];
        phoneAndEmailRegister.frame = CGRectMake(35 + i %2*((SCREEN_WIDTH - 70)/2), 160 - 64 + kNavigationBarHeight, (SCREEN_WIDTH - 70)/2, 16);
        if (i == 0) {
            phoneAndEmailRegister.selected = YES;
            isSelectBtn = phoneAndEmailRegister;
            
            registerLineView = [[UIView alloc]initWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + 30, (SCREEN_WIDTH - 70)/2, 1.5)];
            registerLineView.backgroundColor = kWhiteColor;
            [backView addSubview:registerLineView];
        }
        phoneAndEmailRegister.titleLabel.font = HGboldfont(16);
        [phoneAndEmailRegister addTarget:self action:@selector(phoneAndEmailRegisterClick:) forControlEvents:(UIControlEventTouchUpInside)];
        phoneAndEmailRegister.tag = 100 + i;
        [backView addSubview:phoneAndEmailRegister];
    }
    
    UIButton *phoneAreaCodeBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    
    phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, 0, 15);
    phoneAreaCodeBtn.titleLabel.font = HGboldfont(14);
    
    
    
    
    [phoneAreaCodeBtn sizeToFit];
    phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, phoneAreaCodeBtn.frame.size.width + 6.5, 15);
    [phoneAreaCodeBtn setImage:kImage(@"矩形4") forState:(UIControlStateNormal)];
    
    CGFloat imageW = phoneAreaCodeBtn.imageView.image.size.width;
    CGFloat titleW = phoneAreaCodeBtn.titleLabel.frame.size.width;
    CGFloat imageOffset = titleW + 0.5 * 3;
    CGFloat titleOffset = imageW + 0.5 * 3;
    
    phoneAreaCodeBtn.imageEdgeInsets = UIEdgeInsetsMake(6.5, imageOffset, 0, - imageOffset);
    phoneAreaCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
    
    [phoneAreaCodeBtn addTarget:self action:@selector(phoneAreaCodeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [backView addSubview:phoneAreaCodeBtn];
    
    UITextField *phoneTextFid = [[UITextField alloc]initWithFrame:CGRectMake(phoneAreaCodeBtn.xx + 15, registerLineView.yy + 50, SCREEN_WIDTH - phoneAreaCodeBtn.xx - 60, 15)];
    phoneTextFid.placeholder = @"请输入您的手机号码";
    //    phoneTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [phoneTextFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
    phoneTextFid.font = FONT(12);
    phoneTextFid.textColor = [UIColor whiteColor];
    [phoneTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    phoneTextFid.clearsOnBeginEditing = NO;
    phoneTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:phoneTextFid];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, phoneTextFid.yy + 13, SCREEN_WIDTH - 70, 1.5)];
    lineView.backgroundColor = kWhiteColor;
    [backView addSubview:lineView];
    
    UILabel *codeLabel = [UILabel labelWithFrame:CGRectMake(46, lineView.yy + 29, 0, 15) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(14) textColor:kWhiteColor];
    codeLabel.text = [LangSwitcher switchLang:@"验证码" key:nil];
    [codeLabel sizeToFit];
    if (codeLabel.width >= 100) {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, 100, 15);
    }else
    {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, codeLabel.width, 15);
    }
    
    [backView addSubview:codeLabel];
    
    UIButton *codeBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"获取验证码" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    [codeBtn sizeToFit];
    codeBtn.frame = CGRectMake(SCREEN_WIDTH - 35 - codeBtn.width - 26, lineView.yy + 16, codeBtn.width + 26, 31);
    [codeBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
    [backView addSubview:codeBtn];
    
    UITextField *codeTextFid = [[UITextField alloc]initWithFrame:CGRectMake(codeLabel.xx + 15, lineView.yy + 29, SCREEN_WIDTH - codeLabel.xx - 15 - codeBtn.width - 45, 15)];
    codeTextFid.placeholder = @"请输入验证码";
    //    codeTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [codeTextFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
    codeTextFid.font = FONT(12);
    codeTextFid.textColor = [UIColor whiteColor];
    [codeTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    codeTextFid.clearsOnBeginEditing = NO;
    codeTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:codeTextFid];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(35, codeLabel.yy + 13, SCREEN_WIDTH - 70, 1.5)];
    lineView1.backgroundColor = kWhiteColor;
    [backView addSubview:lineView1];
//
//    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
//    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, lineView1.yy + 100 - kNavigationBarHeight, 50, 50);
//    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
//    [self.view addSubview:confirmBtn];
    
}

-(void)phoneAreaCodeBtnClick
{
    SearchCountriesVC *vc = [SearchCountriesVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)phoneAndEmailRegisterClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        registerLineView.frame = CGRectMake(35 + (sender.tag - 100)*(SCREEN_WIDTH - 70)/2, 160 - 64 + kNavigationBarHeight + 30, (SCREEN_WIDTH - 70)/2, 1.5);
    }];
    sender.selected = !sender.selected;
    isSelectBtn.selected = !isSelectBtn.selected;
    isSelectBtn = sender;
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
