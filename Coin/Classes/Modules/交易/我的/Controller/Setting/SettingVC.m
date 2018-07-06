//
//  SettingVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SettingVC.h"

#import "IdAuthVC.h"
#import "ZMAuthVC.h"
#import "TLChangeMobileVC.h"
#import "TLPwdRelatedVC.h"
#import "TLUserForgetPwdVC.h"
#import "HTMLStrVC.h"
#import "TLTabBarController.h"
#import "EditVC.h"
#import "GoogleAuthVC.h"
#import "CloseGoogleAuthVC.h"
#import "ChangeLoginPwdVC.h"
#import "SettingGroup.h"
#import "SettingModel.h"
#import "SettingTableView.h"
#import "SettingCell.h"
#import "AppMacro.h"
#import "APICodeMacro.h"
#import "EditEmailVC.h"
#import "TLAlert.h"
#import "NSString+Check.h"
#import "TLProgressHUD.h"
#import "LangChooseVC.h"
#import "TLUserLoginVC.h"
@interface SettingVC ()

@property (nonatomic, strong) SettingGroup *group;
@property (nonatomic, strong) UIButton *loginOutBtn;
@property (nonatomic, strong) SettingTableView *tableView;

//
@property (nonatomic, strong) SettingModel *realNameSettingModel;
@property (nonatomic, strong) SettingModel *emailSettingModel;
@property (nonatomic, strong) SettingModel *googleAuthSettingModel;

@end

@implementation SettingVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self requestUserInfo];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LangSwitcher switchLang:@"安全设置" key:nil];
    [self setGroup];
    [self initTableView];
    
}

#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[SettingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStyleGrouped];
    
    self.tableView.group = self.group;
    
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    [footerView addSubview:self.loginOutBtn];
    
    self.tableView.tableFooterView = footerView;
    
    
}

