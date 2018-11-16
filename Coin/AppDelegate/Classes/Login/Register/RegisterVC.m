//
//  RegisterVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/12.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "RegisterVC.h"
#import "SearchCountriesVC.h"
#import "CompleteTheRegistrationVC.h"
@interface RegisterVC ()<UIScrollViewDelegate>
{
    UIButton *isSelectBtn;
    UIView *registerLineView;
    NSInteger w;
}

@property (nonatomic , strong)UIScrollView *scrollView;


@end

@implementation RegisterVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}

//如果仅设置当前页导航透明，需加入下面方法
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self navigationSetDefault];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}


-(void)initView
{
    
    
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"注册Theia个人账户" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    
    
    for (int i = 0; i < 3; i ++) {
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(12 + i % 3 * (SCREEN_WIDTH - 24)/3, SCREEN_HEIGHT - kNavigationBarHeight - 45 - 7.5, (SCREEN_WIDTH - 30)/3, 7.5)];
        bottomView.backgroundColor = kWhiteColor;
        [self.view addSubview:bottomView];
        bottomView.tag = 123 + i;
        if (i == 0) {
            bottomView.backgroundColor = kHexColor(@"68c5ca");
        }
    }
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT + kStatusBarHeight)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    [self registrationWayUI];
    [self setThePassword];
    [self moneyPasswordUI];
    
}


#pragma mark -- 搜索
-(void)phoneAreaCodeBtnClick
{
    SearchCountriesVC *vc = [SearchCountriesVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 选择注册方式
-(void)phoneAndEmailRegisterClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        registerLineView.frame = CGRectMake(35 + (sender.tag - 100)*(SCREEN_WIDTH - 70)/2, 160 - 64 + kNavigationBarHeight + 30, (SCREEN_WIDTH - 70)/2, 1);
    }];
    sender.selected = !sender.selected;
    isSelectBtn.selected = !isSelectBtn.selected;
    isSelectBtn = sender;
}

#pragma mark -- 完成注册
-(void)completeTheRegistration
{
    CompleteTheRegistrationVC *vc = [CompleteTheRegistrationVC new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *lineView1 = [self.view viewWithTag:123];
    UIView *lineView2 = [self.view viewWithTag:124];
    UIView *lineView3 = [self.view viewWithTag:125];
    
    w = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    if (w == 0) {
        lineView1.backgroundColor = kHexColor(@"68c5ca");
        lineView2.backgroundColor = kWhiteColor;
        lineView3.backgroundColor = kWhiteColor;
    }
    if (w == 1) {
        lineView1.backgroundColor = kHexColor(@"68c5ca");
        lineView2.backgroundColor = kHexColor(@"68c5ca");
        lineView3.backgroundColor = kWhiteColor;
    }
    if (w == 2) {
        lineView1.backgroundColor = kHexColor(@"68c5ca");
        lineView2.backgroundColor = kHexColor(@"68c5ca");
        lineView3.backgroundColor = kHexColor(@"68c5ca");
    }
    
    NSLog(@"%.2f",scrollView.contentOffset.x);
    NSLog(@"%ld",w);
    
}

#pragma mark -- 下一步
-(void)nextBtn
{
    w ++;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * w, 0) animated:YES];
}


