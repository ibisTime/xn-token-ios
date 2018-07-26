//
//  ZLGestureLockViewController.m
//  GestureLockDemo
//
//  Created by ZL on 2017/4/5.
//  Copyright © 2017年 ZL. All rights reserved.
//

#import "ZLGestureLockViewController.h"
#import "ZLGestureLockView.h"
#import "ZLGestureLockIndicator.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TLTabBarController.h"
#import "TLUserLoginVC.h"
@interface ZLGestureLockViewController () <ZLGestureLockDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) ZLGestureLockView *gestureLockView;
@property (strong, nonatomic) ZLGestureLockIndicator *gestureLockIndicator;

// 手势状态栏提示label
@property (weak, nonatomic) UILabel *statusLabel;

// 账户名
@property (weak, nonatomic) UILabel *nameLabel;
// 账户头像
@property (weak, nonatomic) UIImageView *headIcon;

// 其他账户登录按钮
@property (weak, nonatomic) UILabel *otherAcountBtn;
// 重新绘制按钮
@property (weak, nonatomic) UIButton *resetPswBtn;
// 忘记手势密码按钮
@property (weak, nonatomic) UILabel *forgetPswBtn;

// 创建的手势密码
@property (nonatomic, copy) NSString *lastGesturePsw;

@property (nonatomic) ZLUnlockType unlockType;

@end

@implementation ZLGestureLockViewController

#pragma mark - 类方法

+ (void)deleteGesturesPassword {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addGesturesPassword:(NSString *)gesturesPassword {
   
    
    [[NSUserDefaults standardUserDefaults] setObject:gesturesPassword forKey:GesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)gesturesPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:GesturesPassword];
}

#pragma mark - inint

- (instancetype)initWithUnlockType:(ZLUnlockType)unlockType {
    if (self = [super init]) {
        _unlockType = unlockType;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"手势密码" key:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupMainUI];
    
    self.gestureLockView.delegate = self;
    
    self.resetPswBtn.hidden = YES;
    switch (_unlockType) {
        case ZLUnlockTypeCreatePsw:
        {
            self.gestureLockIndicator.hidden = NO;
            self.otherAcountBtn.hidden = self.forgetPswBtn.hidden = self.nameLabel.hidden = self.headIcon.hidden = YES;
        }
            break;
        case ZLUnlockTypeValidatePsw:
        {
            self.gestureLockIndicator.hidden = YES;
            self.otherAcountBtn.hidden = self.forgetPswBtn.hidden = self.nameLabel.hidden = self.headIcon.hidden = NO;
            
        }
            break;
        default:
            break;
    }
    
}

// 创建界面
- (void)setupMainUI {
    
    CGFloat maginX = 15;
    CGFloat magin = 5;
    CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - maginX * 2 - magin * 2) / 3;
    CGFloat btnH = 30;
    
//     账户头像
    UIImageView *headIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 56) * 0.5, 30, 70, 70)];
    NSString *s = [[TLUser user].photo convertImageUrl];
    NSURL *url = [NSURL URLWithString:s];
     [headIcon sd_setImageWithURL:url placeholderImage:kImage(@"头像")];
    [self.view addSubview:headIcon];
    if (self.isCheck == YES) {
        headIcon.hidden = NO;
        self.title = [LangSwitcher switchLang:@"欢迎回来" key:nil];
    }else{
        
        headIcon.hidden = YES;

    }
//     账户名
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.view addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:20];
    self.statusLabel = nameLabel;
    if (self.isCheck == YES) {
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headIcon.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left).offset(30);
            make.right.equalTo(self.view.mas_right).offset(-30);
            make.height.equalTo(@22);
        }];
    }else{
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(30);
            make.left.equalTo(self.view.mas_left).offset(30);
            make.right.equalTo(self.view.mas_right).offset(-30);
            make.height.equalTo(@22);
        }];
        
    }
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    if (self.isCheck == YES) {
        nameLabel.text = [TLUser user].nickname;

    }else{
        
        nameLabel.text = [LangSwitcher switchLang:@"请设置您的新手势密码" key:nil];

    }
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = kTextColor;
   
    
    // 九宫格指示器 小图
    CGFloat f = self.isCheck == YES ? 120 : 60;
    ZLGestureLockIndicator *gestureLockIndicator = [[ZLGestureLockIndicator alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 60) * 0.5, f +10, 60, 60)];
    self.gestureLockIndicator = gestureLockIndicator;
    if (self.isCheck == YES) {
        
    }else{
        
        [self.view addSubview:gestureLockIndicator];

    }
