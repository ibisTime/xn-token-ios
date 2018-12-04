//
//  TLMineVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMineVC.h"

#import "APICodeMacro.h"

#import "MineGroup.h"

#import "MineTableView.h"
#import "MineHeaderView.h"
#import "TLAboutUsVC.h"
#import "SettingVC.h"
#import "HTMLStrVC.h"

#import "TLImagePicker.h"
#import "TLUploadManager.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import <CDCommon/UIScrollView+TLAdd.h>

#import "MineCell.h"
#import "LangChooseVC.h"
#import "JoinMineVc.h"
#import "WalletSettingVC.h"
#import "TLUserLoginVC.h"
#import "ChooseCountryVc.h"
#import "ChangeLocalMoneyVC.h"
#import "TLChangeNikeName.h"
#import "BuildWalletMineVC.h"
#import "TLQusertionVC.h"
#import "TLinviteVC.h"
#import "TLMeSetting.h"
#import "NewHelpCentetVC.h"

#import "IntegralVC.h"
//我的收益
#import "MyIncomeVC.h"
#import "ZQFaceAuthEngine.h"
#import "ZQOCRScanEngine.h"

@interface TLMineVC ()<MineHeaderSeletedDelegate, UINavigationControllerDelegate,ZDKHelpCenterConversationsUIDelegate,ZDKHelpCenterDelegate,ZQFaceAuthDelegate,ZQOcrScanDelegate,RefreshDelegate>
{
    NSString *str1;
    NSString *str2;
    NSString *str3;
    
}
//<ZQFaceAuthDelegate,ZQOcrScanDelegate>
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:animated];


}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];


    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}


- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    //顶部视图
    [self initMineHeaderView];
    //模
    [self initGroup];
    //
    [self initTableView];
    //初始化用户信息
    [[TLUser user] updateUserInfo];
    //通知
    [self addNotification];
    [self changeInfo];
    
    [self requesUserInfoWithResponseObject];
    
    
    
    
    
//    NSArray *array = @[@"开始检测"];
//    for (int i = 0; i < 1; i ++) {
//        UIButton *button = [UIButton buttonWithTitle:array[i] titleColor:[UIColor blackColor] backgroundColor:kClearColor titleFont:14];
//        button.frame = CGRectMake(SCREEN_WIDTH/2 - 50, 100 + i%2 * 100, 100, 50);
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
//        button.tag = 100 + i;
//        [self.view addSubview:button];
//    }
    
}

//-(void)buttonClick:(UIButton *)sender
//{
//    if (sender.tag == 100) {
//
//    }
//}