-(void)registrationWayUI
{
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *array = @[[LangSwitcher switchLang:@"手机注册" key:nil],[LangSwitcher switchLang:@"邮箱注册" key:nil]];
    
    for (int i = 0; i < 2; i ++) {
        UIButton *phoneAndEmailRegister = [UIButton buttonWithTitle:array[i] titleColor:kHexColor(@"d6d5d5") backgroundColor:kClearColor titleFont:16];
        [phoneAndEmailRegister setTitleColor:kWhiteColor forState:(UIControlStateSelected)];
        phoneAndEmailRegister.frame = CGRectMake(35 + i %2*((SCREEN_WIDTH - 70)/2), 160 - 64 + kNavigationBarHeight, (SCREEN_WIDTH - 70)/2, 16);
        if (i == 0) {
            phoneAndEmailRegister.selected = YES;
            isSelectBtn = phoneAndEmailRegister;
            
            registerLineView = [[UIView alloc]initWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + 30, (SCREEN_WIDTH - 70)/2, 1)];
            registerLineView.backgroundColor = kWhiteColor;
            [self.scrollView addSubview:registerLineView];
        }
        phoneAndEmailRegister.titleLabel.font = HGboldfont(16);
        [phoneAndEmailRegister addTarget:self action:@selector(phoneAndEmailRegisterClick:) forControlEvents:(UIControlEventTouchUpInside)];
        phoneAndEmailRegister.tag = 100 + i;
        [self.scrollView addSubview:phoneAndEmailRegister];
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
    
    [self.scrollView addSubview:phoneAreaCodeBtn];
    
    UITextField *phoneTextFid = [[UITextField alloc]initWithFrame:CGRectMake(phoneAreaCodeBtn.xx + 15, registerLineView.yy + 50, SCREEN_WIDTH - phoneAreaCodeBtn.xx - 60, 15)];
    phoneTextFid.placeholder = [LangSwitcher switchLang:@"请输入您的手机号码" key:nil];
    //    phoneTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [phoneTextFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
    phoneTextFid.font = FONT(12);
    phoneTextFid.textColor = [UIColor whiteColor];
    [phoneTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    phoneTextFid.clearsOnBeginEditing = NO;
    phoneTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:phoneTextFid];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, phoneTextFid.yy + 13, SCREEN_WIDTH - 70, 1)];
    lineView.backgroundColor = kWhiteColor;
    [self.scrollView addSubview:lineView];
    
    UILabel *codeLabel = [UILabel labelWithFrame:CGRectMake(46, lineView.yy + 29, 0, 15) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(14) textColor:kWhiteColor];
    codeLabel.text = [LangSwitcher switchLang:@"验证码" key:nil];
    [codeLabel sizeToFit];
    if (codeLabel.width >= 100) {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, 100, 15);
    }else
    {
        codeLabel.frame = CGRectMake(46, lineView.yy + 29, codeLabel.width, 15);
    }
    
    [self.scrollView addSubview:codeLabel];
    
    UIButton *codeBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"获取验证码" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    [codeBtn sizeToFit];
    codeBtn.frame = CGRectMake(SCREEN_WIDTH - 35 - codeBtn.width - 26, lineView.yy + 16, codeBtn.width + 26, 31);
    [codeBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
    [self.scrollView addSubview:codeBtn];
    
    UITextField *codeTextFid = [[UITextField alloc]initWithFrame:CGRectMake(codeLabel.xx + 15, lineView.yy + 29, SCREEN_WIDTH - codeLabel.xx - 15 - codeBtn.width - 45, 15)];
    codeTextFid.placeholder = [LangSwitcher switchLang:@"请输入验证码" key:nil];
    //    codeTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [codeTextFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
    codeTextFid.font = FONT(12);
    codeTextFid.textColor = [UIColor whiteColor];
    [codeTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    codeTextFid.clearsOnBeginEditing = NO;
    codeTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:codeTextFid];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(35, codeLabel.yy + 13, SCREEN_WIDTH - 70, 1)];
    lineView1.backgroundColor = kWhiteColor;
    [self.scrollView addSubview:lineView1];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, lineView1.yy + 100, 50, 50);
    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollView addSubview:confirmBtn];
}


-(void)setThePassword
{
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:passwordView];
    
    NSArray *passWordArray = @[[LangSwitcher switchLang:@"输入登录密码" key:nil],[LangSwitcher switchLang:@"确认登录密码" key:nil]];
    NSArray *placArray = @[[LangSwitcher switchLang:@"请输入账号登录密码" key:nil],[LangSwitcher switchLang:@"请确认账号登录密码" key:nil]];
    
    for (int i = 0; i < 2; i ++) {
        UILabel *passWordLbl = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + i % 2 * 108, SCREEN_WIDTH - 70, 16) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
        passWordLbl.text = passWordArray[i];
        [passwordView addSubview:passWordLbl];
        
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, passWordLbl.yy + 21 - 1.5, 10, 15)];
        iconImage.image = kImage(@"安全组拷贝");
        [passwordView addSubview:iconImage];
        
        UITextField *passWordFid = [[UITextField alloc]initWithFrame:CGRectMake(iconImage.xx + 15, passWordLbl.yy + 21 - 1.5, SCREEN_WIDTH - iconImage.xx - 40 , 15)];
        passWordFid.placeholder = placArray[i];
        passWordFid.secureTextEntry = YES;
        [passWordFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
        passWordFid.font = FONT(12);
        passWordFid.textColor = [UIColor whiteColor];
        [passWordFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
        passWordFid.clearsOnBeginEditing = NO;
        passWordFid.clearButtonMode = UITextFieldViewModeWhileEditing;
        [passwordView addSubview:passWordFid];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5, SCREEN_WIDTH - 70, 1)];
        lineView.backgroundColor = kLineColor;
        [passwordView addSubview:lineView];
        
    }
    
    NSArray *securityArray = @[[LangSwitcher switchLang:@"密码位数为8~25个字符(字符+字母)" key:nil],[LangSwitcher switchLang:@"密码中包含小写字母" key:nil],[LangSwitcher switchLang:@"密码中包含大写字母" key:nil],[LangSwitcher switchLang:@"密码中包含数字" key:nil]];
    for (int i = 0; i < 4; i ++) {
        UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + 108 * 2 - 30 +i%4 * 20, 8, 8)];
        pointView.backgroundColor = kWhiteColor;
        kViewRadius(pointView, 4);
        [passwordView addSubview:pointView];
        
        UILabel *securityLbl = [UILabel labelWithFrame:CGRectMake(49, 160 - 64 + kNavigationBarHeight + 108 * 2 - 30 +i%4 * 20 - 2, SCREEN_WIDTH - 49 - 35, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
        securityLbl.text = securityArray[i];
        securityLbl.tag = 200 + i;
        [passwordView addSubview:securityLbl];
    }
    
    
    UILabel *label = [self.view viewWithTag:203];
    UILabel *levelStateLbl = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH - 35, label.y - 4, 0, 18) textAligment:(NSTextAlignmentRight) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    NSString *level = [LangSwitcher switchLang:@"安全级别" key:nil];
    NSString *State = [LangSwitcher switchLang:@"高" key:nil];
    NSString *str = [NSString stringWithFormat:@"%@ %@",level,State];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]      initWithString:str];
    [attrStr addAttribute:NSFontAttributeName value:HGboldfont(18) range:NSMakeRange(str.length - State.length,State.length)];
