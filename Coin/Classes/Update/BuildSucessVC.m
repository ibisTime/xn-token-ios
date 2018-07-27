//
//  BuildSucessVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/8.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "BuildSucessVC.h"
#import "BuildBackUpVC.h"
#import "MnemonicUtil.h"
@interface BuildSucessVC ()

@property (nonatomic ,strong) UIImageView *iconImage;

@property (nonatomic ,strong) UILabel *nameLable;

@property (nonatomic ,strong) UILabel *messageLable;

@property (nonatomic ,strong) UILabel *bottomLable;

@property (nonatomic ,strong) UIButton *buildButton;

@property (nonatomic ,strong) UIButton *importButton;

@property (nonatomic ,strong) UIButton *introduceButton;

@property (nonatomic ,copy) NSString *mnemonics;

@property (nonatomic ,strong) UIButton *howButton;

@end

@implementation BuildSucessVC

- (void)viewDidLoad {
    self.title = [LangSwitcher switchLang:@"创建钱包" key:nil];
    
    [self initViews];
//    self.mnemonics =  [MnemonicUtil getGenerateMnemonics];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initViews
{
    self.view.backgroundColor = kWhiteColor;
//    self.iconImage = [[UIImageView alloc] init];
//    [self.view addSubview:self.iconImage];
//    self.iconImage.image = kImage(@"logoTHA");
//    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@44);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.width.height.equalTo(@75);
//
//    }];
    
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = kHexColor(@"#0848DF");
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = kWhiteColor;
    [self.view addSubview:whiteView];
    UIImageView *bgImage = [[UIImageView alloc] init];
    bgImage.image = kImage(@"打勾 大");
    [whiteView addSubview:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@(kHeight(50)));
        make.centerX.equalTo(whiteView.mas_centerX);
        make.width.height.equalTo(@(kHeight(80)));
    }];
    
    UILabel *newWallet = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:20];
    
    [whiteView addSubview:newWallet];
    newWallet.text = [LangSwitcher switchLang:@"新钱包创建成功" key:nil];
    newWallet.textAlignment = NSTextAlignmentCenter;
    [newWallet mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgImage.mas_bottom).offset(16);
        make.centerX.equalTo(whiteView.mas_centerX);
//        make.width.height.equalTo(@(kHeight(80)));
    }];
    
    UILabel *introduce = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12];
    
    [whiteView addSubview:introduce];
    introduce.numberOfLines = 0;
    introduce.text = [LangSwitcher switchLang:@"强烈建议您在使用钱包前做好备份,导出助记词存储到安全的地方。然后开始尝试转入小额资金启用" key:nil];
    introduce.textAlignment = NSTextAlignmentLeft;
    [introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(newWallet.mas_bottom).offset(8);
        make.left.equalTo(whiteView.mas_left).offset(30);
        make.right.equalTo(whiteView.mas_right).offset(-30);

//        make.centerX.equalTo(whiteView.mas_centerX);
        //        make.width.height.equalTo(@(kHeight(80)));
    }];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top);
        
        make.height.equalTo(@(kHeight(292)));
    }];
    
    whiteView.layer.cornerRadius = 4;
    whiteView.clipsToBounds = YES;
//        self.introduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.view addSubview:self.introduceButton];
//        [self.introduceButton setBackgroundImage:kImage(@"重要提示") forState:UIControlStateNormal];
//        [self.introduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_top).offset(54);
//            make.left.equalTo(self.view.mas_left).offset(20);
//            make.height.equalTo(@14);
//            make.width.equalTo(@14);
//
//        }];
//    self.nameLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kBlackColor font:14];
//    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
//    [self.view addSubview:self.nameLable];
//    self.nameLable.text = [LangSwitcher switchLang:@"重要提示" key:nil];
//
////    self.nameLable.text = [LangSwitcher switchLang:@"重要提示" key:nil];
//    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(450);
//        make.left.equalTo(self.view.mas_left).offset(48);
//
//    }];
//    self.messageLable = [[UILabel alloc] init];
//    [self.view addSubview:_messageLable];
//    self.messageLable.font  = [UIFont systemFontOfSize:14];
//    self.messageLable.numberOfLines = 0;
//    self.messageLable.backgroundColor = kClearColor;
//    self.messageLable.textColor = kHexColor(@"#999999");
////    self.messageLable.text = [LangSwitcher switchLang:@"拥有钱包私钥就能完全控制钱包资产,  因此强烈建议在使用钱包前做好备份,  将钱包私钥保存到安全的地方。"key:nil];
//   self.messageLable.text = [LangSwitcher switchLang:@"拥有钱包私钥就能完全控制钱包资产,  因此强烈建议在使用钱包前做好备份,  将钱包私钥保存到安全的地方。" key:nil];
//
//
//    [self.messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLable.mas_bottom).offset(25);
//        make.left.equalTo(@20);
//        make.right.equalTo(@-20);
//
//    }];

    
    self.buildButton = [UIButton buttonWithImageName:nil cornerRadius:6];