#pragma mark - ZQFaceAuthDelegate
- (void)faceAuthFinishedWithResult:(ZQFaceAuthResult)result UserInfo:(id)userInfo{
    
    UIImage * livingPhoto = [userInfo objectForKey:@"livingPhoto"];
    
    if(result  == ZQFaceAuthResult_Done && livingPhoto !=nil){
        TLUploadManager *manager = [TLUploadManager manager];
        NSData *imgData = UIImageJPEGRepresentation(livingPhoto, 0.6);
        manager.imgData = imgData;
        manager.image = livingPhoto;
        [manager getTokenShowView:self.view succes:^(NSString *key) {
            
            str3 = key;
            
            
            TLNetworking *http = [TLNetworking new];
            http.showView = self.view;
            http.code = @"805197";
            http.parameters[@"userId"] = [TLUser user].userId;
            http.parameters[@"frontImage"] = str1;
            http.parameters[@"backImage"] = str2;
            http.parameters[@"faceImage"] = str3;
//            QUERY
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:[LangSwitcher switchLang:@"实名认证成功" key:nil]];
                [self requesUserInfoWithResponseObject];
            } failure:^(NSError *error) {
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)faceAuthFinishedWithResult:(NSInteger)result userInfo:(id)userInfo{
    
    NSLog(@"Swift authFinish");
}

- (void)idCardOcrScanFinishedWithResult:(ZQFaceAuthResult)result userInfo:(id)userInfo{
    NSLog(@"OC OCR Finish");
    
    UIImage *frontcard = [userInfo objectForKey:@"frontcard"];
    UIImage *portrait = [userInfo objectForKey:@"portrait"];
    UIImage *backcard = [userInfo objectForKey:@"backcard"];
    if(result  == ZQFaceAuthResult_Done && frontcard != nil && portrait != nil && backcard !=nil){
        
        
        NSData *imgData = UIImageJPEGRepresentation(frontcard, 0.6);
        NSData *imgData1 = UIImageJPEGRepresentation(backcard, 0.6);
        //进行上传
        TLUploadManager *manager = [TLUploadManager manager];
        
        manager.imgData = imgData;
        manager.image = frontcard;
        [manager getTokenShowView:self.view succes:^(NSString *key) {
            
            str1 = key;
//            [weakSelf changeHeadIconWithKey:key imgData:imgData];
            TLUploadManager *manager1 = [TLUploadManager manager];
            
            manager1.imgData = imgData1;
            manager1.image = backcard;
            [manager1 getTokenShowView:self.view succes:^(NSString *key) {
                
                str2 = key;
                ZQFaceAuthEngine * engine = [[ZQFaceAuthEngine alloc]init];
                engine.delegate = self;
                engine.appKey = @"nJXnQp568zYcnBdPQxC7TANqakUUCjRZqZK8TrwGt7";
                engine.secretKey = @"887DE27B914988C9CF7B2DEE15E3EDF8";
                [engine startFaceAuthInViewController:self];
                //            [weakSelf changeHeadIconWithKey:key imgData:imgData];
                
            } failure:^(NSError *error) {
                
            }];
        } failure:^(NSError *error) {
            
        }];
    }
    
}


- (void)requesUserInfoWithResponseObject {
    
//    NSString *token = responseObject[@"data"][@"token"];
//    NSString *userId = responseObject[@"data"][@"userId"];
//    [TLUser user].userId = userId;
//    [TLUser user].token = token;
    //保存用户账号和密码
    //    [[TLUser user] saveUserName:self.phoneTf.text pwd:self.pwdTf.text];
    
    //1.获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
//        [TLUser user].userId = userId;
//        [TLUser user].token = token;
        
        //保存用户信息
        [[TLUser user] saveUserInfo:userInfo];
        //初始化用户信息
        [[TLUser user] setUserInfoWithDict:userInfo];
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


#pragma mark- overly-delegate

#pragma mark - Init

- (void)initMineHeaderView {
    
    MineHeaderView *mineHeaderView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 188 + kStatusBarHeight)];
    mineHeaderView.delegate = self;
    self.headerView = mineHeaderView;
    
}


- (void)initTableView {
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT - kTabBarHeight) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = YES;
    self.tableView.refreshDelegate = self;
    self.tableView.mineGroup = self.group;
    //    [self.view addSubview:self.headerView];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
}