//    [attrStr addAttribute:NSFontAttributeNamevalue:HGboldfont(18) range:NSMakeRange(0,3)];
    //字体大小为20.0f[attrStr addAttribute:NSFontAttributeNamevalue:  [UIFont boldSystemFontOfSize:20.0f] range:NSMakeRange(0,3)];//字体大小为20.0f并且加粗
    levelStateLbl.attributedText = attrStr;
    [levelStateLbl sizeToFit];
    levelStateLbl.frame = CGRectMake(SCREEN_WIDTH - 35 - levelStateLbl.width, label.y - 6, levelStateLbl.width, 18);
    [passwordView addSubview:levelStateLbl];
    
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, levelStateLbl.yy + 20, 50, 50);
    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [passwordView addSubview:confirmBtn];
}


-(void)moneyPasswordUI
{
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:passwordView];
    
    NSArray *passWordArray = @[[LangSwitcher switchLang:@"输入资金密码" key:nil],[LangSwitcher switchLang:@"确认资金密码" key:nil]];
    NSArray *placArray = @[[LangSwitcher switchLang:@"请输入账号资金密码" key:nil],[LangSwitcher switchLang:@"请确认账号资金密码" key:nil]];
    
    
    UIView *bottomView;
    for (int i = 0; i < 2; i ++) {
        UILabel *passWordLbl = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + i % 2 * 108, SCREEN_WIDTH - 70, 16) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
        passWordLbl.text = passWordArray[i];
        [passwordView addSubview:passWordLbl];
        
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, passWordLbl.yy + 21 - 1.5, 10, 15)];
        iconImage.image = kImage(@"安全组拷贝");
        [passwordView addSubview:iconImage];
        
        UITextField *passWordFid = [[UITextField alloc]initWithFrame:CGRectMake(iconImage.xx + 15, passWordLbl.yy + 21 - 1.5, SCREEN_WIDTH - iconImage.xx - 40 , 15)];
        passWordFid.placeholder = placArray[i];
        passWordFid.secureTextEntry = YES;
        [passWordFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
        passWordFid.font = FONT(12);
        passWordFid.textColor = [UIColor whiteColor];
        [passWordFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
        passWordFid.clearsOnBeginEditing = NO;
        passWordFid.clearButtonMode = UITextFieldViewModeWhileEditing;
        [passwordView addSubview:passWordFid];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5, SCREEN_WIDTH - 70, 1)];
        lineView.backgroundColor = kLineColor;
        [passwordView addSubview:lineView];
        if (i == 1) {
            bottomView =lineView;
        }
    }
    
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"完成注册" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:18];
    confirmBtn.frame = CGRectMake(50, bottomView.yy + 75, SCREEN_WIDTH - 100, 50);
    kViewRadius(confirmBtn, 10);
    [confirmBtn setBackgroundImage:kImage(@"矩形5-1") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(completeTheRegistration) forControlEvents:(UIControlEventTouchUpInside)];
    [passwordView addSubview:confirmBtn];
    
    
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
