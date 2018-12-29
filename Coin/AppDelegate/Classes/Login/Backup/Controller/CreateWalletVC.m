//
//  CreateWalletVC.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/16.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "CreateWalletVC.h"
#import "BackupPromptView.h"
#import "BackupWalletMnemonicVC.h"
@interface CreateWalletVC ()<UIScrollViewDelegate>
{
    NSInteger w;
}
@property (nonatomic , strong)UIScrollView *scrollView;

@property (nonatomic , strong)NSArray *mnemonicsArray;

@end

@implementation CreateWalletVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTransparentClearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC] componentsSeparatedByString:@" "];
    self.mnemonicsArray = [[[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC] componentsSeparatedByString:@" "];
    // Do any additional setup after loading the view.
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    BackupPromptView *promptView = [[BackupPromptView alloc]initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, 0)];
    kViewRadius(promptView , 10);
    promptView.backgroundColor = kWhiteColor;
    [promptView.IKonwBtn addTarget:self action:@selector(IKonwBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:promptView];
    
    
    promptView.frame = CGRectMake(50, SCREEN_HEIGHT/2 - (promptView.ownershipLbl.yy + 30)/2, SCREEN_WIDTH - 100, promptView.ownershipLbl.yy + 30);
    [[UserModel user] showPopAnimationWithAnimationStyle:1 showView:promptView];
    
    
    [self initView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    w = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    //禁止左划
    static float newx = 0;
    static float oldx = 0;
    newx= scrollView.contentOffset.x ;
    if (newx > oldx) {
        scrollView.scrollEnabled = NO;
        scrollView.scrollEnabled = YES;
    }
    oldx = newx;
}


#pragma mark -- 下一步
-(void)nextBtn
{
    w ++;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * w, 0) animated:YES];
}

-(void)IKonwBtnClick
{
    [[UserModel user].cusPopView dismiss];
}

-(void)confirmBtn
{
    BackupWalletMnemonicVC *vc = [BackupWalletMnemonicVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initView
{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = kImage(@"起始业背景");
    [self.view addSubview:backImage];
    
    UILabel *nameLable = [[UILabel alloc]init];
    nameLable.text = [LangSwitcher switchLang:@"备份钱包助记词" key:nil];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = Font(16);
    nameLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLable;
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -kNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT + kStatusBarHeight)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
//    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    [self MnemonicFirstPage];
    [self MnemonicWordPageTwe];
    [self MnemonicWordPageThere];
}



-(void)MnemonicFirstPage
{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:backView];
    
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(10, kNavigationBarHeight + 40, SCREEN_WIDTH - 20, 20
                                                            ) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
    NSString *attStr = [LangSwitcher switchLang:@"请按顺序 " key:nil];
    NSString *str =[LangSwitcher switchLang:@"请按顺序 抄写下方四个助记词" key:nil];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSFontAttributeName value:HGboldfont(18) range:NSMakeRange(0, attStr.length)];
    nameLabel.attributedText = AttributedStr;
//    nameLabel.numberOfLines = 0;
//    [nameLabel sizeToFit];
    [backView addSubview:nameLabel];
    
    
    UILabel *totalLabel = [UILabel labelWithFrame:CGRectMake(0, nameLabel.yy + 13, SCREEN_WIDTH, 12) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    totalLabel.text = [NSString stringWithFormat:@"1/3%@",[LangSwitcher switchLang:@"(共三页)" key:nil]];
    [backView addSubview:totalLabel];
    
    for (int i = 0; i < 4; i ++) {
        UILabel *mnemonicLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2 - 75, totalLabel.yy + 30 + i%4*65 , 150, 50) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
        
        
        
        mnemonicLabel.text = self.mnemonicsArray[i];
        kViewBorderRadius(mnemonicLabel, 10, 1, kWhiteColor);
        [backView addSubview:mnemonicLabel];
        
        if (i == 3) {
            UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
            confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, mnemonicLabel.yy + 50, 50, 50);
            [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
            [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
            [backView addSubview:confirmBtn];
        }
    }
}


