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

#import "SettingGroup.h"
#import "SettingModel.h"

#import "SettingTableView.h"
#import "SettingCell.h"

#import "AppMacro.h"
#import "APICodeMacro.h"

#import "TLAlert.h"
#import "NSString+Check.h"

@interface SettingVC ()

@property (nonatomic, strong) SettingGroup *group;

@property (nonatomic, strong) UIButton *loginOutBtn;

@property (nonatomic, strong) SettingTableView *tableView;

@end

@implementation SettingVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    [self requestUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        
        [self.navigationController pushViewController:pwdAboutVC animated:YES];
        
    }];
    
    
    //身份认证
    SettingModel *idAuth = [SettingModel new];
    
    idAuth.text = [LangSwitcher switchLang:@"芝麻认证" key:nil];
    [idAuth setAction:^{
        
//        IdAuthVC *idAuthVC = [IdAuthVC new];
//
//        [weakSelf.navigationController pushViewController:idAuthVC animated:YES];
        
        ZMAuthVC *authVC = [ZMAuthVC new];
        
        authVC.title = [LangSwitcher switchLang:@"芝麻认证" key:nil];

        [weakSelf.navigationController pushViewController:authVC animated:YES];
        
    }];
    
    //绑定邮箱
    SettingModel *bindEmail = [SettingModel new];
    
    bindEmail.text = [LangSwitcher switchLang:@"绑定邮箱" key:nil];
    [bindEmail setAction:^{
        
        EditVC *editVC = [[EditVC alloc] init];
        editVC.title = [LangSwitcher switchLang:@"绑定邮箱" key:nil];
        editVC.text = [TLUser user].email;
        editVC.type = UserEditTypeEmail;
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
    SettingModel *changeMobile = [SettingModel new];
    changeMobile.text = [LangSwitcher switchLang:@"修改手机号" key:nil];
    [changeMobile setAction:^{
        
        TLChangeMobileVC *changeMobileVC = [[TLChangeMobileVC alloc] init];
        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
        
    }];
    
    //修改登录密码
    SettingModel *changeLoginPwd = [SettingModel new];
    changeLoginPwd.text = [LangSwitcher switchLang:@"修改登录密码" key:nil];
    [changeLoginPwd setAction:^{
        
        TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeReset];
        [self.navigationController pushViewController:pwdAboutVC animated:YES];
        
    }];

    //谷歌验证
    SettingModel *google = [SettingModel new];
    google.text = [LangSwitcher switchLang:@"谷歌验证" key:nil];
    [google setAction:^{
        
        //未开启直接进入开启界面，已开启就弹出操作表
        if ([TLUser user].isGoogleAuthOpen) {
            
            [weakSelf setGoogleAuth];

        } else {
            
            GoogleAuthVC *authVC = [GoogleAuthVC new];
            
            [weakSelf.navigationController pushViewController:authVC animated:YES];
        }
    }];
    
    self.group = [SettingGroup new];
    
    self.group.sections = @[@[changeTradePwd], @[idAuth, bindEmail, changeMobile, changeLoginPwd, google]];
    
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
    
    TLTabBarController *tabbarVC = (TLTabBarController *)self.tabBarController;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        tabbarVC.selectedIndex = 2;
        
        [self.navigationController popViewControllerAnimated:NO];

    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
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

- (void)reloadUserInfo {
    
    //认证状态
    if ([TLUser user].realName) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        
        SettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.rightLabel.text = [LangSwitcher switchLang:@"已认证" key:nil];
        
        [self.tableView reloadData];
    }
    //邮箱
    if ([TLUser user].email) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        
        SettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.rightLabel.text = [TLUser user].email;
        
        [self.tableView reloadData];
    }
    //手机号
    if ([TLUser user].mobile) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        SettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.rightLabel.text = [TLUser user].mobile;
        
        [self.tableView reloadData];
    }
    
    if ([TLUser user].googleAuthFlag) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:1];
        
        SettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.rightLabel.text = [TLUser user].isGoogleAuthOpen ? [LangSwitcher switchLang:@"已开启" key:nil]: [LangSwitcher switchLang:@"未开启" key:nil];
        
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