//    NSString *text = [LangSwitcher switchLang:@"立即备份" key:nil];
    NSString *text = NSLocalizedString(@"备份钱包", nil);

    [self.buildButton setTitle:text forState:UIControlStateNormal];
    self.buildButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.buildButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.buildButton addTarget:self action:@selector(buildBackUpWallet) forControlEvents:UIControlEventTouchUpInside];
    [self.buildButton setBackgroundColor:kHexColor(@"#0848DF") forState:UIControlStateNormal];
    [self.view addSubview:self.buildButton];
    [self.buildButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_bottom).offset(26);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.height.equalTo(@45);
        
    }];
    
    self.howButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    //    NSString *text = [LangSwitcher switchLang:@"立即备份" key:nil];
    NSString *text1 = NSLocalizedString(@"如何备份钱包?", nil);
    
    [self.howButton setTitle:text1 forState:UIControlStateNormal];
    self.howButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.howButton setTitleColor:kHexColor(@"#0848DF") forState:UIControlStateNormal];
    [self.howButton addTarget:self action:@selector(backUpWalletIntroduce) forControlEvents:UIControlEventTouchUpInside];
    [self.howButton setBackgroundColor:kClearColor forState:UIControlStateNormal];
    [self.view addSubview:self.howButton];
    [self.howButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buildButton.mas_bottom).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.height.equalTo(@45);
        
    }];
//    self.bottomLable = [[UILabel alloc] init];
//    [self.view addSubview:self.bottomLable];
//    self.bottomLable.font  = [UIFont systemFontOfSize:16];
//    self.bottomLable.numberOfLines = 0;
//    self.bottomLable.textColor = kTextColor2;
//    self.bottomLable.text = [LangSwitcher switchLang:@"建议备份完成后立即恢复一次,  以确保安全,   然后尝试转入,  转出小额资产开始使用"key:nil];
//
//    [self.bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.buildButton.mas_bottom).offset(15);
//        make.left.equalTo(@15);
//        make.right.equalTo(@-15);
//
//    }];
    
//    self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
//    NSString *text2 = [LangSwitcher switchLang:@"导入钱包" key:nil];
//    [self.importButton setTitle:text2 forState:UIControlStateNormal];
//    self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];
//
//    [self.importButton setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
//    [self.importButton addTarget:self action:@selector(importWallet) forControlEvents:UIControlEventTouchUpInside];
//    [self.importButton setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
//    self.importButton.layer.borderColor = (kAppCustomMainColor.CGColor);
//    self.importButton.layer.borderWidth = 1;
//    self.importButton.clipsToBounds = YES;
//    [self.view addSubview:self.importButton];
//    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.buildButton.mas_bottom).offset(30);
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.height.equalTo(@50);
//
//    }];
    

    
    
}

- (void)buildBackUpWallet
{
    //点击备份钱包 生成助记词
    BuildBackUpVC *backUpVC = [BuildBackUpVC new];
    backUpVC.pwd = self.PWD;
    backUpVC.name = self.name;
//    NSString *word  =[[NSUserDefaults standardUserDefaults] objectForKey:KWalletWord];
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *word;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAWallet where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            word = [set stringForColumn:@"Mnemonics"];
            
        }
        [set close];
    }
    [dataBase.dataBase close];
    if (word.length > 0) {
        self.mnemonics = word;
//        self.mnemonics = @"marine lazy bind fun panther broken warfare tower captain blouse wet lazy";
        backUpVC.mnemonics = self.mnemonics;

    }else{
    self.mnemonics = [MnemonicUtil getGenerateMnemonics];
    
    NSArray *words = [self.mnemonics componentsSeparatedByString:@" "];
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < [words count]; i++){
        
        if ([categoryArray containsObject:[words objectAtIndex:i]] == NO){
            
            [categoryArray addObject:[words objectAtIndex:i]];
            
        }
        
        
        
    }
    if (categoryArray.count < 12) {
        self.mnemonics = [MnemonicUtil getGenerateMnemonics];
        NSArray *words = [self.mnemonics componentsSeparatedByString:@" "];
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        
        for (unsigned i = 0; i < [words count]; i++){
            
            if ([categoryArray containsObject:[words objectAtIndex:i]] == NO){
                
                [categoryArray addObject:[words objectAtIndex:i]];
                
            }
            
            
            
        }
    }
    if (categoryArray.count < 12) {
        [self buildBackUpWallet];
     }
        backUpVC.mnemonics = [categoryArray componentsJoinedByString:@" "];

    }
//    self.bottomNames = [NSMutableArray array];
    backUpVC.isCopy = self.isCopy;
    [self.navigationController pushViewController:backUpVC animated:YES];
    
//    TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:backUpVC];
//    [UIApplication sharedApplication].keyWindow.rootViewController = na;

}

- (void)backUpWalletIntroduce
{
    
    
    
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