-(void)MnemonicWordPageTwe
{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:backView];
    
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(10, kNavigationBarHeight + 40, SCREEN_WIDTH - 20, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
    NSString *attStr = [LangSwitcher switchLang:@"请按顺序 " key:nil];
    NSString *str =[LangSwitcher switchLang:@"请按顺序 抄写下方四个助记词" key:nil];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSFontAttributeName value:HGboldfont(18) range:NSMakeRange(0, attStr.length)];
    nameLabel.attributedText = AttributedStr;
//    nameLabel.numberOfLines = 0;
//    [nameLabel sizeToFit];
    [backView addSubview:nameLabel];
    
    UILabel *totalLabel = [UILabel labelWithFrame:CGRectMake(0, nameLabel.yy + 13, SCREEN_WIDTH, 12) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    totalLabel.text = [NSString stringWithFormat:@"2/3%@",[LangSwitcher switchLang:@"(共三页)" key:nil]];
    [backView addSubview:totalLabel];
    
    for (int i = 0; i < 4; i ++) {
        UILabel *mnemonicLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2 - 75, totalLabel.yy + 30 + i%4*65 , 150, 50) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
        mnemonicLabel.text = self.mnemonicsArray[i + 4];
        kViewBorderRadius(mnemonicLabel, 10, 1, kWhiteColor);
        [backView addSubview:mnemonicLabel];
        
        if (i == 3) {
            UIButton *confirmBtn = [UIButton buttonWithTitle:@"" titleColor:kClearColor backgroundColor:kClearColor titleFont:0];
            confirmBtn.frame = CGRectMake(SCREEN_WIDTH - 85, mnemonicLabel.yy + 50, 50, 50);
            [confirmBtn setBackgroundImage:kImage(@"矩形3拷贝") forState:(UIControlStateNormal)];
            [confirmBtn addTarget:self action:@selector(nextBtn) forControlEvents:(UIControlEventTouchUpInside)];
            [backView addSubview:confirmBtn];
        }
    }
}


-(void)MnemonicWordPageThere{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:backView];
    
    
    UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(10, kNavigationBarHeight + 40, SCREEN_WIDTH - 20, 20) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
    NSString *attStr = [LangSwitcher switchLang:@"请按顺序 " key:nil];
    NSString *str =[LangSwitcher switchLang:@"请按顺序 抄写下方四个助记词" key:nil];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSFontAttributeName value:HGboldfont(18) range:NSMakeRange(0, attStr.length)];
    nameLabel.attributedText = AttributedStr;
//    nameLabel.numberOfLines = 0;
//    [nameLabel sizeToFit];
    [backView addSubview:nameLabel];
    
    
    UILabel *totalLabel = [UILabel labelWithFrame:CGRectMake(0, nameLabel.yy + 13, SCREEN_WIDTH, 12) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kWhiteColor];
    totalLabel.text = [NSString stringWithFormat:@"3/3%@",[LangSwitcher switchLang:@"(共三页)" key:nil]];
    [backView addSubview:totalLabel];
    
    for (int i = 0; i < 4; i ++) {
        UILabel *mnemonicLabel = [UILabel labelWithFrame:CGRectMake(SCREEN_WIDTH/2 - 75, totalLabel.yy + 30 + i%4*65 , 150, 50) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kWhiteColor];
        mnemonicLabel.text = self.mnemonicsArray[i + 8];;
        kViewBorderRadius(mnemonicLabel, 10, 1, kWhiteColor);
        [backView addSubview:mnemonicLabel];
        
        if (i == 3) {
            UIButton *confirmBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"完成" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:16];
            confirmBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 65, mnemonicLabel.yy + 35, 130, 50);
            kViewRadius(confirmBtn, 10);
            [confirmBtn setBackgroundImage:kImage(@"矩形5-1") forState:(UIControlStateNormal)];
            [confirmBtn addTarget:self action:@selector(confirmBtn) forControlEvents:(UIControlEventTouchUpInside)];
            [backView addSubview:confirmBtn];
        }
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
