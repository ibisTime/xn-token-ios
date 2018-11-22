//
//  ImportWalletVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/16.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "ImportWalletVC.h"
#import "TLTabBarController.h"
@interface ImportWalletVC ()<UITextFieldDelegate>

@end

@implementation ImportWalletVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void)initView
{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(13, 175/2 - 64 + kNavigationBarHeight, SCREEN_WIDTH - 26, 20) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:HGboldfont(20) textColor:kWhiteColor];
    nameLabel.text = [LangSwitcher switchLang:@"恢复助记词钱包" key:nil];
    [backImage addSubview:nameLabel];
    
    UILabel *introduceLbl = [UILabel labelWithFrame:CGRectMake(13, 175/2 - 64 + kNavigationBarHeight + 40, SCREEN_WIDTH - 26, 0) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    introduceLbl.numberOfLines = 0;
    introduceLbl.attributedText = [UserModel ReturnsTheDistanceBetween:[LangSwitcher switchLang:@"请在下方表格中输入12个助记词以恢复钱包，在每个助记词输入完成后按“空格”键可以跳转到下个单词" key:nil]];
    [introduceLbl sizeToFit];
    [backImage addSubview:introduceLbl];
    
    for (int i = 0; i < 12; i ++) {
        UITextField *textFid = [[UITextField alloc]initWithFrame:CGRectMake(13  + i%3 * ((SCREEN_WIDTH - 41 )/3 + 7.5), - kNavigationBarHeight + introduceLbl.yy + 48 + i/3* (52), (SCREEN_WIDTH - 41)/3, 45)];
        textFid.font = FONT(14);
        if (i == 0) {
            [textFid becomeFirstResponder];
        }
        textFid.keyboardType = UIKeyboardTypeDefault;
        textFid.textColor = kWhiteColor;
        textFid.delegate = self;
        textFid.textAlignment = NSTextAlignmentCenter;
        kViewBorderRadius(textFid, 8, 1, kWhiteColor);
        textFid.tag = 100 + i;
        [self.view addSubview:textFid];
    }
    
    UITextField *textField = [self.view viewWithTag:111];

    
    UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"开始恢复" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:18];
    confirmBtn.frame = CGRectMake(35, textField.yy + 62, SCREEN_WIDTH - 70, 50);
    kViewRadius(confirmBtn, 10);
    [confirmBtn setBackgroundImage:kImage(@"矩形5-1") forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(BtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:confirmBtn];
}

-(void)BtnClick
{
    UITextField *textField1 = [self.view viewWithTag:100];
    UITextField *textField2 = [self.view viewWithTag:101];
    UITextField *textField3 = [self.view viewWithTag:102];
    UITextField *textField4 = [self.view viewWithTag:103];
    UITextField *textField5 = [self.view viewWithTag:104];
    UITextField *textField6 = [self.view viewWithTag:105];
    UITextField *textField7 = [self.view viewWithTag:106];
    UITextField *textField8 = [self.view viewWithTag:107];
    UITextField *textField9 = [self.view viewWithTag:108];
    UITextField *textField10 = [self.view viewWithTag:109];
    UITextField *textField11 = [self.view viewWithTag:110];
    UITextField *textField12 = [self.view viewWithTag:111];
    
    if ([textField1.text isEqualToString:@""] ||
        [textField2.text isEqualToString:@""] ||
        [textField3.text isEqualToString:@""] ||
        [textField4.text isEqualToString:@""] ||
        [textField5.text isEqualToString:@""] ||
        [textField6.text isEqualToString:@""] ||
        [textField7.text isEqualToString:@""] ||
        [textField8.text isEqualToString:@""] ||
        [textField9.text isEqualToString:@""] ||
        [textField10.text isEqualToString:@""] ||
        [textField11.text isEqualToString:@""] ||
        [textField12.text isEqualToString:@""]
        ) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"助记词不能为空" key:nil]];
        return;
    }
    NSString *mnemonic = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@",
                          [textField1.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField2.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField3.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField4.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField5.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField6.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField7.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField8.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField9.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField10.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField11.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          [textField12.text stringByReplacingOccurrencesOfString:@" " withString:@""]
                          ];
    if ([[MnemonicUtil getMnemonicsISRight:mnemonic] isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults]setObject:[mnemonic componentsSeparatedByString:@","] forKey:MNEMONIC];
        TLTabBarController *tab = [[TLTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    }else
    {
        [TLAlert alertWithMsg:@"助记词不存在,请检测备份"];
//        self.importButton.selected = NO;
    }
    

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        if (textField.tag != 111) {
            UITextField *textFid = [self.view viewWithTag:textField.tag + 1];
            [textFid becomeFirstResponder];
        }
        return NO;
    }
    return YES;
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