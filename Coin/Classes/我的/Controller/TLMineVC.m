//
//  TLMineVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMineVC.h"

#import "CoinHeader.h"
#import "APICodeMacro.h"
#import <SDWebImage/UIButton+WebCache.h>

#import "MineGroup.h"

#import "MineTableView.h"
#import "MineHeaderView.h"

#import "SettingVC.h"

#import "TLImagePicker.h"
#import "TLUploadManager.h"

@interface TLMineVC ()<MineHeaderSeletedDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//头部
@property (nonatomic, strong) MineHeaderView *headerView;
//
@property (nonatomic, strong) MineGroup *group;
//
@property (nonatomic, strong) MineTableView *tableView;

@property (nonatomic, strong) TLImagePicker *imagePicker;

@end

@implementation TLMineVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //获取用户信息
    [self getUserInfo];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
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
    
    self.headerView = mineHeaderView;
}

- (void)initGroup {
    
    CoinWeakSelf;
    
    //我的广告
    MineModel *advertisement = [MineModel new];
    
    advertisement.text = @"我的广告";
    advertisement.imgName = @"我的广告";
    advertisement.action = ^{
        
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
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.mineGroup = self.group;
    
    self.tableView.tableHeaderView = self.headerView;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.tableView];
}

- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        
        CoinWeakSelf;
        
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        
        _imagePicker.allowsEditing = YES;
        _imagePicker.pickFinish = ^(NSDictionary *info){
            
            UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
            NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
            
            //进行上传
            TLUploadManager *manager = [TLUploadManager manager];
            
            manager.imgData = imgData;
            
            manager.image = image;
            
            [manager getTokenShowView:weakSelf.view succes:^(NSString *key) {
                
                [weakSelf changeHeadIconWithKey:key imgData:imgData];
                
            } failure:^(NSError *error) {
                
            }];
        };
    }
    
    return _imagePicker;
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];

}

#pragma mark - Events
- (void)loginOut {
    
    [[TLUser user] loginOut];
    
}

- (void)changeHeadIcon {
    
    [self.imagePicker picker];
}

#pragma mark - Data
- (void)getUserInfo {
    
    if ([TLUser user].photo) {
        
        [self.headerView.photoBtn setTitle:@"" forState:UIControlStateNormal];
        
        [self.headerView.photoBtn sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] forState:UIControlStateNormal];
        
    } else {
        
        NSString *nickName = [TLUser user].nickname;
        
        NSString *title = [nickName substringToIndex:1];
        
        [self.headerView.photoBtn setTitle:title forState:UIControlStateNormal];
        
    }
    
}

- (void)changeHeadIconWithKey:(NSString *)key imgData:(NSData *)imgData {
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.code = USER_CHANGE_USER_PHOTO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"photo"] = key;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {

        [TLAlert alertWithSucces:@"修改头像成功"];
        
        [TLUser user].photo = key;
        
        [self getUserInfo];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - MineHeaderSeletedDelegate

- (void)didSelectedWithType:(MineHeaderSeletedType)type {
    
    switch (type) {
            
        case MineHeaderSeletedTypePhoto:
        {
            [self changeHeadIcon];
            
        }break;
            
        case MineHeaderSeletedTypeBuy:
        {
            [TLAlert alertWithInfo:@"正在研发中, 敬请期待"];
            
        }break;
            
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
