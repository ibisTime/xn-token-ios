//
//  WalletImportVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletImportVC.h"
#import "Masonry.h"
#import "UILabel+Extension.h"
#import "UILable+convience.h"
#import "TLTextView.h"
#import "TLAlert.h"
#import "RevisePassWordVC.h"
#import "MnemonicUtil.h"
#import "TLTextField.h"
#import "CaptchaView.h"
#import "WalletNewFeaturesVC.h"
#define ACCOUNT_HEIGHT 55;

@interface WalletImportVC ()<UITextViewDelegate>
@property (nonatomic ,strong) UILabel *nameLable;

@property (nonatomic ,strong) TLTextView *textView;
@property (nonatomic ,strong) UIButton *importButton;
@property (nonatomic ,strong) NSArray *wordArray;
@property (nonatomic ,strong) NSMutableArray *tempArray;
@property (nonatomic ,strong) NSMutableArray *UserWordArray;

@property (nonatomic ,strong) NSMutableArray *wordTempArray;
@property (nonatomic ,strong) NSArray *userTempArray;

@property (nonatomic,strong) TLTextField *phoneTf;

@property (nonatomic,strong) TLTextField *pwdTf;

@property (nonatomic,strong) TLTextField *rePwdTf;

@property (nonatomic, strong) CaptchaView *captchaView;

@property (nonatomic,strong) TLTextField *nameTf;

@property (nonatomic,strong) TLTextField *introduceTf;

@property (nonatomic ,strong) UIButton *introduceButton;

@end

@implementation WalletImportVC

- (void)viewDidLoad {
    self.title = [LangSwitcher switchLang:@"导入钱包" key:nil];
    self.view.backgroundColor = kWhiteColor;
//    NSString *word = [[NSUserDefaults standardUserDefaults] objectForKey:KWalletWord];
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
    //验证
    self.userTempArray = [word componentsSeparatedByString:@" "];
    self.wordTempArray = [NSMutableArray array];
    
    for (NSString *str in self.userTempArray) {
        if ([str  isEqual: @""]) {
            //
        }else{
            
            [self.wordTempArray addObject:str];
        }
    }
    NSLog(@"%@",self.tempArray);
    self.UserWordArray = self.wordTempArray;
    [self initSub];
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)initSub
{
    self.nameLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [self.view addSubview:self.nameLable];
    TLTextView *textView = [[TLTextView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 150)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
    [textView addGestureRecognizer:tap];
    self.textView = textView;
    textView.backgroundColor = kWhiteColor;
    textView.textColor = kTextColor;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placholder = [LangSwitcher switchLang:@"助记词,按空格分离" key:nil];
    [self.view addSubview:self.textView];
    CGFloat margin = 15;
    CGFloat w = kScreenWidth - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    
    CGFloat btnMargin = 15;
    TLTextField *pwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, textView.yy+5, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:20 placeholder:[LangSwitcher switchLang:@"请输入密码" key:nil]];
    pwdTf.secureTextEntry = YES;
    
    [self.view addSubview:pwdTf];
    self.pwdTf = pwdTf;
    UIView *phone3 = [[UIView alloc] init];
    [self.view addSubview:phone3];
    phone3.backgroundColor = kLineColor;
    phone3.frame = CGRectMake(margin*2, pwdTf.yy, w-30, 1);
    //re密码
    //    UILabel *pLab = [UILabel labelWithTitle:[LangSwitcher switchLang:@"密码" key:nil] frame:CGRectMake(20, pwdTf.yy, w, 22)];
    //    pLab.font = [UIFont systemFontOfSize:14];
    //    pLab.textAlignment = NSTextAlignmentLeft;
    //    pLab.textColor = kTextColor;
    //    [self.view addSubview:pLab];
    TLTextField *rePwdTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, pwdTf.yy + 1, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:20 placeholder:[LangSwitcher switchLang:@"请输入重复密码" key:nil]];
    rePwdTf.secureTextEntry = YES;
    [self.view addSubview:rePwdTf];
    self.rePwdTf = rePwdTf;
    UIView *phone4 = [[UIView alloc] init];
    [self.view addSubview:phone4];
    phone4.backgroundColor = kLineColor;
    phone4.frame = CGRectMake(margin*2, rePwdTf.yy, w-30, 1);
    
    TLTextField *introduceTf = [[TLTextField alloc] initWithFrame:CGRectMake(margin, rePwdTf.yy + 1, w, h) leftTitle:[LangSwitcher switchLang:@"" key:nil] titleWidth:20 placeholder:[LangSwitcher switchLang:@"提示信息" key:nil]];
    //    introduceTf.secureTextEntry = YES;
    [self.view addSubview:introduceTf];
    self.introduceTf = introduceTf;
    UIView *phone5 = [[UIView alloc] init];
    [self.view addSubview:phone5];
    phone5.backgroundColor = kLineColor;
    phone5.frame = CGRectMake(margin*2, introduceTf.yy, w-30, 1);
    
    
    
    self.introduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.introduceButton];
    NSString *text3 =  [LangSwitcher switchLang:@"我已阅读并同意服务及隐私条款" key:nil];
    [self.introduceButton setImage:kImage(@"打勾 圆") forState:UIControlStateNormal];
    
    [self.introduceButton setTitle:text3 forState:UIControlStateNormal];
    [self.introduceButton addTarget:self action:@selector(html5Wallet) forControlEvents:UIControlEventTouchUpInside];
    self.introduceButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.introduceButton setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.introduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introduceTf.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.equalTo(@(207));
        make.height.equalTo(@30);
        
    }];
    
    
