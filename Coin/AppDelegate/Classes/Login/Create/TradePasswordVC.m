//
//  TradePasswordVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/16.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TradePasswordVC.h"
#import "ImportWalletVC.h"
#import "CreateWalletVC.h"
#import "WhetherBackupVC.h"
@interface TradePasswordVC ()

@property (nonatomic , strong)UITextField *passWord;
@property (nonatomic , strong)UITextField *conPassWord;

@end

@implementation TradePasswordVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"设置交易密码" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    
    [self initView];
}

-(void)initView
{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:passwordView];
    
    NSArray *passWordArray = @[[LangSwitcher switchLang:@"输入交易密码" key:nil],[LangSwitcher switchLang:@"确认交易密码" key:nil]];
    NSArray *placArray = @[[LangSwitcher switchLang:@"请输入交易密码" key:nil],[LangSwitcher switchLang:@"请确认交易密码" key:nil]];
    
    for (int i = 0; i < 2; i ++) {
        UILabel *passWordLbl = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + i % 2 * 108, SCREEN_WIDTH - 70, 16) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(16) textColor:kWhiteColor];
        passWordLbl.text = passWordArray[i];
        [passwordView addSubview:passWordLbl];
        
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, passWordLbl.yy + 21 - 1.5, 10, 15)];
        iconImage.image = kImage(@"安全组拷贝");
        [passwordView addSubview:iconImage];
        
        UITextField *passWordFid = [[UITextField alloc]initWithFrame:CGRectMake(iconImage.xx + 15, passWordLbl.yy + 21 - 1.5, SCREEN_WIDTH - iconImage.xx - 40 , 15)];
        passWordFid.placeholder = placArray[i];
        passWordFid.secureTextEntry = YES;
        [passWordFid setValue:FONT(12) forKeyPath:@"_placeholderLabel.font"];
        passWordFid.font = FONT(12);
        passWordFid.textColor = [UIColor whiteColor];
        [passWordFid setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
        passWordFid.clearsOnBeginEditing = NO;
        passWordFid.clearButtonMode = UITextFieldViewModeWhileEditing;
        [passwordView addSubview:passWordFid];
        
        if (i == 0) {
            _passWord = passWordFid;
        }else
        {
            _conPassWord = passWordFid;
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(35, passWordFid.yy + 8.5, SCREEN_WIDTH - 70, 1)];
        lineView.backgroundColor = kLineColor;
        [passwordView addSubview:lineView];
        
        if (i == 0) {
            UILabel *label = [UILabel labelWithFrame:CGRectMake(passWordFid.x, lineView.yy + 5, SCREEN_WIDTH - passWordFid.x, 10) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(10) textColor:kHexColor(@"d6d5d5")];
            label.text = [LangSwitcher switchLang:@"密码为6位以上数字或字母" key:nil];
            [passwordView addSubview:label];
        }
        
        
    }
    
    
    UILabel *note = [UILabel labelWithFrame:CGRectMake(35, 160 - 64 + kNavigationBarHeight + 108 * 2 - 40, 0, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    note.text = [LangSwitcher switchLang:@"注：" key:nil];
    [note sizeToFit];
    [passwordView addSubview:note];
    
    NSArray *securityArray = @[[LangSwitcher switchLang:@"密码，用户解锁全币和法币" key:nil],[LangSwitcher switchLang:@"交易密码为本地密码，请妥善保管，丢失将无法找回" key:nil],[LangSwitcher switchLang:@"可退货删除钱包重新导入助记词设置新密码" key:nil]];
    
    for (int i = 0; i < 3; i ++) {
        UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(note.xx, note.yy + 8 + i%3 * 20, 4, 4)];
        pointView.backgroundColor = kWhiteColor;
        kViewRadius(pointView, 2);
        [passwordView addSubview:pointView];
        
        UILabel *securityLbl = [UILabel labelWithFrame:CGRectMake(pointView.xx + 6, pointView.y - 4, SCREEN_WIDTH - pointView.xx - 6 - 10, 12) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
        securityLbl.text = securityArray[i];
        securityLbl.tag = 200 + i;
        [passwordView addSubview:securityLbl];
    }
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, 160 - 64 + kNavigationBarHeight + 108 * 2 - 40 + 100, 50, 50);
    [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [passwordView addSubview:confirmBtn];
}


-(void)nextBtn
{
    if (![_passWord.text isPhoneNum]) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入交易密码" key:nil]];
        return;
    }
    if (![_conPassWord.text isPhoneNum]) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请确认交易密码" key:nil]];
        return;
    }
    if (![_conPassWord.text isEqualToString:_passWord.text]) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码不一致" key:nil]];
        return;
    }
    if (_passWord.text.length < 6) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"密码至少为6位以上的数字或字母" key:nil]];
        return;
    }
    
    
    if ([_state isEqualToString:@"1"]) {
        
        NSString *mnemonics = [MnemonicUtil getGenerateMnemonics];
        
        NSArray *words = [mnemonics componentsSeparatedByString:@" "];
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        
        for (unsigned i = 0; i < [words count]; i++){
            
            if ([categoryArray containsObject:[words objectAtIndex:i]] == NO){
                
                [categoryArray addObject:[words objectAtIndex:i]];
                
            }
        }
        
        
        
        [[NSUserDefaults standardUserDefaults]setObject:categoryArray forKey:MNEMONIC];
        WhetherBackupVC *vc = [WhetherBackupVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else
    {
        ImportWalletVC *vc = [ImportWalletVC new];
        [self.navigationController pushViewController:vc animated:YES];
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
