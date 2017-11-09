//
//  TLMineVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMineVC.h"

#import "CoinHeader.h"

#import "MineGroup.h"

#import "MineTableView.h"
#import "MineHeaderView.h"

#import "SettingVC.h"

@interface TLMineVC ()<MineHeaderSeletedDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//头部
@property (nonatomic, strong) MineHeaderView *headerView;
//
@property (nonatomic, strong) MineGroup *group;
//
@property (nonatomic, strong) MineTableView *tableView;

@end

@implementation TLMineVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //获取用户信息
    [self getUserInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //修改状态栏颜色
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if ([version compare:@"9.0"] != NSOrderedAscending) {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    } else {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    //顶部视图
    [self initMineHeaderView];
    //模型
    [self initGroup];
    //
    [self initTableView];
    //通知
    [self addNotification];
}

#pragma mark - Init

- (void)initMineHeaderView {
    
    MineHeaderView *mineHeaderView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160 + kStatusBarHeight + 55)];
    
    mineHeaderView.delegate = self;
    
//    [self.scrollView addSubview:mineHeaderView];
    
    self.headerView = mineHeaderView;
}

- (void)initGroup {
    
    CoinWeakSelf;
    
    //我的广告
    MineModel *advertisement = [MineModel new];
    
    advertisement.text = @"我的广告";
    advertisement.imgName = @"我的广告";
    advertisement.action = ^{
        
        self.tabBarController.selectedIndex = 1;

        [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

    };
    
    //我的地址
    MineModel *address = [MineModel new];
    
    address.text = @"我的地址";
    address.imgName = @"我的地址";
    address.action = ^{
        
        [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

    };
    
    //受信任的
    MineModel *trust = [MineModel new];
    
    trust.text = @"受信任的";
    trust.imgName = @"受信任的";
    trust.action = ^{
        
        [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

    };
    
    //邀请好友
    MineModel *inviteFriend = [MineModel new];
    
    inviteFriend.text = @"邀请好友";
    inviteFriend.imgName = @"邀请";
    inviteFriend.action = ^{
        
        [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

    };
    
    //安全中心
    MineModel *securityCenter = [MineModel new];
    
    securityCenter.text = @"安全中心";
    securityCenter.imgName = @"安全中心";
    securityCenter.action = ^{
        
        SettingVC *settingVC = [SettingVC new];
        
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    };
    
    //提醒设置
    MineModel *remindSetting = [MineModel new];
    
    remindSetting.text = @"提醒设置";
    remindSetting.imgName = @"提醒设置";
    remindSetting.action = ^{
      
        [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

    };
    
    //常见问题
    MineModel *problem = [MineModel new];
    
    problem.text = @"常见问题";
    problem.imgName = @"常见问题";
    problem.action = ^{
        
        [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

    };
    
    //联系客服
    MineModel *linkService = [MineModel new];
    
    linkService.text = @"联系客服";
    linkService.imgName = @"联系客服";
    linkService.action = ^{
        
        [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

    };
    
    self.group = [MineGroup new];

    self.group.sections = @[@[advertisement, address, trust, inviteFriend], @[securityCenter, remindSetting, problem, linkService]];
    
}

- (void)initTableView {
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStyleGrouped];
    
    self.tableView.mineGroup = self.group;
    
    self.tableView.tableHeaderView = self.headerView;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.tableView];
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];

}

#pragma mark - Events
- (void)loginOut {
    
    [[TLUser user] loginOut];
    
}

#pragma mark - Data
- (void)getUserInfo {
    
}

#pragma mark - MineHeaderSeletedDelegate

- (void)didSelectedWithType:(MineHeaderSeletedType)type {
    
    switch (type) {
        case MineHeaderSeletedTypeBuy:
        {
            [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];
        }
            break;
            
        case MineHeaderSeletedTypeSell:
        {
            [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];

        }break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
