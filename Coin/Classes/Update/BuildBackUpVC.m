//
//  BuildBackUpVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/8.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "BuildBackUpVC.h"
#import "TLAlert.h"
#import "QHCollectionViewNine.h"
#import "CurrencyTitleModel.h"
#import "BuildCheckVC.h"
@interface BuildBackUpVC ()<addCollectionViewDelegate>
@property (nonatomic ,strong) UILabel *nameLable;

@property (nonatomic ,strong) UILabel *contentLable;

@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,strong) UIButton *nextButton;

@property (nonatomic ,strong) QHCollectionViewNine *bottomView;

@property (nonatomic ,strong) CurrencyTitleModel *titleModel;

@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *> *bottomNames;

@property (nonatomic, strong) NSMutableArray  *walletWords;

@end

@implementation BuildBackUpVC

- (void)viewDidLoad {
    self.title = [LangSwitcher switchLang:@"钱包备份" key:nil];
//    [self.navigationController.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    [self initWalletUI];
    [self inititem];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)inititem
{
    
    self.bottomNames = [NSMutableArray array];
    
        CurrencyTitleModel *titleMode = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode1 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode2 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode3 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode4 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode5 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode6 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode7 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode8 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode9 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode10 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode11 = [CurrencyTitleModel new];
        CurrencyTitleModel *titleMode12 = [CurrencyTitleModel new];

        titleMode.symbol = @"terrstes";
        titleMode1.symbol = @"testww";
        titleMode2.symbol = @"testetes";
        titleMode3.symbol = @"teste";
        titleMode4.symbol = @"testw";
        titleMode5.symbol = @"testeee";
        titleMode6.symbol = @"teswwt";
        titleMode7.symbol = @"testeteste";
        titleMode8.symbol = @"tereer";
        titleMode9.symbol = @"tesw";
        titleMode10.symbol = @"teseeet";
        titleMode11.symbol = @"teeestw";
        titleMode12.symbol = @"tesr";

    

        titleMode.IsSelect = NO;
        titleMode1.IsSelect = NO;
        titleMode2.IsSelect = NO;
        titleMode3.IsSelect = NO;
        titleMode4.IsSelect = NO;
        titleMode5.IsSelect = NO;
        titleMode6.IsSelect = NO;
        titleMode7.IsSelect = NO;
        titleMode8.IsSelect = NO;
        titleMode9.IsSelect = NO;
        titleMode10.IsSelect = NO;
        titleMode11.IsSelect = NO;
        titleMode12.IsSelect = NO;
        [self.bottomNames addObject:titleMode];
        [self.bottomNames addObject:titleMode1];
        [self.bottomNames addObject:titleMode2];
        [self.bottomNames addObject:titleMode3];
        [self.bottomNames addObject:titleMode4];
        [self.bottomNames addObject:titleMode5];
        [self.bottomNames addObject:titleMode6];
        [self.bottomNames addObject:titleMode7];
        [self.bottomNames addObject:titleMode8];
        [self.bottomNames addObject:titleMode9];
        [self.bottomNames addObject:titleMode10];
        [self.bottomNames addObject:titleMode11];
        [self.bottomNames addObject:titleMode12];
    
    self.bottomView.bottomtitles = self.bottomNames;
    
    
    
    NSString *text = [self.bottomNames componentsJoinedByString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:text forKey:KWalletWord];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.bottomView reloadData];
    
}
- (void)initColllention
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(80, 30);
    layout.minimumLineSpacing = 15.0; // 竖
    layout.minimumInteritemSpacing = 5.0; // 横
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *image1 = [UIImage imageNamed:@"bch"];
    UIImage *image2 = [UIImage imageNamed:@"eth"];
    UIImage *image3 = [UIImage imageNamed:@"ltc"];
    NSArray *array = @[image2, image2, image3, image2, image3, image1, image3, image1, image1];
    QHCollectionViewNine *bottomView = [[QHCollectionViewNine alloc] initWithFrame:CGRectMake(15, 150, kScreenWidth-30, 173) collectionViewLayout:layout withImage:array];
    self.bottomView = bottomView;
    bottomView.refreshDelegate = self;
    self.bottomView.type = SearchTypeBottom;
    [self.view addSubview:bottomView];
    
    bottomView.layer.cornerRadius = 6;
    bottomView.clipsToBounds = YES;
    bottomView.backgroundColor = kHexColor(@"#2a323e");
}
- (void)initWalletUI
{
    self.view.backgroundColor = kWhiteColor;
    self.nameLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [self.view addSubview:self.nameLable];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.text = [LangSwitcher switchLang:@"请记下您的钱包助词并保存到安全的地方" key:nil];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(30);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    self.contentLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    self.contentLable.numberOfLines = 0;
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [self.view addSubview:self.contentLable];
    self.contentLable.textAlignment = NSTextAlignmentLeft;
    self.contentLable.text = [LangSwitcher switchLang:@"钱包助词用于恢复钱包资产,拥有助记词即可完全控制钱包资产,请务必妥善保管,丢失助记词既丢失钱包资产。无法提供找回功能" key:nil];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(19);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    [self initColllention];

   
    
    
    self.nextButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text = [LangSwitcher switchLang:@"下一步" key:nil];
    [self.nextButton setTitle:text forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.nextButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(buildBackUpWallet) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@45);
        
    }];
}

-(void)buildBackUpWallet
{
    
    //验证助记词
    BuildCheckVC *checkVC= [[BuildCheckVC alloc] init];
    
    checkVC.bottomtitles = self.bottomNames;
    
    [self.navigationController pushViewController:checkVC animated:YES];
    
    
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
