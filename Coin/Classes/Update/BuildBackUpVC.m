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
#import "CustomLayoutWallet.h"
#import "MnemonicUtil.h"
#import "CurrencyTitleModel.h"
@interface BuildBackUpVC ()<addCollectionViewDelegate>
@property (nonatomic ,strong) UILabel *nameLable;

@property (nonatomic ,strong) UILabel *contentLable;

@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,strong) UIButton *nextButton;

@property (nonatomic ,strong) QHCollectionViewNine *bottomView;

@property (nonatomic ,strong) CurrencyTitleModel *titleModel;

@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *> *bottomNames;

@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *> *tempNames;


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
    NSArray *words = [self.mnemonics componentsSeparatedByString:@" "];
    
    NSArray *tempArr = words.mutableCopy;

    self.bottomNames = [NSMutableArray array];
    
    for (int i = 0; i < tempArr.count; i++) {
     CurrencyTitleModel *title =  [[CurrencyTitleModel alloc] init];
        title.symbol = words[i];
        title.IsSelect = YES;

        [self.bottomNames addObject:title];
    }
    
    self.bottomView.titles = self.bottomNames;
    NSMutableArray *tpArray = [NSMutableArray array];
    for (int i = 0; i < self.bottomNames.count; i++) {
        [tpArray addObject:self.bottomNames[i].symbol];
    }
    
    
    [self.bottomView reloadData];
    
}
- (void)initColllention
{
    CustomLayoutWallet *layout = [[CustomLayoutWallet alloc] init];
//    layout.itemSize = CGSizeMake(80, 30);
    layout.minimumLineSpacing = 10.0; // 竖
//    layout.minimumInteritemSpacing = 10.0; // 横
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, , 10);
    UIImage *image1 = [UIImage imageNamed:@"bch"];
    UIImage *image2 = [UIImage imageNamed:@"eth"];
    UIImage *image3 = [UIImage imageNamed:@"ltc"];
    NSArray *array = @[image2, image2, image3, image2, image3, image1, image3, image1, image1];
    QHCollectionViewNine *bottomView = [[QHCollectionViewNine alloc] initWithFrame:CGRectMake(15, 150, kScreenWidth-30, 173) collectionViewLayout:layout withImage:array];
    self.bottomView = bottomView;
    bottomView.refreshDelegate = self;
    self.bottomView.type = SearchTypeTop;
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
    
    
    
    NSArray *tempArr = self.bottomNames;
    
    self.tempNames = [NSMutableArray array];
    
    for (int i = 0; i < self.bottomNames.count; i++) {
        CurrencyTitleModel *title = tempArr[i];
        title.IsSelect = NO;
        
        [self.tempNames addObject:title];
    }
    
//    self.bottomView.titles = self.bottomNames;
    //验证助记词
    BuildCheckVC *checkVC= [[BuildCheckVC alloc] init];
    checkVC.pwd = self.pwd;
//    checkVC.view.backgroundColor = kClearColor;
    checkVC.isCopy = self.isCopy;
//    self.mnemonics =  [MnemonicUtil getGenerateMnemonics];
    NSArray *words = [self.mnemonics componentsSeparatedByString:@" "];
    
    NSArray *tmpArr = words.mutableCopy;
    
    self.bottomNames = [NSMutableArray array];
    
    for (int i = 0; i < tmpArr.count; i++) {
        CurrencyTitleModel *title =  [[CurrencyTitleModel alloc] init];
        title.symbol = words[i];
        title.IsSelect = NO;
        
        [self.bottomNames addObject:title];
    }
    
    self.bottomView.titles = self.bottomNames;
//    NSMutableArray *tpArray = [NSMutableArray array];
//    for (int i = 0; i < self.bottomNames.count; i++) {
//        [tpArray addObject:self.bottomNames[i].symbol];
//    }
//
//    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
//
//    for (unsigned i = 0; i < [self.bottomNames count]; i++){
//
//        if ([tpArray containsObject:[self.bottomNames objectAtIndex:i].symbol] == NO){
//
//            [categoryArray addObject:[self.bottomNames objectAtIndex:i]];
//
//        }
//
//
//
//    }
//    if (categoryArray.count == 11) {
//        self.mnemonics = [MnemonicUtil getGenerateMnemonics];
//        NSArray *words = [self.mnemonics componentsSeparatedByString:@" "];
//
//        NSArray *tmpArr = words.mutableCopy;
//
//        self.bottomNames = [NSMutableArray array];
//
//        for (int i = 0; i < tmpArr.count; i++) {
//            CurrencyTitleModel *title =  [[CurrencyTitleModel alloc] init];
//            title.symbol = words[i];
//            title.IsSelect = NO;
//
//            [self.bottomNames addObject:title];
//        }
//    }
    checkVC.userTitles = self.bottomNames.mutableCopy;
    NSArray *result = [self.bottomNames sortedArrayUsingComparator:^NSComparisonResult( CurrencyTitleModel* obj1,  CurrencyTitleModel* obj2) {
        
        NSLog(@"%@~%@",obj1,obj2);
        
        //乱序
        
        if (arc4random_uniform(2) == 0) {
            
            return [obj2.symbol compare:obj1.symbol]; //降序
            
        }
        
        else{
            
            return [obj1.symbol compare:obj2.symbol]; //升序
            
        }
        
    }];
    
    
    NSLog(@"result=%@",result);
    self.bottomNames = [NSMutableArray arrayWithArray:result];
    
    checkVC.bottomtitles = self.bottomNames;
    
    
    checkVC.titleWord = self.mnemonics;
    
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
