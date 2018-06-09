//
//  WalletSettingVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletSettingVC.h"
#import "RevisePassWordVC.h"
#import "SettingGroup.h"
#import "SettingTableView.h"
#import "EditEmailVC.h"
@interface WalletSettingVC ()
@property (nonatomic, strong) SettingGroup *group;
@property (nonatomic, strong) SettingTableView *tableView;
@end

@implementation WalletSettingVC

- (void)viewDidLoad {
    self.title = [LangSwitcher switchLang:@"钱包设置" key:nil];
    [self setGroup];
    [self initTableView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Init

- (void)initTableView {
    
    self.tableView = [[SettingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStyleGrouped];
    
    self.tableView.group = self.group;
    
    [self.view addSubview:self.tableView];
 
    
}

- (void)setGroup {
    
    CoinWeakSelf;
    
    //资金密码
    SettingModel *changeTradePwd = [SettingModel new];
    changeTradePwd.text = [LangSwitcher switchLang:@"修改密码" key:nil];
    [changeTradePwd setAction:^{
        
        
        RevisePassWordVC *pwdAboutVC = [[RevisePassWordVC alloc] init];
        pwdAboutVC.Type = PassWprdTypeFirst;
        [weakSelf.navigationController pushViewController:pwdAboutVC animated:YES];
        
    }];
    
    
    //实名认证
    SettingModel *idAuth = [SettingModel new];
    idAuth.text = [LangSwitcher switchLang:@"钱包备份" key:nil];
    [idAuth setAction:^{
        
        EditEmailVC *authVC = [EditEmailVC new];
        authVC.title = [LangSwitcher switchLang:@"钱包备份" key:nil];
        
        [weakSelf.navigationController pushViewController:authVC animated:YES];
        
    }];
    
    //绑定邮箱
    SettingModel *bindEmail = [SettingModel new];
    bindEmail.text = [LangSwitcher switchLang:@"导出私钥" key:nil];
    [bindEmail setAction:^{
        
        EditEmailVC *editVC = [[EditEmailVC alloc] init];
        [editVC setDone:^(NSString *content){
            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
//            SettingCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
//
//            cell.rightLabel.text = [[TLUser user].email valid] ? [TLUser user].email: [LangSwitcher switchLang:@"" key:nil];
//
//            [weakSelf.tableView reloadData];
            
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
    changeLoginPwd.text = [LangSwitcher switchLang:@"删除钱包" key:nil];
    [changeLoginPwd setAction:^{
        
        EditEmailVC *changeLoginPwdVC = [EditEmailVC new];
        
//        changeLoginPwdVC.success = ^{
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//
//            });
//        };
        
        [weakSelf.navigationController pushViewController:changeLoginPwdVC animated:YES];
        
    }];
    
  
    
    self.group = [SettingGroup new];
    self.group.sections = @[@[changeTradePwd], @[idAuth, bindEmail, changeLoginPwd]];
    
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
