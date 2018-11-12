//
//  LangChooseVC.m
//  Coin
//
//  Created by  tianlei on 2017/12/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "LangChooseVC.h"
#import "SettingModel.h"
#import <CDCommon/UIScrollView+TLAdd.h>
#import "TLTabBarController.h"
#import "LangSwitcher.h"
#import <ZendeskSDK/ZendeskSDK.h>
#import "NSBundle+Language.h"
//#import <ZendeskSDK/ZendeskSDK.h>
#import <ZendeskCoreSDK/ZendeskCoreSDK.h>
#import <ZendeskProviderSDK/ZendeskProviderSDK.h>
@interface LangChooseVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *langChooseTV;
@property (nonatomic, strong) NSMutableArray <SettingModel *>*models;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;
@end

@implementation LangChooseVC
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
    self.nameLable.text = [LangSwitcher switchLang:@"语言" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(16);
    self.nameLable.textColor = kTextBlack;
    self.navigationItem.titleView = self.nameLable;
//    self.title = [LangSwitcher switchLang:@"语言" key:nil];
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
//    self.backButton.frame = CGRectMake(15, kStatusBarHeight+5, 40, 40);
//    [self.backButton setImage:kImage(@"返回1-1") forState:(UIControlStateNormal)];
//    [self.backButton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.bgImage addSubview:self.backButton];
//    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, kStatusBarHeight+5, kScreenWidth - 108, 44)];
//    self.nameLable.text = [LangSwitcher switchLang:@"语言" key:nil];
//    self.nameLable.textAlignment = NSTextAlignmentCenter;
//    self.nameLable.font = Font(16);
//    self.nameLable.textColor = kTextBlack;
//    [self.bgImage addSubview:self.nameLable];

    self.langChooseTV = [[UITableView alloc] initWithFrame:CGRectMake(15, kNavigationBarHeight + 30, kScreenWidth-15, kHeight(295)) style:UITableViewStylePlain];
    [self.bgImage addSubview:self.langChooseTV];
    self.langChooseTV.rowHeight = 55;

    self.langChooseTV.delegate = self;
    self.langChooseTV.dataSource = self;
    self.langChooseTV.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.langChooseTV adjustsContentInsets];
    __weak typeof(self) weakself = self;
    //
    SettingModel *simpleModel = [[SettingModel alloc] init];
//    simpleModel.text = [LangSwitcher switchLang:@"简体中文" key:nil];
    simpleModel.text = @"简体中文";

    simpleModel.isSelect = [LangSwitcher currentLangType] == LangTypeSimple;
    [simpleModel setAction:^{
        
        [weakself langType:LangTypeSimple];
    }];
    //
    SettingModel *tridationModel = [[SettingModel alloc] init];
//    tridationModel.text = [LangSwitcher switchLang:@"繁体中文" key:nil];
    tridationModel.text = @"繁体中文";

    tridationModel.isSelect = [LangSwitcher currentLangType] == LangTypeTraditional;
    [tridationModel setAction:^{
        
        [weakself langType:LangTypeTraditional];

    }];
    SettingModel *EnglishModel = [[SettingModel alloc] init];
//    EnglishModel.text = [LangSwitcher switchLang:@"英文" key:nil];
    EnglishModel.text = @"English";

    EnglishModel.isSelect = [LangSwitcher currentLangType] == LangTypeEnglish;
    [EnglishModel setAction:^{
        
        [weakself langType:LangTypeEnglish];
        
    }];
    SettingModel *KorenModel = [[SettingModel alloc] init];
    KorenModel.text = @"한국어";
//    KorenModel.text = [LangSwitcher switchLang:@"韩文" key:nil];

    KorenModel.isSelect = [LangSwitcher currentLangType] == LangTypeKorean;
    [KorenModel setAction:^{

        [weakself langType:LangTypeKorean];

    }];
//    SettingModel *JapanseModel = [[SettingModel alloc] init];
//    JapanseModel.text = [LangSwitcher switchLang:@"日文" key:nil];
//    JapanseModel.isSelect = [LangSwitcher currentLangType] == LangTypeJapanese;
//    [JapanseModel setAction:^{
//
//        [weakself langType:LangTypeJapanese];,KorenModel,JapanseModel
//
//    }];
    
    //
    [self.models addObjectsFromArray:@[simpleModel,EnglishModel,KorenModel]];
    
    
}
- (void)buttonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)langType:(LangType)type {
    
        [TLAlert alertWithTitle:[LangSwitcher switchLang:@"切换语言" key:nil]
                            msg:nil
                     confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                      cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                         cancle:^(UIAlertAction *action) {
    
                         } confirm:^(UIAlertAction *action) {

                             [ZDKZendesk initializeWithAppId: @"71d2ca9aba0cccc12deebfbdd352fbae8c53cd8999dd10bc"
                                                    clientId: @"mobile_sdk_client_7af3526c83d0c1999bc3"
                                                  zendeskUrl: @"https://thachainhelp.zendesk.com"];
                             id<ZDKObjCIdentity> userIdentity = [[ZDKObjCAnonymous alloc] initWithName:nil email:nil];
                             [[ZDKZendesk instance] setIdentity:userIdentity];
                             
                             [ZDKSupport initializeWithZendesk: [ZDKZendesk instance]];
                             NSString *lan;
                             if (type == LangTypeSimple || type == LangTypeTraditional) {
                                 lan = @"zh-cn";
                             }else if (type == LangTypeKorean)
                             {
                                 lan = @"ko";
                             }
                             else
                             {
                                 lan = @"en-us";
                             }
                             
//                             [NSBundle setLanguage:lan];
                             [ZDKSupport instance].helpCenterLocaleOverride = lan;


                             [[NSUserDefaults standardUserDefaults] setValue:@[lan] forKey:@"AppleLanguages"];

                             [[NSUserDefaults standardUserDefaults] synchronize];


                             
                             
                             
                             [LangSwitcher changLangType:type];
                             [LangSwitcher startWithTraditional];

                             //                             UIView *v = nil;
                             if (type == LangTypeKorean) {
                                 [LangSwitcher startWithTraditional];
                                 TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
                                 [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;
                                 return ;
                             }
                             TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
                      [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;

                         }];
    
}



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
    if (indexPath.row != 0) {
        UILabel *beat = [UILabel labelWithBackgroundColor:kAppCustomMainColor textColor:kWhiteColor font:12];
        
        [cell addSubview:beat];
        beat.text = @"Beta";
        
        [beat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(20);
            
            make.left.equalTo(cell.mas_left).offset(70);
        }];
    }
   
    if (settingModel.isSelect) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 11)];
//        iv.backgroundColor = [UIColor orangeColor];
        [cell addSubview:iv];
        iv.image = [UIImage imageNamed:@"打勾"];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-20);
        }];

    }else{
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 11)];
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