//    gestureLockIndicator.hidden = self.isCheck;
    // 手势状态栏提示label
    CGFloat f3 = self.isCheck == YES ? 130 : gestureLockIndicator.yy +10;

    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200) * 0.5, f3 +10, 200, 30)];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    
    statusLabel.text = self.isCheck == YES ? @"请输入手势密码" :@"绘制手势密码";
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.textColor = kTextColor2;
    [self.view addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    // 九宫格 手势密码页面
    
    CGFloat f2 = self.isCheck == YES ? kHeight(150) : statusLabel.yy;

    ZLGestureLockView *gestureLockView = [[ZLGestureLockView alloc]initWithFrame:CGRectMake(0, f2, self.view.frame.size.width, self.view.frame.size.width)];
    gestureLockView.delegate = self;
    
    [self.view addSubview:gestureLockView];
    self.gestureLockView = gestureLockView;
    
    // 底部三个按钮
    // 其他账户登录按钮
    UILabel *otherAcountBtn = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
//    otherAcountBtn.frame = CGRectMake(50, kHeight(600), 86, 17);
    otherAcountBtn.text = [LangSwitcher switchLang:@"账号密码登录" key:nil];
//    [otherAcountBtn addTarget:self action:@selector(otherAccountLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherAcountBtn];
    self.otherAcountBtn = otherAcountBtn;
    [otherAcountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.top.equalTo(self.gestureLockView.mas_bottom).offset(50);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    // 重新绘制按钮
//     UILabel *resetPswBtn = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
//
//    resetPswBtn.text = [LangSwitcher switchLang:@"重新hui'z" key:nil];
//    [resetPswBtn addTarget:self action:@selector(resetGesturePassword:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:resetPswBtn];
//    self.resetPswBtn = resetPswBtn;
    
    // 忘记手势密码按钮
     UILabel *forgetPswBtn = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
//    UIButton *forgetPswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    forgetPswBtn.frame = CGRectMake(kScreenWidth - 50 - 100, kHeight(600), 80, 17);

//    forgetPswBtn.backgroundColor = kClearColor;
    forgetPswBtn.text = @"忘记密码";
//    [LangSwitcher switchLang:@"忘记密码" key:nil];
//
//    [forgetPswBtn addTarget:self action:@selector(forgetGesturesPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPswBtn];
    self.forgetPswBtn = forgetPswBtn;
    
    [forgetPswBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-50);
        make.top.equalTo(self.gestureLockView.mas_bottom).offset(50);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    UILabel *lab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    lab.text = [LangSwitcher switchLang:@"切换登录" key:nil];
    lab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherAccountLogin:)];
    lab.textAlignment = NSTextAlignmentRight;
    if (self.isCheck == YES) {
        [self.view addSubview:lab];
        [lab addGestureRecognizer:tap1];

    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(self.gestureLockView.mas_bottom).offset(50);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
   }
    
    UILabel *lab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    lab2.text =[LangSwitcher switchLang:@"忘记手势密码?" key:nil];
    lab2.userInteractionEnabled = YES;

    lab2.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetGesturesPassword:)];
    if (self.isCheck == YES) {
        [self.view addSubview:lab2];
        [lab2 addGestureRecognizer:tap];

        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.equalTo(self.gestureLockView.mas_bottom).offset(50);
            make.width.equalTo(@100);
            make.height.equalTo(@40);
        }];
    }
   
}

#pragma mark - private

