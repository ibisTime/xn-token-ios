//
//  ChangeLocalMoneyVC.m
//  Coin
//
//  Created by shaojianfei on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "ChangeLocalMoneyVC.h"
#import "LangChooseVC.h"
#import "SettingModel.h"
#import <CDCommon/UIScrollView+TLAdd.h>
#import "TLTabBarController.h"
@interface ChangeLocalMoneyVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *langChooseTV;
@property (nonatomic, strong) NSMutableArray <SettingModel *>*models;
@property (nonatomic, copy)  NSString *type;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;
@end

@implementation ChangeLocalMoneyVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLable = [[UILabel alloc]init];
    self.nameLable.text = [LangSwitcher switchLang:@"本地货币" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(16);
    self.nameLable.textColor = kTextBlack;
    self.navigationItem.titleView = self.nameLable;
//    self.title = ;
    self.models = [[NSMutableArray alloc] init];
    
    self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgImage.contentMode = UIViewContentModeScaleToFill;
    self.bgImage.userInteractionEnabled = YES;
    self.bgImage.image = kImage(@"我的 背景");
    [self.view  addSubview:self.bgImage];
    
//    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    //
//    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    self.backButton.frame = CGRectMake(15, kStatusBarHeight + 30, 40, 40);
//    [self.backButton setImage:kImage(@"返回1-1") forState:(UIControlStateNormal)];
//    [self.backButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.bgImage addSubview:self.backButton];
//    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, kStatusBarHeight+5, kScreenWidth - 108, 44)];
//    self.nameLable.text = [LangSwitcher switchLang:@"选择货币" key:nil];
//    self.nameLable.textAlignment = NSTextAlignmentCenter;
//    self.nameLable.font = Font(16);
//    self.nameLable.textColor = kTextBlack;
//    [self.bgImage addSubview:self.nameLable];

    self.langChooseTV = [[UITableView alloc] initWithFrame:CGRectMake(15, kNavigationBarHeight + 30, kScreenWidth-15, kHeight(175)) style:UITableViewStylePlain];
    self.langChooseTV.rowHeight = 55;
    [self.bgImage addSubview:self.langChooseTV];
    self.langChooseTV.delegate = self;
    self.langChooseTV.dataSource = self;
    self.langChooseTV.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.langChooseTV adjustsContentInsets];
    __weak typeof(self) weakself = self;
    //
//    TLDataBase *db = [TLDataBase sharedManager];
//
//    if ([db.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT MoneyType FROM THAWallet WHERE userId = '%@'",[TLUser user].userId];
//       FMResultSet *set =   [db.dataBase executeQuery:sql];
//        while ([set next]) {
//
//            self.type = [set stringForColumn:@"MoneyType"];
//        }
//
//    }
//
//    [db.dataBase close];
//    [[NSUserDefaults standardUserDefaults] setObject:self.type forKey:KLocalMoney];
   self.type =   [[NSUserDefaults standardUserDefaults] objectForKey:KLocalMoney];
    SettingModel *simpleModel = [[SettingModel alloc] init];
    //    simpleModel.text = [LangSwitcher switchLang:@"简体中文" key:nil];
    simpleModel.text = @"CNY";
    
    simpleModel.isSelect = [simpleModel.text isEqualToString:self.type];
    if (!self.type) {
        simpleModel.isSelect = YES;
    }
    [simpleModel setAction:^{
        
        [weakself langType:LangTypeSimple];
    }];
    //
    SettingModel *tridationModel = [[SettingModel alloc] init];
    //    tridationModel.text = [LangSwitcher switchLang:@"繁体中文" key:nil];
    tridationModel.text = @"USD";
    
    tridationModel.isSelect = [tridationModel.text isEqualToString:self.type];
    [tridationModel setAction:^{
        
        [weakself langType:LangTypeEnglish];
        
    }];
    
    SettingModel *tridationModel1 = [[SettingModel alloc] init];
    //    tridationModel.text = [LangSwitcher switchLang:@"繁体中文" key:nil];
    tridationModel1.text = @"KRW";
    
    tridationModel1.isSelect = [tridationModel1.text isEqualToString:self.type];
    [tridationModel1 setAction:^{
        
        [weakself langType:LangTypeKorean];
        
    }];
    
    [self.models addObjectsFromArray:@[simpleModel,tridationModel,tridationModel1]];

}
- (void)buttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)langType:(LangType)type {
    
    NSString *money ;
    if (type == LangTypeSimple) {
        money = @"CNY";
    }else if (type == LangTypeKorean)
    {
        
        money = @"KRW";

    }
    else{
        
        money = @"USD";
    }
    
    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"切换货币" key:nil]
                        msg:nil
                 confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                     cancle:^(UIAlertAction *action) {
                         
                     } confirm:^(UIAlertAction *action) {
                         
//                         TLDataBase *db = [TLDataBase sharedManager];
//
//                         if ([db.dataBase open]) {
//                              NSString *sql = [NSString stringWithFormat:@"UPDATE THAWallet SET MoneyType = '%@' WHERE userId = '%@'",money,[TLUser user].userId];
//                           BOOL sucess =   [db.dataBase executeUpdate:sql];
//
//                             NSLog(@"保存本地货币选择%d",sucess);
//                             if (sucess == 1) {
//                                 [TLUser user].localMoney = money;
//                             }
//                         }
//                         [db.dataBase close];
                         [TLUser user].localMoney = money;
                         [[NSUserDefaults standardUserDefaults] setObject:money forKey:KLocalMoney];

//                         [LangSwitcher changLangType:type];
                         //                             UIView *v = nil;
                         TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
                         [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;
//                         [LangSwitcher startWithTraditional];
                         //                             [v sizeToFit];
                         
                         
                         //                             NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                         //                             dict[nil] = @"";
                     }];
    
}

//- (void)viewDidLayoutSubviews {
//    self.langChooseTV.frame = self.view.bounds;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.models[indexPath.row].action) {
        
        self.models[indexPath.row].action();
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.7);
            make.left.bottom.right.equalTo(cell);
        }];
        
        
        
    }
    
    // 判断出当前类型
    
    SettingModel *settingModel = self.models[indexPath.row];
    cell.textLabel.text = settingModel.text;
    
    if (settingModel.isSelect) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 11)];
        iv.contentMode = UIViewContentModeScaleToFill;
        //        iv.backgroundColor = [UIColor orangeColor];
        [cell addSubview:iv];
        iv.image = [UIImage imageNamed:@"打勾"];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-20);
            make.height.width.mas_equalTo(20);
        }];
        
    }else{
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        //        iv.backgroundColor = [UIColor orangeColor];
        [cell addSubview:iv];
        iv.image = [UIImage imageNamed:@""];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-20);
            make.height.width.mas_equalTo(20);
        }];
        
    }
    
    
    return cell;
    
}



@end