-(void)refreshTableView:(TLTableView *)refreshTableview scrollView:(UIScrollView *)scroll
{
    CGFloat height = (188 + kStatusBarHeight);
    ////    导航栏
    //    if (self.tableView.contentOffset.y <= (235 - 64)) {
    //        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:9/255.0 green:90/255.0 blue:221/255.0 alpha:self.tableView.contentOffset.y / (235 - 64)]] forBarMetrics:UIBarMetricsDefault];
    //    }else
    //    {
    //        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:9/255.0 green:90/255.0 blue:221/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    //    }
    //
    //    // 获取到tableView偏移量
    CGFloat Offset_y = scroll.contentOffset.y;
    // 下拉 纵向偏移量变小 变成负的
    if ( Offset_y < 0) {
        // 拉伸后图片的高度
        CGFloat totalOffset = height - Offset_y;
        // 图片放大比例
        CGFloat scale = totalOffset / height;
        CGFloat width = SCREEN_WIDTH;
        // 拉伸后图片位置
        self.headerView.bgIV.frame = CGRectMake(-(width * scale - width) / 2, Offset_y, width * scale, totalOffset);
    }
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                [self loginTheWhether];
                MyIncomeVC *vc = [[MyIncomeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                [self loginTheWhether];
                ZQOCRScanEngine *engine = [[ZQOCRScanEngine alloc] init];
                engine.delegate = self;
                engine.appKey = @"nJXnQp568zYcnBdPQxC7TANqakUUCjRZqZK8TrwGt7";
                engine.secretKey = @"887DE27B914988C9CF7B2DEE15E3EDF8";
                [engine startOcrScanIdCardInViewController:self];
            }
                break;
            case 2:
            {
                [self loginTheWhether];
                SettingVC *settingVC = [SettingVC new];
                [self.navigationController pushViewController:settingVC animated:YES];
            }
                break;
            case 3:
            {
                WalletSettingVC *settingVC = [WalletSettingVC new];
                [self.navigationController pushViewController:settingVC animated:YES];
            }
                break;
            case 4:
            {
                
                JoinMineVc *vc = [[JoinMineVc alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:
            {
                [self loginTheWhether];
                TLQusertionVC *personalSettingVC = [TLQusertionVC new];
                [self.navigationController pushViewController:personalSettingVC animated:YES];
            }
                break;
            case 6:
            {
                [ZDKZendesk initializeWithAppId: @"71d2ca9aba0cccc12deebfbdd352fbae8c53cd8999dd10bc"
                                       clientId: @"mobile_sdk_client_7af3526c83d0c1999bc3"
                                     zendeskUrl: @"https://thachainhelp.zendesk.com"];
                
                id<ZDKObjCIdentity> userIdentity = [[ZDKObjCAnonymous alloc] initWithName:nil email:nil];
                [[ZDKZendesk instance] setIdentity:userIdentity];
                
                [ZDKCoreLogger setEnabled:YES];
                [ZDKSupport initializeWithZendesk:[ZDKZendesk instance]];
                
                
                LangType type = [LangSwitcher currentLangType];
                NSString *lan;
                if (type == LangTypeSimple || type == LangTypeTraditional) {
                    lan = @"zh-cn";
                }else if (type == LangTypeKorean)
                {
                    lan = @"ko";
                }else{
                    lan = @"en-us";
                }
                [ZDKSupport instance].helpCenterLocaleOverride = lan;
                [ZDKLocalization localizedStringWithKey:lan];
                
                
                ZDKHelpCenterUiConfiguration *hcConfig  =  [ ZDKHelpCenterUiConfiguration  new];
                [ZDKTheme  currentTheme].primaryColor  = [UIColor redColor];
                UIViewController<ZDKHelpCenterDelegate>*helpCenter  =  [ ZDKHelpCenterUi  buildHelpCenterOverviewWithConfigs :@[hcConfig]];
                
                self.navigationController.navigationBar.translucent = YES;
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationController.navigationBar.tintColor = [UIColor blackColor];
                self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
                self.navigationItem.backBarButtonItem = item;
                [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                  NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:16]}];
                
                
                helpCenter.uiDelegate = self;
                
                
                
                [self.navigationController  pushViewController:helpCenter animated:YES];
            }
                break;
            case 7:
            {
                TLMeSetting *vc = [[TLMeSetting alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)initGroup {
    
    CoinWeakSelf;
    MineModel *accounrModel = [MineModel new];
    accounrModel.text = [LangSwitcher switchLang:@"本地货币" key:nil];
    accounrModel.imgName = @"本地货币";
    accounrModel.action = ^{
//        if (![TLUser user].isLogin) {
//            TheInitialVC *loginVC= [TheInitialVC new];
//            [weakSelf.navigationController pushViewController:loginVC animated:YES];
////            loginVC.loginSuccess = ^{
////
////            };
//            return ;
//        }
        ChangeLocalMoneyVC *moneyVC= [[ChangeLocalMoneyVC alloc] init];
        [weakSelf.navigationController pushViewController:moneyVC animated:YES];


    };
    
    MineModel *settingModel = [MineModel new];
    settingModel.text = [LangSwitcher switchLang:@"账户与安全" key:nil];
    settingModel.imgName = @"账户与安全";
    settingModel.action = ^{
        [self loginTheWhether];
//        if (![TLUser user].isLogin) {
//            TheInitialVC *loginVC= [TheInitialVC new];
//            [weakSelf.navigationController pushViewController:loginVC animated:YES];
////            loginVC.loginSuccess = ^{
////
////            };
//            return ;
//        }
        SettingVC *settingVC = [SettingVC new];

        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    };
    
    
    MineModel *inviteModel = [MineModel new];
    inviteModel.text = [LangSwitcher switchLang:@"邀请有礼" key:nil];
    inviteModel.imgName = @"邀请有礼";
    inviteModel.action = ^{
        [self loginTheWhether];
//        if (![TLUser user].isLogin) {
//            TheInitialVC *loginVC= [TheInitialVC new];
//            [weakSelf.navigationController pushViewController:loginVC animated:YES];
////            loginVC.loginSuccess = ^{
////
////            };
//            return ;
//        }
        TLinviteVC *settingVC = [TLinviteVC new];
        
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    };

    MineModel *MyIncome = [MineModel new];
    MyIncome.text = [LangSwitcher switchLang:@"我的收益" key:nil];
    MyIncome.imgName = @"我的收益icon";
    MyIncome.action = ^{
        [self loginTheWhether];
        MyIncomeVC *vc = [[MyIncomeVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];


    };


//    MineModel *language = [MineModel new];
//    language.text = [LangSwitcher switchLang:@"语言" key:nil];
//    language.imgName = @"语言";
//    language.action =^{
//
//        LangChooseVC *vc = [[LangChooseVC alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//
//    };
    //安全中心
    
    
    
    MineModel *securityCenter = [MineModel new];
    securityCenter.text = [LangSwitcher switchLang:@"钱包工具" key:nil];
    securityCenter.imgName = @"钱包工具";
    securityCenter.action = ^{
        
        WalletSettingVC *settingVC = [WalletSettingVC new];
        
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
        
//        if (![TLUser user].isLogin) {
//            TLUserLoginVC *loginVC= [TLUserLoginVC new];
//            [weakSelf.navigationController pushViewController:loginVC animated:YES];
//            loginVC.loginSuccess = ^{
//
//            };
//            return ;
//        }
        
//        TLDataBase *dataBase = [TLDataBase sharedManager];
//        NSString *word;
//        if ([dataBase.dataBase open]) {
//            NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAUser where userId = '%@'",[TLUser user].userId];
//            //        [sql appendString:[TLUser user].userId];
//            FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//            while ([set next])
//            {
//                word = [set stringForColumn:@"Mnemonics"];
//
//            }
//            [set close];
//        }
//        [dataBase.dataBase close];
//        if (word.length > 0) {
        
//        }else{
        
//            BuildWalletMineVC *settingVC = [BuildWalletMineVC new];
//
//            [weakSelf.navigationController pushViewController:settingVC animated:YES];
//        }
       
    };
    
    //语言设置
    MineModel *languageSetting = [MineModel new];
    
    languageSetting.text = [LangSwitcher switchLang:@"加入社群" key:nil];
    languageSetting.imgName = @"加入社群";
    languageSetting.action = ^{
//        if (![TLUser user].isLogin) {
//            TLUserLoginVC *loginVC= [TLUserLoginVC new];
//            [weakSelf.navigationController pushViewController:loginVC animated:YES];
//            loginVC.loginSuccess = ^{
//
//            };
//            return ;
//        }
        JoinMineVc *vc = [[JoinMineVc alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    //个性设置
    MineModel *questionSetting = [MineModel new];
    
    questionSetting.text = [LangSwitcher switchLang:@"问题反馈" key:nil];
    questionSetting.imgName = @"问题反馈";
    questionSetting.action = ^{
       [self loginTheWhether];
        TLQusertionVC *personalSettingVC = [TLQusertionVC new];
        [weakSelf.navigationController pushViewController:personalSettingVC animated:YES];
        
    };
    

    //    //工单
    MineModel *helpModel = [MineModel new];
    helpModel.text = [LangSwitcher switchLang:@"帮助中心" key:nil];
    helpModel.imgName = @"帮助中心-1";
    helpModel.action = ^{
//        if (![TLUser user].isLogin) {
//            TLUserLoginVC *loginVC= [TLUserLoginVC new];
//            [weakSelf.navigationController pushViewController:loginVC animated:YES];
//            loginVC.loginSuccess = ^{
//
//            };
//            return ;
//        }
        [ZDKZendesk initializeWithAppId: @"71d2ca9aba0cccc12deebfbdd352fbae8c53cd8999dd10bc"
                               clientId: @"mobile_sdk_client_7af3526c83d0c1999bc3"
                             zendeskUrl: @"https://thachainhelp.zendesk.com"];

        id<ZDKObjCIdentity> userIdentity = [[ZDKObjCAnonymous alloc] initWithName:nil email:nil];
        [[ZDKZendesk instance] setIdentity:userIdentity];

        [ZDKCoreLogger setEnabled:YES];
        [ZDKSupport initializeWithZendesk:[ZDKZendesk instance]];


        LangType type = [LangSwitcher currentLangType];
        NSString *lan;
        if (type == LangTypeSimple || type == LangTypeTraditional) {
            lan = @"zh-cn";
        }else if (type == LangTypeKorean)
        {
            lan = @"ko";
        }else{
            lan = @"en-us";
        }
        [ZDKSupport instance].helpCenterLocaleOverride = lan;
        [ZDKLocalization localizedStringWithKey:lan];


        ZDKHelpCenterUiConfiguration *hcConfig  =  [ ZDKHelpCenterUiConfiguration  new];
        [ZDKTheme  currentTheme].primaryColor  = [UIColor redColor];
        UIViewController<ZDKHelpCenterDelegate>*helpCenter  =  [ ZDKHelpCenterUi  buildHelpCenterOverviewWithConfigs :@[hcConfig]];

        self.navigationController.navigationBar.translucent = YES;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationItem.backBarButtonItem = item;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                          NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:16]}];


        helpCenter.uiDelegate = self;



        [self.navigationController  pushViewController:helpCenter animated:YES];


    };
    //关于我们
    MineModel *abountUs = [MineModel new];
    abountUs.text = [LangSwitcher switchLang:@"关于我们" key:nil];
    abountUs.imgName = @"关于我们";
    abountUs.action = ^{
        TLAboutUsVC *vc = [[TLAboutUsVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };

    MineModel *meSetting = [MineModel new];
    meSetting.text = [LangSwitcher switchLang:@"设置" key:nil];
    meSetting.imgName = @"设置";
    meSetting.action = ^{

        TLMeSetting *vc = [[TLMeSetting alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };


    
    self.group = [MineGroup new];
    
    
    if ([AppConfig config].isUploadCheck) {
        
        
        self.group.sections = @[

                                ];
        
    } else {
        
        if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:MNEMONIC]] == YES) {
            self.group.sections = @[ @[settingModel], @[inviteModel,MyIncome,questionSetting ],
                                     @[languageSetting,helpModel, meSetting]
                                     ];
        }else
        {
            self.group.sections = @[ @[settingModel], @[inviteModel,MyIncome,questionSetting ],
                                     @[languageSetting,securityCenter,helpModel, meSetting]
                                     ];
        }
        
        
        
    }
 
}



-(ZDKContactUsVisibility)active {
    return ZDKContactUsVisibilityArticleListOnly;
}


- (ZDKNavBarConversationsUIType) navBarConversationsUIType
{

    return ZDKNavBarConversationsUITypeLocalizedLabel;
}

- (NSString *) conversationsBarButtonLocalizedLabel
{
    return @"123";
}

//- (ZDKNavBarConversationsUIType) navBarConversationsUIType




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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];


}

//#pragma mark - Events
- (void)loginOut {    

    [[TLUser user] loginOut];
    [self.headerView.photoBtn setImage:kImage(@"头像") forState:UIControlStateNormal];
    self.headerView.nameLbl.text = nil;
    
    self.headerView.mobileLbl.text = nil;

}

- (void)changeInfo {
    
    [[TLUser user] changLoginTime];
    //
    if ([TLUser user].photo) {
        [self.headerView.photoBtn sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] forState:UIControlStateNormal];
    } else {
        [self.headerView.photoBtn setImage:nil forState:UIControlStateNormal];
    }
    
    
    if ([TLUser user].isLogin == NO) {
        self.headerView.nameLbl.text = [LangSwitcher switchLang:@"未登录" key:nil];
//        self.headerView.mobileLbl.text = [LangSwitcher switchLang:@"" key:<#(NSString *)#>]
        self.headerView.phone.hidden = YES;
        return;
    }
    self.headerView.nameLbl.text = [TLUser user].nickname;
    NSRange rang = NSMakeRange(3, 4);
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNickName)];
    [self.headerView.nameLbl addGestureRecognizer:ta];
    if ([TLUser isBlankString:[TLUser user].mobile] == NO) {
        self.headerView.mobileLbl.text = [NSString stringWithFormat:@"+%@ %@",[[TLUser user].interCode substringFromIndex:2], [[TLUser user].mobile stringByReplacingCharactersInRange:rang withString:@"****"]];
    }else
    {
        self.headerView.mobileLbl.text = [NSString stringWithFormat:@"%@", [[TLUser user].email stringByReplacingCharactersInRange:rang withString:@"****"]];
    }
    self.headerView.levelBtn.hidden = [[TLUser user].level isEqualToString:kLevelOrdinaryTraders] ? YES : NO;
    [self.headerView.integralBtn addTarget:self action:@selector(integralBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}
//信用积分
-(void)integralBtnClick
{
    IntegralVC *vc = [IntegralVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeNickName
{
    //修改昵称
    TLChangeNikeName *name = [TLChangeNikeName new];
    if ([TLUser user].isLogin == YES) {
        name.text = [TLUser user].nickname;
        [self.navigationController pushViewController:name animated:YES];
    }
}

- (void)changeHeadIcon {
    if (![TLUser user].isLogin) {
//        TLUserLoginVC *loginVC= [TLUserLoginVC new];
//        [self.navigationController pushViewController:loginVC animated:YES];
//        loginVC.loginSuccess = ^{
//            
//        };
        return ;
    }
    
    [self.imagePicker picker];
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
        default:
            break;
    }
}





@end
