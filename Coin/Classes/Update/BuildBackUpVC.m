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
@property (nonatomic ,strong) UIView *whiteView;

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
        title.IsSelect = NO;

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
    layout.minimumLineSpacing = 0.0; // 竖
    layout.minimumInteritemSpacing = 0.0; // 横
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, , 10);
    layout.itemSize = CGSizeMake((kWidth(kScreenWidth-60))/3, 45);
    UIImage *image1 = [UIImage imageNamed:@"bch"];
    UIImage *image2 = [UIImage imageNamed:@"eth"];
    UIImage *image3 = [UIImage imageNamed:@"ltc"];
    NSArray *array = @[image2, image2, image3, image2, image3, image1, image3, image1, image1];
    QHCollectionViewNine *bottomView = [[QHCollectionViewNine alloc] initWithFrame:CGRectMake(15, kHeight(253), (kWidth(kScreenWidth-60)), 220) collectionViewLayout:layout withImage:array];
    self.bottomView = bottomView;
    bottomView.isRead = YES;
    bottomView.refreshDelegate = self;
    self.bottomView.type = SearchTypeTop;
    [self.whiteView addSubview:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(kHeight(253)));
//        make.left.equalTo(self.whiteView.mas_left).offset(15);
//        make.right.equalTo(self.whiteView.mas_right).offset(-15);
//        make.height.equalTo(@(kHeight(175)));
//
//    }];
    
//    bottomView.layer.cornerRadius = 6;
//    bottomView.clipsToBounds = YES;
    bottomView.backgroundColor = kWhiteColor;
}

- (void)addBorderToLayer:(UIView *)view
{
    CAShapeLayer *border = [CAShapeLayer layer];
    //  线条颜色
    border.strokeColor = [UIColor lightGrayColor].CGColor;
    
    border.fillColor = nil;
    
    
    UIBezierPath *pat = [UIBezierPath bezierPath];
    [pat moveToPoint:CGPointMake(0, 0)];
    if (CGRectGetWidth(view.frame) > CGRectGetHeight(view.frame)) {
        [pat addLineToPoint:CGPointMake(view.bounds.size.width, 0)];
    }else{
        [pat addLineToPoint:CGPointMake(0, view.bounds.size.height)];
    }
    border.path = pat.CGPath;
    
    border.frame = view.bounds;
    
    // 不要设太大 不然看不出效果
    border.lineWidth = 0.5;
    border.lineCap = @"butt";
    
    //  第一个是 线条长度   第二个是间距    nil时为实线
    border.lineDashPattern = @[@6, @10];
    
    [view.layer addSublayer:border];
}


- (void)initWalletUI
{
    self.view.backgroundColor = kWhiteColor;
    
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
    self.whiteView = whiteView;
    whiteView.backgroundColor = kWhiteColor;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top);
        
        make.height.equalTo(@(kHeight(482)));
    }];
    
    UIImageView *bgBiew = [[UIImageView alloc] init];
    [self.view addSubview:bgBiew];
    [whiteView addSubview:bgBiew];
    bgBiew.image = kImage(@"back");
    bgBiew.userInteractionEnabled = YES;
    [bgBiew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top);
        
        make.height.equalTo(@(kHeight(482)));
    }];
    
    whiteView.layer.cornerRadius = 4;
    whiteView.clipsToBounds = YES;
    self.nameLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [whiteView addSubview:self.nameLable];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.text = [LangSwitcher switchLang:@"您的恢复词是 在纸上记下他们并安全的保存它" key:nil];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(30);
        make.left.equalTo(whiteView.mas_left).offset(20);
        make.right.equalTo(whiteView.mas_right).offset(-20);
    }];
    
    self.contentLable = [UILabel labelWithBackgroundColor:kHexColor(@"#F3F5F7") textColor:kTextColor2 font:11];
    self.contentLable.numberOfLines = 0;
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [whiteView addSubview:self.contentLable];
    self.contentLable.textAlignment = NSTextAlignmentLeft;
    self.contentLable.text = [LangSwitcher switchLang:@"在您的手机丢失或者忘记密码的情况下, 恢复助记词可用于您的钱包或资金。" key:nil];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(24);
        make.left.equalTo(whiteView.mas_left).offset(20);
        make.right.equalTo(whiteView.mas_right).offset(-20);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [whiteView addSubview:line];
//        [self addBorderToLayer:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(kHeight(172));
        make.left.equalTo(whiteView.mas_left).offset(30);
        make.right.equalTo(whiteView.mas_right).offset(-30);
        make.height.equalTo(@2);
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
        make.top.equalTo(whiteView.mas_bottom).offset(40);
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
    checkVC.name = self.name;
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