- (void)setGroup {
    
    CoinWeakSelf;
    
    //资金密码
    SettingModel *changeTradePwd = [SettingModel new];
    changeTradePwd.text = [LangSwitcher switchLang:@"资金密码" key:nil];
    [changeTradePwd setAction:^{
        
        TLPwdType pwdType = [[TLUser user].tradepwdFlag isEqualToString:@"0"] ? TLPwdTypeSetTrade: TLPwdTypeTradeReset;
        
        TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        
        [weakSelf.navigationController pushViewController:pwdAboutVC animated:YES];
        
    }];
    
    
    //实名认证
    SettingModel *idAuth = [SettingModel new];
    idAuth.text = [LangSwitcher switchLang:@"实名认证" key:nil];
    self.realNameSettingModel = idAuth;
    [idAuth setAction:^{
        
        ZMAuthVC *authVC = [ZMAuthVC new];
        authVC.title = [LangSwitcher switchLang:@"实名认证" key:nil];
        authVC.success = ^{
            
            [TLAlert alertWithSucces:[LangSwitcher switchLang:@"实名认证成功" key:nil]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        };
        
        [weakSelf.navigationController pushViewController:authVC animated:YES];
        
    }];
    
    //绑定邮箱
    SettingModel *bindEmail = [SettingModel new];
    bindEmail.text = [LangSwitcher switchLang:@"绑定邮箱" key:nil];
    self.emailSettingModel = bindEmail;
    [bindEmail setAction:^{
        
        EditEmailVC *editVC = [[EditEmailVC alloc] init];
        [editVC setDone:^(NSString *content){
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
            SettingCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            
            cell.rightLabel.text = [[TLUser user].email valid] ? [TLUser user].email: [LangSwitcher switchLang:@"" key:nil];
            
            [weakSelf.tableView reloadData];
            
        }];
        //
        [weakSelf.navigationController pushViewController:editVC animated:YES];
    }];
    
    //修改手机号
//    SettingModel *changeMobile = [SettingModel new];
//    changeMobile.text = [LangSwitcher switchLang:@"手机号" key:nil];
//    changeMobile.subText = [TLUser user].mobile;
//    [changeMobile setAction:^{
//
//        TLChangeMobileVC *changeMobileVC = [[TLChangeMobileVC alloc] init];
//        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
//
//    }];
    
    //修改登录密码
    SettingModel *changeLoginPwd = [SettingModel new];
    changeLoginPwd.text = [LangSwitcher switchLang:@"修改登录密码" key:nil];
    [changeLoginPwd setAction:^{
        
        ChangeLoginPwdVC *changeLoginPwdVC = [ChangeLoginPwdVC new];
        
        changeLoginPwdVC.success = ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            });
        };
        
        [weakSelf.navigationController pushViewController:changeLoginPwdVC animated:YES];
        
    }];
    
    //谷歌验证
    SettingModel *google = [SettingModel new];
    google.text = [LangSwitcher switchLang:@"谷歌验证" key:nil];
    self.googleAuthSettingModel = google;
    [google setAction:^{
        
        //未开启直接进入开启界面，已开启就弹出操作表
        if ([TLUser user].isGoogleAuthOpen) {
            
            [weakSelf setGoogleAuth];
            
        } else {
            
            GoogleAuthVC *authVC = [GoogleAuthVC new];
            [weakSelf.navigationController pushViewController:authVC animated:YES];
        }
    }];
    
    
    //语言设置
    SettingModel *languageSetting = [SettingModel new];
    languageSetting.text = [LangSwitcher switchLang:@"语言设置" key:nil];
    languageSetting.subText = [LangSwitcher currentLang];
    [languageSetting setAction:^{
        
        LangChooseVC *vc = [[LangChooseVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    self.group = [SettingGroup new];
    self.group.sections = @[@[changeTradePwd], @[ bindEmail, changeLoginPwd, google]];
    
}

#pragma mark- 退出登录

- (UIButton *)loginOutBtn {
    
    if (!_loginOutBtn) {
        
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 55, kScreenWidth - 30, 45)];
        _loginOutBtn.backgroundColor = kAppCustomMainColor;
        [_loginOutBtn setTitle:[LangSwitcher switchLang:@"退出登录" key:nil] forState:UIControlStateNormal];
        [_loginOutBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _loginOutBtn.layer.cornerRadius = 5;
        _loginOutBtn.clipsToBounds = YES;
        _loginOutBtn.titleLabel.font = FONT(15);
        [_loginOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutBtn;
    
}

- (void)logout {
    
    //先退出腾讯云，才算退出成功
    //im 退出
//    [TLProgressHUD showWithStatus:nil];
//    [[IMAPlatform sharedInstance] logout:^{
//        [TLProgressHUD dismiss];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
//
//        TLTabBarController *tabbarVC = (TLTabBarController *)self.tabBarController;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            tabbarVC.selectedIndex = 2;
//            [self.navigationController popViewControllerAnimated:NO];
//
//        });
//        //
//    } fail:^(int code, NSString *msg) {
//
//        [TLAlert alertWithInfo:@"退出登录失败"];
//
//    }];
    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"退出登录" key:nil] msg:[LangSwitcher switchLang:@"退出登录?" key:nil] confirmMsg:[LangSwitcher switchLang:@"确定" key:nil] cancleMsg:[LangSwitcher switchLang:@"取消" key:nil] maker:self cancle:^(UIAlertAction *action) {
        
        
    } confirm:^(UIAlertAction *action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
                TLUserLoginVC *loginVC= [TLUserLoginVC new];
                [self.navigationController pushViewController:loginVC animated:YES];
          
//            tabbarVC.selectedIndex = 0;
//            [self.navigationController popViewControllerAnimated:NO];
//            [self popoverPresentationController];
            
            
            
        });
    }];
   
}

- (void)setGoogleAuth {
    //
    NSString *title = [LangSwitcher switchLang:@"修改谷歌验证" key:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[LangSwitcher switchLang:@"谷歌验证" key:nil] message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *changeAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GoogleAuthVC *authVC = [GoogleAuthVC new];
        
        [self.navigationController pushViewController:authVC animated:YES];
    }];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:[LangSwitcher switchLang:@"关闭谷歌验证" key:nil] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CloseGoogleAuthVC *closeVC = [CloseGoogleAuthVC new];
        
        [self.navigationController pushViewController:closeVC animated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[LangSwitcher switchLang:@"取消" key:nil] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertController addAction:changeAction];
    [alertController addAction:closeAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

#pragma mark - Init
- (void)requestUserInfo {
    
    //获取用户信息
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_INFO;
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
        //保存信息
        [[TLUser user] saveUserInfo:userInfo];
        [[TLUser user] setUserInfoWithDict:userInfo];
        
        [self reloadUserInfo];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark- 更新设置状态
- (void)reloadUserInfo {
    
    if ([TLUser user].realName && [TLUser user].realName.length) {
        //认证状态
        self.realNameSettingModel.subText = [LangSwitcher switchLang:@"已认证" key:nil];
        
    }
    
    //邮箱
    if ([TLUser user].email) {
        
        self.emailSettingModel.subText = [TLUser user].email;
        
    }
    
    //
    self.googleAuthSettingModel.subText = [TLUser user].isGoogleAuthOpen ? [LangSwitcher switchLang:@"已开启" key:nil]: [LangSwitcher switchLang:@"未开启" key:nil];

    // 只保留数据刷新
    [self.tableView reloadData];
    
}


@end
