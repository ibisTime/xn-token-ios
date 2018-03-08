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
#import "PublishService.h"
#import "MineGroup.h"
#import "AdvertiseModel.h"

#import "MineTableView.h"
#import "MineHeaderView.h"
#import "TLAboutUsVC.h"
#import "SettingVC.h"
#import "PersonalitySettingVC.h"
#import "HTMLStrVC.h"
#import "MyAdvertiseVC.h"
#import "FansVC.h"
#import "CoinAddressListVC.h"
#import "InviteFriendVC.h"
#import "UserStatistics.h"
#import "TLImagePicker.h"
#import "TLUploadManager.h"
#import "AppConfig.h"
#import <ZendeskSDK/ZendeskSDK.h>
#import <ZDCChat/ZDCChat.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <CDCommon/UIScrollView+TLAdd.h>
#import "CoinService.h"
#import "LangChooseVC.h"

@interface TLMineVC ()<MineHeaderSeletedDelegate, UINavigationControllerDelegate>

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//- (void)viewDidAppear:(BOOL)animated {
//    
//    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//
//}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    //解决聊天
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];

    //
//    if ([[TLUser user] checkLogin]) {
//        [self requestUserStatistInfo];
//    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    if ([viewController isKindOfClass:[ZDCChatViewController class]]) {
        
        [[IQKeyboardManager sharedManager] setEnable:NO];
        ZDCChatViewController *chatVC = (ZDCChatViewController *)viewController;
        ZDCChatUI *chatUI = chatVC.chatUI;
        ZDCChatView *chatView = chatUI.chatView;
        [chatView.table adjustsContentInsets];
        [[ZDCChat instance].overlay setEnabled:NO];
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    
    self.navigationController.delegate = self;
    //顶部视图
    [self initMineHeaderView];
    //模型
    [self initGroup];
    //
    [self initTableView];
    //初始化用户信息
    [[TLUser user] updateUserInfo];
    //通知
    [self addNotification];
    
    // viewDidLoad __ todo
//    FBKVOController *kvoController = [[FBKVOController alloc] initWithObserver:self];
//    [kvoController observe:[ZDCChat instance]
//                   keyPath:@"unreadMessagesCount"
//                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                     block:^(id observer, id object, NSDictionary *change) {
//
//                         [[UIApplication sharedApplication] ]
//
//                     }];
    
    
}



#pragma mark- overly-delegate

#pragma mark - Init

- (void)initMineHeaderView {
    
    MineHeaderView *mineHeaderView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160 + kStatusBarHeight)];
    mineHeaderView.delegate = self;
    self.headerView = mineHeaderView;
    
}

