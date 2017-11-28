//
//  EditVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "EditVC.h"

#import "CoinHeader.h"

#import "TLTextField.h"

#import "NSString+Check.h"
#import "UIBarButtonItem+convience.h"

@interface EditVC ()

@property (nonatomic, strong) TLTextField *contentTf;

@end

@implementation EditVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.contentTf becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.contentTf resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [UIBarButtonItem addRightItemWithTitle:@"完成" titleColor:kTextColor frame:CGRectMake(0, 0, 40, 20) vc:self action:@selector(hasDone)];
    
    if (self.type == UserEditTypeEmail) {
        
        self.contentTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45) leftTitle:@"邮箱" titleWidth:80 placeholder:@"请输入您的邮箱"];
        
        self.contentTf.text = [self.text valid] ? self.text: @"";
        
        self.contentTf.keyboardType = UIKeyboardTypeEmailAddress;
        [self.view addSubview:self.contentTf];
        
    } else {
        
        self.contentTf = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 45) leftTitle:@"昵称" titleWidth:80 placeholder:@"请填写昵称"];
        
        self.contentTf.text = [self.text valid] ? self.text: @"";

        [self.view addSubview:self.contentTf];
    }
    
}

- (void)hasDone {
    
    if (self.type == UserEditTypeEmail) {
        
        if (![self.contentTf.text valid]) {
            
            [TLAlert alertWithInfo:@"请输入邮箱"];
            return;
        }
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"805081";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"email"] = self.contentTf.text;
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"绑定成功"];
            [TLUser user].nickname = self.contentTf.text;
            
            [[TLUser user] updateUserInfo];
            
            if (self.done) {
                self.done(self.contentTf.text);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        if (![self.contentTf.text valid]) {
            [TLAlert alertWithInfo:@"请输入昵称"];
            return;
        }
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"805075";
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;
        http.parameters[@"nickname"] = self.contentTf.text;
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"修改成功"];
            [TLUser user].nickname = self.contentTf.text;
            
            [[TLUser user] updateUserInfo];
            
            if (self.done) {
                self.done(self.contentTf.text);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    
    
}


@end
