//
//  TheInitialVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/12.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TheInitialVC.h"
#import "TheInitialView.h"
#import "RegisterVC.h"
#import "CountryModel.h"
#import "LoginVC.h"
#import "CreateWalletVC.h"
#import "ImportWalletVC.h"
#import "TradePasswordVC.h"
#import "BackupWalletMnemonicVC.h"
#import "TLTabBarController.h"
@interface TheInitialVC ()<TheInitialViewBtnDelegate>

@property (nonatomic , strong)NSMutableArray <CountryModel*>*countrys;

@end

@implementation TheInitialVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TheInitialView * initialView = [[TheInitialView alloc]initWithFrame:CGRectMake(0, -kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT +  kStatusBarHeight)];
    initialView.delegate = self;
    [self.view addSubview:initialView];
    
    [self configData];
    
    if ([TLUser user].isLogin == YES || [TLUser isBlankString:[[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC]] == NO) {
        UIButton *backnBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [backnBtn setImage:kImage(@"返回 白色") forState:(UIControlStateNormal)];
        [backnBtn setTitle:[LangSwitcher switchLang:@"回到首页" key:nil] forState:(UIControlStateNormal)];
        [backnBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        backnBtn.frame = CGRectMake(20, kStatusBarHeight, SCREEN_WIDTH - 40, 44);
        backnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backnBtn.titleLabel.font = Font(16);
        [backnBtn addTarget:self action:@selector(backnBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:backnBtn];
    }
}

-(void)backnBtnClick
{
    TLTabBarController *tabBarCtrl = [[TLTabBarController alloc] init];
//    TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:tabBarCtrl];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarCtrl;
}

- (void)configData
{
    NSString *money ;
    //获取缓存的国家
    NSData *data   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseModel"];
    CountryModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //有缓存加载缓存国家
    if ([TLUser isBlankString:model.chineseName] == YES) {
        
        if (self.countrys.count == 0) {
            [self loadData];
        }else
        {
            model = [self.countrys objectAtIndex:0];
            data = [NSKeyedArchiver archivedDataWithRootObject:model];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"chooseModel"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if ([model.interSimpleCode isEqualToString:@"CN"] ||[model.interSimpleCode isEqualToString:@"HK"] ||[model.interSimpleCode isEqualToString:@"TW"] || [model.interSimpleCode isEqualToString:@"MO"]) {
                [LangSwitcher changLangType:LangTypeSimple];
                money = @"CNY";
            }else if ([model.interSimpleCode isEqualToString:@"KR"] || [model.interSimpleCode isEqualToString:@"KO"] )
            {
                [LangSwitcher changLangType:LangTypeKorean];
                money = @"KRW";
            }else{
                [LangSwitcher changLangType:LangTypeEnglish];
                money = @"USD";
            }
            [[NSUserDefaults standardUserDefaults] setObject:money forKey:KLocalMoney];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else
    {
        if ([model.interSimpleCode isEqualToString:@"CN"] ||[model.interSimpleCode isEqualToString:@"HK"] || [model.interSimpleCode isEqualToString:@"TW"] || [model.interSimpleCode isEqualToString:@"MO"]) {
//            [LangSwitcher changLangType:LangTypeSimple];
            money = @"CNY";
        }else if ([model.interSimpleCode isEqualToString:@"KR"] || [model.interSimpleCode isEqualToString:@"KO"] )
        {
//            [LangSwitcher changLangType:LangTypeKorean];
            money = @"KRW";
        }else{
//            [LangSwitcher changLangType:LangTypeEnglish];
            money = @"USD";
        }
        [[NSUserDefaults standardUserDefaults] setObject:money forKey:KLocalMoney];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
        
        //如果国家编号不为空，说明是1.7.0之后缓存的，直接设置即可
//        if ([model.code isNotBlank]) {
//
//            NSString *url = [model.pic convertImageUrl];
    
//            [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
//
//            self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[model.interCode substringFromIndex:2]];
            
//        }
        //如果国家编号为空，说明是1.7.0之前缓存的，需要移除
//        else {

//            CountryModel *defaultCountry = [self.countrys objectAtIndex:0];
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:defaultCountry];
//            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"chooseModel"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
    
//            NSString *url = [defaultCountry.pic convertImageUrl];
//            [self.pic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:kImage(@"中国国旗")];
//            self.PhoneCode.text = [NSString stringWithFormat:@"+%@",[defaultCountry.interCode substringFromIndex:2]];
    
//        }
        
//    }
    //没有缓存加载网络请求国家中的中国
//    else {
    
//        CountryModel *defaultCountry = [self.countrys objectAtIndex:0];
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:defaultCountry];
//        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"chooseModel"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        NSString *url = [defaultCountry.pic convertImageUrl];
//
//        if ([defaultCountry.interSimpleCode isEqualToString:@"CN"] ||[defaultCountry.interSimpleCode isEqualToString:@"HK"] ||[defaultCountry.interSimpleCode isEqualToString:@"TW"] || [defaultCountry.interSimpleCode isEqualToString:@"MO"]) {
//            [LangSwitcher changLangType:LangTypeSimple];
//
//            money = @"CNY";
//
//
//
//        }else if ([defaultCountry.interSimpleCode isEqualToString:@"KR"] || [defaultCountry.interSimpleCode isEqualToString:@"KO"] )
//        {
//            [LangSwitcher changLangType:LangTypeKorean];
//            money = @"KRW";
//
//        }else{
//
//            [LangSwitcher changLangType:LangTypeEnglish];
//            money = @"USD";
//
//        }
//    }
    
}



#pragma mark - Init
- (void)loadData {
    
    
    //获取国家列表
    TLNetworking *net = [TLNetworking new];
    net.showView = self.view;
    net.code = @"801120";
    net.isLocal = YES;
    net.ISparametArray = YES;
    net.parameters[@"status"] = @"1";
    [net postWithSuccess:^(id responseObject) {
        
        self.countrys = [CountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self configData];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)TheInitialViewBtnClick:(NSInteger)tag
{
    switch (tag) {
        case 0:
        {
            
            
            LoginVC *vc = [[LoginVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            RegisterVC *vc = [[RegisterVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 2:
        {
            
//            BackupWalletMnemonicVC *vc = [BackupWalletMnemonicVC new];
            TradePasswordVC *vc = [[TradePasswordVC alloc]init];
            vc.state = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            TradePasswordVC *vc = [[TradePasswordVC alloc]init];
            vc.state = @"2";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
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