- (void)initGroup {
    
    CoinWeakSelf;
    
    //我的广告
    MineModel *advertisement = [MineModel new];
    
    advertisement.text = [LangSwitcher switchLang:@"我的广告" key:nil];
    advertisement.imgName = @"我的广告";
    advertisement.action = ^{
        
        MyAdvertiseVC *advertiseVC = [MyAdvertiseVC new];
        [weakSelf.navigationController pushViewController:advertiseVC animated:YES];
        
    };
    
    //我的地址
    MineModel *address = [MineModel new];
    address.text = [LangSwitcher switchLang:@"我的地址" key:nil];
    address.imgName = @"我的地址";
    address.action = ^{
        
        CoinAddressListVC *addressListVC = [CoinAddressListVC new];
        addressListVC.isCanLookManyCoin = YES;
        addressListVC.coin = [CoinService shareService].currentCoin;
        [weakSelf.navigationController pushViewController:addressListVC animated:YES];
        
    };
    
    //受信任的
    MineModel *trust = [MineModel new];
    
    trust.text = [LangSwitcher switchLang:@"受信任的" key:nil];
    trust.imgName = @"受信任的";
    trust.action = ^{
        
        FansVC *fansVC = [FansVC new];
        [weakSelf.navigationController pushViewController:fansVC animated:YES];
        
    };
    
    //邀请好友
    MineModel *inviteFriend = [MineModel new];
    inviteFriend.text = [LangSwitcher switchLang:@"邀请好友" key:nil];
    inviteFriend.imgName = @"邀请";
    inviteFriend.action = ^{
        
        InviteFriendVC *inviteVC = [InviteFriendVC new];
        [weakSelf.navigationController pushViewController:inviteVC animated:YES];
        
    };
    
    //安全中心
    MineModel *securityCenter = [MineModel new];
    securityCenter.text = [LangSwitcher switchLang:@"安全中心" key:nil];
    securityCenter.imgName = @"安全中心";
    securityCenter.action = ^{
        
        SettingVC *settingVC = [SettingVC new];
        
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    };
    
    //语言设置
    MineModel *languageSetting = [MineModel new];
    
    languageSetting.text = [LangSwitcher switchLang:@"语言设置" key:nil];
    languageSetting.imgName = @"语言设置";
    languageSetting.action = ^{
        
        LangChooseVC *vc = [[LangChooseVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    //个性设置
    MineModel *personalSetting = [MineModel new];
    
    personalSetting.text = [LangSwitcher switchLang:@"个性设置" key:nil];
    personalSetting.imgName = @"提醒设置";
    personalSetting.action = ^{
        
        PersonalitySettingVC *personalSettingVC = [PersonalitySettingVC new];
        [weakSelf.navigationController pushViewController:personalSettingVC animated:YES];
        
    };
    
    //常见问题
//    MineModel *problem = [MineModel new];
//
//    problem.text = [LangSwitcher switchLang:@"常见问题" key:nil];
//    problem.imgName = @"常见问题";
//    problem.action = ^{
//
//        HTMLStrVC *htmlVC = [HTMLStrVC new];
//
//        htmlVC.type = HTMLTypeCommonProblem;
//
//        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
//
//    };
    
//    //联系客服
//    MineModel *linkService = [MineModel new];
//    linkService.text = [LangSwitcher switchLang:@"联系客服" key:nil];
//    linkService.imgName = @"联系客服";
//    linkService.action = ^{
//
////        HTMLStrVC *htmlVC = [HTMLStrVC new];
////        htmlVC.type = HTMLTypeLinkService;
////        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
//
//        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//        [ZDCChat updateVisitor:^(ZDCVisitorInfo *visitor) {
//
//            visitor.name = [TLUser user].nickname;
//            visitor.phone = [TLUser user].mobile;
//            visitor.email = [TLUser user].email;
//
//        }];
//        //
////        [ZDCChat startChat:^(ZDCConfig *config) {
////
////        }];
//        [ZDCChat startChatIn:self.navigationController withConfig:nil];
//
//    };
    
//    //工单
    MineModel *helpModel = [MineModel new];
    helpModel.text = [LangSwitcher switchLang:@"帮助中心" key:nil];
    helpModel.imgName = @"常见问题";
    helpModel.action = ^{
        
        HTMLStrVC *htmlVC = [HTMLStrVC new];
        htmlVC.type = HTMLTypeCommonProblem;
        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
        
        //注册用户的身份,管理端可以看到这些信息
//   [ZDKRequests pushRequestListWithNavigationController:self.navigationController];
        
        //跳转
//         ZDKHelpCenterOverviewContentModel *contentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
//        contentModel.groupType = ZDKHelpCenterOverviewGroupTypeDefault;
        
        // 设置界面的代理
//        [ZDKHelpCenter setUIDelegate:weakSelf];
        //
//        contentModel.labels = @[@"tag"];
//        contentModel.groupType = ZDKHelpCenterOverviewGroupTypeSection;
//        contentModel.groupIds = @[@"sections2"];
        
//        [ZDKHelpCenter pushHelpCenterOverview:self.navigationController
//                             withContentModel:contentModel];
        
    };
    
    //关于我们
    MineModel *abountUs = [MineModel new];
    abountUs.text = [LangSwitcher switchLang:@"关于我们" key:nil];
    abountUs.imgName = @"关于我们";
    abountUs.action = ^{
        
//        HTMLStrVC *htmlVC = [HTMLStrVC new];
//        htmlVC.type = HTMLTypeAboutUs;
//        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
        
        TLAboutUsVC *vc = [[TLAboutUsVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
        
    };
    
    self.group = [MineGroup new];

    
    if ([AppConfig config].isUploadCheck) {
        
        
        self.group.sections = @[
//                                @[advertisement, address, trust],
//                                @[securityCenter, personalSetting,helpModel, linkService, abountUs]
                                ];

    } else {
      
        
        self.group.sections = @[
                                @[securityCenter, languageSetting],
                                @[helpModel, abountUs]
                                ];
        
    }
 
}

- (void)initTableView {
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.mineGroup = self.group;
    
    self.tableView.tableHeaderView = self.headerView;
    
//    if (@available(iOS 11.0, *)) {
//        
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];


}

//#pragma mark - Events
//- (void)loginOut {
//
//    [[TLUser user] loginOut];
//
//    [self changeInfo];
//}

- (void)changeInfo {
    
    [[TLUser user] changLoginTime];
    //
    if ([TLUser user].photo) {
        
        [self.headerView.photoBtn setTitle:@"" forState:UIControlStateNormal];
        
        [self.headerView.photoBtn sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] forState:UIControlStateNormal];
        
    } else {
        
        NSString *nickName = [TLUser user].nickname;
        
        NSString *title = [nickName substringToIndex:1];
        
        [self.headerView.photoBtn setTitle:title forState:UIControlStateNormal];
        
        [self.headerView.photoBtn setImage:nil forState:UIControlStateNormal];
        
    }
    
    self.headerView.nameLbl.text = [TLUser user].nickname;
    
    self.headerView.mobileLbl.text = [TLUser user].mobile;
    
//    self.headerView.levelBtn.hidden = [[TLUser user].level isEqualToString:kLevelOrdinaryTraders] ? YES : NO;
    
}

- (void)changeHeadIcon {
    
    [self.imagePicker picker];
}

#pragma mark - Data

//查询用户统计信息
- (void)requestUserStatistInfo {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"625256";
    http.parameters[@"master"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        UserStatistics *userStatist = [UserStatistics mj_objectWithKeyValues:responseObject[@"data"]];
        
        NSString *data = [NSString stringWithFormat:@"交易 %ld · 好评 %@ · 信任 %ld", userStatist.jiaoYiCount, userStatist.goodCommentRate, userStatist.beiXinRenCount];
        
        self.headerView.dataLbl.text = [LangSwitcher switchLang:data key:nil];

        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)changeHeadIconWithKey:(NSString *)key imgData:(NSData *)imgData {
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.code = USER_CHANGE_USER_PHOTO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"photo"] = key;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"修改头像成功" key:nil]];
        
        [TLUser user].photo = key;
        
        [[TLUser user] updateUserInfoWithNotification:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
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
            
            [[PublishService shareInstance] publishBuy:self.navigationController];

        }break;
            
        case MineHeaderSeletedTypeSell:
        {
            
            [[PublishService shareInstance] publishSell:self.navigationController];

        }break;
            
        default:
            break;
            
    }
}


@end
