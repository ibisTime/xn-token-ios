//
//  SettingVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SettingVC.h"

#import "IdAuthVC.h"
#import "TLChangeMobileVC.h"
#import "TLPwdRelatedVC.h"
#import "TLUserForgetPwdVC.h"
#import "HTMLStrVC.h"
#import "TLTabBarController.h"

#import "SettingGroup.h"
#import "SettingModel.h"

#import "SettingTableView.h"
#import "SettingCell.h"

#import "AppMacro.h"
#import "APICodeMacro.h"

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
    
    self.title = @"安全设置";
    
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
    
    changeTradePwd.text = @"资金密码";
    
    [changeTradePwd setAction:^{
        
        TLPwdType pwdType = [[TLUser user].tradepwdFlag isEqualToString:@"0"] ? TLPwdTypeSetTrade: TLPwdTypeTradeReset;
        
        TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        
        [self.navigationController pushViewController:pwdAboutVC animated:YES];
        
    }];
    
    
    //身份认证
    SettingModel *idAuth = [SettingModel new];
    
    idAuth.text = @"身份认证";
    [idAuth setAction:^{
        
        IdAuthVC *idAuthVC = [IdAuthVC new];
        
        [weakSelf.navigationController pushViewController:idAuthVC animated:YES];
        
    }];
    
    //绑定邮箱
    SettingModel *bindEmail = [SettingModel new];
    
    bindEmail.text = @"绑定邮箱";
    [bindEmail setAction:^{
        
        [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

    }];
    
    //修改手机号
    SettingModel *changeMobile = [SettingModel new];
    changeMobile.text = @"修改手机号";
    [changeMobile setAction:^{
        
        TLChangeMobileVC *changeMobileVC = [[TLChangeMobileVC alloc] init];
        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
        
    }];
    
    //修改登录密码
    SettingModel *changeLoginPwd = [SettingModel new];
    changeLoginPwd.text = @"修改登录密码";
    [changeLoginPwd setAction:^{
        
        TLPwdRelatedVC *pwdAboutVC = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeReset];
        [self.navigationController pushViewController:pwdAboutVC animated:YES];
        
    }];

    //谷歌验证
    SettingModel *google = [SettingModel new];
    google.text = @"谷歌验证";
    [google setAction:^{
        
        
    }];
//
//    SettingModel *aboutUs = [SettingModel new];
//    aboutUs.text = @"关于我们";
//    [aboutUs setAction:^{
//
//        HTMLStrVC *htmlVC = [HTMLStrVC new];
//
//        htmlVC.type = HTMLTypeAboutUs;
//
//        [self.navigationController pushViewController:htmlVC animated:YES];
//    }];
    
    self.group = [SettingGroup new];
    
    self.group.sections = @[@[changeTradePwd], @[idAuth, bindEmail, changeMobile, changeLoginPwd, google]];
    
}

#pragma mark- 退出登录

- (UIButton *)loginOutBtn {
    
    if (!_loginOutBtn) {
        
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 55, kScreenWidth - 30, 45)];
        _loginOutBtn.backgroundColor = kAppCustomMainColor;
        [_loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
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
        
        tabbarVC.selectedIndex = 0;
        
        [self.navigationController popViewControllerAnimated:NO];

    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
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
        
        if ([TLUser user].realName) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            SettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            cell.rightLabel.text = @"已认证";
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
