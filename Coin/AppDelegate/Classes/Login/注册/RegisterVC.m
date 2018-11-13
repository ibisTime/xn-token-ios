//
//  RegisterVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/12.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()<UIScrollViewDelegate>
{
    UIButton *isSelectBtn;
    UIView *registerLineView;
}


@end

@implementation RegisterVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self navigationSetDefault];
}

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
    nameLable.text = [LangSwitcher switchLang:@"新用户注册" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    
    
    for (int i = 0; i < 3; i ++) {
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(12 + i % 3 * (SCREEN_WIDTH - 24)/3, SCREEN_HEIGHT - kNavigationBarHeight - 45 - 7.5, (SCREEN_WIDTH - 30)/3, 7.5)];
        bottomView.backgroundColor = kWhiteColor;
        [self.view addSubview:bottomView];
    }
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT + kStatusBarHeight)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    
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
            [scrollView addSubview:registerLineView];
        }
        phoneAndEmailRegister.titleLabel.font = HGboldfont(16);
        [phoneAndEmailRegister addTarget:self action:@selector(phoneAndEmailRegisterClick:) forControlEvents:(UIControlEventTouchUpInside)];
        phoneAndEmailRegister.tag = 100 + i;
        [scrollView addSubview:phoneAndEmailRegister];
    }
    
    UIButton *phoneAreaCodeBtn = [UIButton buttonWithTitle:@"+86" titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, 0, 15);
    phoneAreaCodeBtn.titleLabel.font = HGboldfont(14);
    [phoneAreaCodeBtn sizeToFit];
    phoneAreaCodeBtn.frame = CGRectMake(46, registerLineView.yy + 50, phoneAreaCodeBtn.frame.size.width, 15);
    [scrollView addSubview:phoneAreaCodeBtn];
    
    UITextField *phoneTextFid = [[UITextField alloc]initWithFrame:CGRectMake(phoneAreaCodeBtn.xx + 25, registerLineView.yy + 50, SCREEN_WIDTH - phoneAreaCodeBtn.xx - 75, 15)];
    phoneTextFid.placeholder = @"请输入您的手机号码";
    phoneTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [phoneTextFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
    phoneTextFid.font = FONT(12);
    phoneTextFid.textColor = [UIColor whiteColor];
    [phoneTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    phoneTextFid.clearsOnBeginEditing = NO;
    phoneTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:phoneTextFid];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, phoneTextFid.yy + 13, SCREEN_WIDTH - 70, 1.5)];
    lineView.backgroundColor = kWhiteColor;
    [scrollView addSubview:lineView];
    
    UILabel *codeLabel = [UILabel labelWithFrame:CGRectMake(46, lineView.yy + 29, 0, 15) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(14) textColor:kWhiteColor];
    codeLabel.text = [LangSwitcher switchLang:@"验证码" key:nil];
    [codeLabel sizeToFit];
    codeLabel.frame = CGRectMake(46, lineView.yy + 29, codeLabel.width, 15);
    [scrollView addSubview:codeLabel];
    
    UIButton *codeBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"获取验证码" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:14];
    [codeBtn sizeToFit];
    codeBtn.frame = CGRectMake(SCREEN_WIDTH - 35 - codeBtn.width - 26, lineView.yy + 16, codeBtn.width + 26, 31);
    [codeBtn setBackgroundImage:kImage(@"圆角矩形2拷贝2") forState:(UIControlStateNormal)];
    [scrollView addSubview:codeBtn];
    
    UITextField *codeTextFid = [[UITextField alloc]initWithFrame:CGRectMake(codeLabel.xx + 16, lineView.yy + 29, SCREEN_WIDTH - codeLabel.xx - 16 - codeBtn.width - 50, 15)];
    codeTextFid.placeholder = @"请输入验证码";
    codeTextFid.keyboardType = UIKeyboardTypeEmailAddress;
    [codeTextFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
    codeTextFid.font = FONT(12);
    codeTextFid.textColor = [UIColor whiteColor];
    [codeTextFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
    codeTextFid.clearsOnBeginEditing = NO;
    codeTextFid.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:codeTextFid];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(35, codeLabel.yy + 13, SCREEN_WIDTH - 70, 1.5)];
    lineView1.backgroundColor = kWhiteColor;
    [scrollView addSubview:lineView1];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, lineView1.yy + 100 - kNavigationBarHeight, 50, 50);
    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
    [self.view addSubview:confirmBtn];
    
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
