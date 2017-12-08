//
//  GoogleAuthVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "GoogleAuthVC.h"

#import "TLTextField.h"
#import "TLCaptchaView.h"

@interface GoogleAuthVC ()

//密钥
//@property
//谷歌验证码
//短信验证码
@property (nonatomic,strong) TLCaptchaView *captchaView;

@end

@implementation GoogleAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"谷歌验证设置";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    //密钥
    //谷歌验证码
    //短信验证码
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