//    self.nameLable.text = [LangSwitcher switchLang:@"请输入导入的钱包助记词 (12个英文单词)  , 按空格分离" key:nil];
//    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//    // 行间距设置为30
//    [paragraphStyle  setLineSpacing:10];
//
//    NSString  *testString = self.nameLable.text ;
//    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
//    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
//
//    // 设置Label要显示的text
//    [self.nameLable  setAttributedText:setString];
//    self.nameLable.numberOfLines = 0;
//
//    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(23);
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.right.equalTo(self.view.mas_right).offset(-15);
//
//    }];
   
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLable.mas_bottom).offset(28);
//        make.left.equalTo(@15);
//        make.right.equalTo(@-15);
//        make.height.equalTo(@245);
//
//    }];
    self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text2 = [LangSwitcher switchLang:@"立即导入" key:nil];
    [self.importButton setTitle:text2 forState:UIControlStateNormal];
    self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.importButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.importButton addTarget:self action:@selector(importNow) forControlEvents:UIControlEventTouchUpInside];
    [self.importButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    self.importButton.layer.borderColor = (kAppCustomMainColor.CGColor);
    self.importButton.layer.borderWidth = 1;
    self.importButton.clipsToBounds = YES;
    [self.view addSubview:self.importButton];
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introduceButton.mas_bottom).offset(26);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@50);
        
    }];
    
    self.introduceButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text4 = [LangSwitcher switchLang:@"什么是助记词" key:nil];
    [self.introduceButton setTitle:text4 forState:UIControlStateNormal];
    self.introduceButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.introduceButton setTitleColor:kHexColor(@"#007AFF") forState:UIControlStateNormal];
    [self.introduceButton addTarget:self action:@selector(importNow) forControlEvents:UIControlEventTouchUpInside];
    [self.introduceButton setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
//    self.introduceButton.layer.borderColor = (kAppCustomMainColor.CGColor);
//    self.introduceButton.layer.borderWidth = 1;
//    self.introduceButton.clipsToBounds = YES;
    [self.view addSubview:self.introduceButton];
    [self.introduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.importButton.mas_bottom).offset(26);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@50);
        
    }];
    
}
- (void)importNow
{
    
//    NSString *pwd = [self.FirstPSWArray componentsJoinedByString:@""];
//    //            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:KUserPwd];
//    //导入钱包交易密码
//    NSString *name;
//    TLDataBase *db = [TLDataBase sharedManager];
//    if ([db.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"UPDATE THAWallet SET PwdKey = '%@' WHERE userId = '%@'",pwd,[TLUser user].userId];
//        BOOL sucess = [db.dataBase executeUpdate:sql];
//
//        NSLog(@"导入钱包交易密码%d",sucess);
//    }
//    [db.dataBase close];
//    //
    
    //            [[NSUserDefaults standardUserDefaults] synchronize];
    WalletNewFeaturesVC *newVC = [WalletNewFeaturesVC new];
    [UIApplication sharedApplication].keyWindow.rootViewController = newVC;
    
    //验证
    self.wordArray = [NSArray array];
    self.wordArray = [self.textView.text componentsSeparatedByString:@" "];
    self.tempArray = [NSMutableArray array];

    for (NSString *str in self.wordArray) {
        if ([str  isEqual: @""]) {
//
        }else{
            
            [self.tempArray addObject:str];
        }
    }
    NSLog(@"%@",self.tempArray);
    if (self.tempArray.count >= 12) {
      
    }
//    NSString *result = [MnemonicUtil getMnemonicsISRight:self.textView.text];
    if ([[MnemonicUtil getMnemonicsISRight:self.textView.text] isEqualToString:@"1"]  ) {
        NSString *word = self.textView.text;
//        NSString *word = @"ef3274ded22bc98d372e816613d9544aab4caaa181e0ba1df7643d1552d35c51";
        NSArray *wordsArray = [self.textView.text componentsSeparatedByString:@" "];
        word = [wordsArray componentsJoinedByString:@" "];

        NSString *prikey   =[MnemonicUtil getPrivateKeyWithMnemonics:word];
        
        NSString *address = [MnemonicUtil getAddressWithPrivateKey:prikey];
        
        //储存用户导入的钱包
        //1 查询本地是否存储已创建的钱包
        TLDataBase *dataBase = [TLDataBase sharedManager];
        NSString *Mnemonics;
        if ([dataBase.dataBase open]) {
            NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAWallet where userId = '%@'",[TLUser user].userId];
            //        [sql appendString:[TLUser user].userId];
            FMResultSet *set = [dataBase.dataBase executeQuery:sql];
            while ([set next])
            {
                Mnemonics = [set stringForColumn:@"Mnemonics"];
                
            }
            [set close];
        }
        [dataBase.dataBase close];
        
        if (Mnemonics.length > 0) {
            //验证正确
            RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
            vc.IsImport = YES;
            [self.navigationController pushViewController:vc animated:YES];
            [TLAlert alertWithMsg:[LangSwitcher switchLang:@"导入成功" key:nil]];
        }else{
            
            //储存导入的钱包
            TLDataBase *dateBase = [TLDataBase sharedManager];
            if ([dateBase.dataBase open]) {
                BOOL sucess = [dateBase.dataBase executeUpdate:@"insert into THAWallet(userId,Mnemonics,wanAddress,wanPrivate,ethPrivate,ethAddress,PwdKey) values(?,?,?,?,?,?,?)",[TLUser user].userId,word,address,prikey,prikey,address,self.pwdTf.text];
                
                NSLog(@"导入地址私钥%d",sucess);
            }
            [dateBase.dataBase close];
            RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
            vc.IsImport = YES;
            [self.navigationController pushViewController:vc animated:YES];
            [TLAlert alertWithMsg:[LangSwitcher switchLang:@"导入成功" key:nil]];
        }
        
//        [[NSUserDefaults standardUserDefaults] setObject:word forKey:KWalletWord];
//
//
//        [[NSUserDefaults standardUserDefaults] setObject:prikey forKey:KWalletPrivateKey];
//        [[NSUserDefaults standardUserDefaults] setObject:address forKey:KWalletAddress];
//        [[NSUserDefaults standardUserDefaults] synchronize];
       

        //设置交易密码
    }else{
        
//        NSString *str = [MnemonicUtil getPrivateKeyWithMnemonics:self.textView.text];

       
        //验证失败
//        [self.navigationController pushViewController:vc animated:YES];
//
//       NSString *str = [MnemonicUtil getPrivateKeyWithMnemonics:self.textView.text];
//        NSLog(@"%@",str);
//        [TLAlert alertWithMsg:@"助记词验证成功"];
        [TLAlert alertWithMsg:@"助记词不存在,请检测备份"];
        self.importButton.selected = NO;
        return;

//        RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
//        vc.IsImport = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}
- (void)beginEdit
{
    
    [self.view endEditing:YES];
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CoinWeakSelf;
    　　if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        if (self.walletBlock) {
            self.walletBlock();
        }
        　　　　NSLog(@"clicked navigationbar back button");
        　　}
    
}

@end
