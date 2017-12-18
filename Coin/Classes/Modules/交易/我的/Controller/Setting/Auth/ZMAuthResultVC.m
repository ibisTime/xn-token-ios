//
//  ZMAuthResultVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ZMAuthResultVC.h"

#import "TLTextField.h"
#import "UIBarButtonItem+convience.h"

@interface ZMAuthResultVC ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) TLTextField *realNameTF;    //真实姓名

@property (nonatomic, strong) TLTextField *idCardTF;      //身份证

@end

@implementation ZMAuthResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [UIBarButtonItem addLeftItemWithImageName:@"返回" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(back)];

    [self initSubviews];

}

#pragma mark - Init
- (void)initSubviews {
    
    self.view.backgroundColor = kWhiteColor;
    
    CGFloat imageW = kWidth(60);
    
    NSString *result = self.result ? @"认证成功": @"认证失败";
    
//    NSString *resultStr = self.result ? @"认证成功": @"认证失败";

    UIImageView *resultIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kWidth(35), imageW, imageW)];
    
    resultIV.image = [UIImage imageNamed:result];
    
    resultIV.layer.cornerRadius = imageW/2.0;
    
    resultIV.clipsToBounds = YES;
    
    resultIV.centerX = self.view.centerX;
    
    [self.view addSubview:resultIV];
    
    UILabel *promptLabel = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    promptLabel.frame = CGRectMake(0, resultIV.yy + kWidth(20), kScreenWidth, 16);
    
    promptLabel.backgroundColor = kClearColor;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:promptLabel];
    
    NSString *failResult = self.failureReason ? self.failureReason: @"认证失败";
    
    promptLabel.text = self.result ? result: failResult;
    
    self.realNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, promptLabel.yy + kWidth(35), kScreenWidth, 50) leftTitle:@"姓名" titleWidth:105 placeholder:@""];
    
    self.realNameTF.text = self.realName;
    
    self.realNameTF.returnKeyType = UIReturnKeyNext;
    
    self.realNameTF.enabled = NO;
    
    [self.view addSubview:self.realNameTF];
    
    self.idCardTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.realNameTF.yy, kScreenWidth, 50) leftTitle:@"身份证号码" titleWidth:105 placeholder:@""];
    
    self.idCardTF.text = self.idCard;
    
    self.idCardTF.enabled = NO;
    
    [self.view addSubview:self.idCardTF];
    
//    self.realNameTF.hidden = self.result ? NO: YES;
//    
//    self.idCardTF.hidden = self.result ? NO: YES;
    
}

#pragma mark - Events

- (void)back {
    
    if (self.result) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