//  创建手势密码
- (void)createGesturesPassword:(NSMutableString *)gesturesPassword {
    
    if (self.lastGesturePsw.length == 0) {
        
        if (gesturesPassword.length < 4) {
            self.statusLabel.text = @"至少连接四个点，请重新输入";
            [self.gestureLockView showErrowMessage];
            [self shakeAnimationForView:self.statusLabel];
            return;
        }
        
        if (self.resetPswBtn.hidden == YES) {
            self.resetPswBtn.hidden = NO;
        }
        
       NSString *pwd = [ZLGestureLockViewController gesturesPassword];
        if (pwd.length > 0) {
            if ([gesturesPassword isEqualToString:pwd]) {
                //验证成功
                self.statusLabel.text = @"密码正确";
                [self.gestureLockView clearAll];
                [TLAlert alertWithSucces:@"验证通过"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
                     [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;
                    return ;
                });

            }else{
                
                self.statusLabel.text = @"密码错误，请重新输入";
                [self.gestureLockView showErrowMessage];
                
                [self shakeAnimationForView:self.statusLabel];
                return ;

            }
        }
        [self.gestureLockView clearAll];
        self.lastGesturePsw = gesturesPassword;
        [self.gestureLockIndicator setGesturePassword:gesturesPassword];
        
        self.statusLabel.text = @"请再次绘制手势密码";
        return;
    }
    
    if ([self.lastGesturePsw isEqualToString:gesturesPassword]) { // 绘制成功
        
            // 保存手势密码
            [ZLGestureLockViewController addGesturesPassword:gesturesPassword];
            [self.gestureLockView clearAll];

            
            [TLAlert alertWithSucces:@"手势密码设置成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];

        });
      
        
    }else {
        self.statusLabel.text = @"手势不同，请重新绘制";
        [self.gestureLockView showErrowMessage];

        [self shakeAnimationForView:self.statusLabel];
    }
    
    
}

// 验证手势密码
- (void)validateGesturesPassword:(NSMutableString *)gesturesPassword {
    
    static NSInteger errorCount = 5;
    
    if ([gesturesPassword isEqualToString:[ZLGestureLockViewController gesturesPassword]]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            errorCount = 5;
        }];
    } else {
        
        if (errorCount - 1 == 0) { // 你已经输错五次了！ 退出重新登陆！
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手势密码已失效" message:@"请重新登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新登陆", nil];
            [alertView show];
            errorCount = 5;
            return;
        }
        
        self.statusLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次",--errorCount];
        [self shakeAnimationForView:self.statusLabel];
    }
}

// 抖动动画
- (void)shakeAnimationForView:(UIView *)view {
    
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - 按钮点击事件 Anction

// 点击其他账号登陆按钮
- (void)otherAccountLogin:(id)sender {
    NSLog(@"%s",__FUNCTION__);
     [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([TLUser user].isLogin == NO) {
            TLUserLoginVC *lg = [TLUserLoginVC new];
            TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:lg];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = na;
        }
      
    });
   
//    ZLGestureLockViewController *zl =  [ZLGestureLockViewController new];
}

// 点击重新绘制按钮
- (void)resetGesturePassword:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    
    self.lastGesturePsw = nil;
    self.statusLabel.text = @"请绘制手势密码";
    self.resetPswBtn.hidden = YES;
    [self.gestureLockIndicator setGesturePassword:@""];
}

// 点击忘记手势密码按钮
- (void)forgetGesturesPassword:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    ZLGestureLockViewController *zl =  [ZLGestureLockViewController new];

     TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:zl];
    [UIApplication sharedApplication].keyWindow.rootViewController = na;
}


#pragma mark - ZLgestureLockViewDelegate

- (void)gestureLockView:(ZLGestureLockView *)lockView drawRectFinished:(NSMutableString *)gesturePassword {
    
    switch (_unlockType) {
        case ZLUnlockTypeCreatePsw: // 创建手势密码
        {
            [self createGesturesPassword:gesturePassword];
        }
            break;
        case ZLUnlockTypeValidatePsw: // 校验手势密码
        {
            [self validateGesturesPassword:gesturePassword];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 重新登陆
    NSLog(@"重新登陆");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
