//
//  TLChangeNikeName.m
//  Coin
//
//  Created by shaojianfei on 2018/7/28.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLChangeNikeName.h"
#import "TLTextField.h"
#import "NSString+Extension.h"
#import "NSString+Check.h"

@interface TLChangeNikeName ()<UITextFieldDelegate>
@property (nonatomic, strong) TLTextField *contentTf;

@property (nonatomic, strong) UIButton *importButton;

@end

@implementation TLChangeNikeName

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"修改昵称" key:nil];
    self.contentTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45) leftTitle:[LangSwitcher switchLang:@"昵称" key:nil] titleWidth:80 placeholder:[LangSwitcher switchLang:@"请填写昵称" key:nil]];
    self.contentTf.delegate = self;
    self.contentTf.text = [self.text valid] ? self.text: @"";
    
    [self.view addSubview:self.contentTf];
    
    self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text2 = [LangSwitcher switchLang:@"确认修改" key:nil];
    [self.importButton setTitle:text2 forState:UIControlStateNormal];
    self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.importButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.importButton addTarget:self action:@selector(importNow) forControlEvents:UIControlEventTouchUpInside];
    [self.importButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    self.importButton.layer.borderColor = (kAppCustomMainColor.CGColor);
    self.importButton.layer.borderWidth = 1;
    self.importButton.clipsToBounds = YES;
    [self.view addSubview:self.importButton];
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTf.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@50);
        
    }];
    // Do any additional setup after loading the view.
}

- (void)importNow
{
    
    if ([self.contentTf.text isEqualToString:@""] || !self.contentTf.text) {
        [TLAlert alertWithMsg:@"请输入昵称"];
        return;
    }
    
//    if (![self.contentTf.text valid]) {
//        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入昵称" key:nil]];
//        return;
//    }
    if (self.contentTf.text.length > 11) {
        [TLAlert alertWithMsg:@"昵称最多为11个字"];
        return ;
    }
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805075";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"nickname"] = self.contentTf.text;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"修改成功" key:nil]];
        [TLUser user].nickname = self.contentTf.text;
        
        [[TLUser user] updateUserInfo];
        
       
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_//|~＜＞$€^£•'@#$%^&*():;.,?!<>\\_+'/\""];
    NSString *str = [tem stringByTrimmingCharactersInSet:set];
    if (![string isEqualToString:str]) {
        return NO;
        
    }
    if ([self isContainsTwoEmoji:string]) {
        return NO;
    }
    return YES;
    
}

- (BOOL)isContainsTwoEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         //         NSLog(@"hs++++++++%04x",hs);
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     isEomji = YES;
                 }
                 //                 NSLog(@"uc++++++++%04x",uc);
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3|| ls ==0xfe0f) {
                 isEomji = YES;
             } //             NSLog(@"ls++++++++%04x",ls);
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
         
     }];
    return isEomji;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
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
