//
//  BuildCheckVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/8.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "BuildCheckVC.h"
#import "QHCollectionViewNine.h"
#import "CustomLayoutWallet.h"
#import "AddSearchBottomCell.h"
#import "AddSearchCell.h"
#import "TLTabBarController.h"
#import "TLUpdateVC.h"
#import "MnemonicUtil.h"
#import "WalletNewFeaturesVC.h"
@interface BuildCheckVC ()<addCollectionViewDelegate>
@property (nonatomic ,strong) UILabel *nameLable;

@property (nonatomic ,strong) UILabel *contentLable;

@property (nonatomic ,strong) UIButton *sureButton;

@property (nonatomic, strong) QHCollectionViewNine *nineView;

@property (nonatomic ,strong) QHCollectionViewNine *bottomView;

@property (nonatomic ,strong) CurrencyTitleModel *titleModel;

@property (nonatomic, strong) NSMutableArray *topNames;

@property (nonatomic, strong) NSMutableArray *bottomNames;

@property (nonatomic ,strong) UIView *whiteView;

@end

@implementation BuildCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [LangSwitcher switchLang:@"钱包备份" key:nil];
    [self initSubViews];
    self.view.backgroundColor = kWhiteColor;
    self.bottomView.bottomtitles = self.bottomtitles;
    self.bottomView.IsNeedRefash = YES;

    [self.bottomView reloadData];

    self.topNames = [NSMutableArray array];
    CoinWeakSelf;
    [weakSelf.titles enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.symbol) {
            
            [weakSelf.topNames addObject:obj.symbol];
        }
    }];
    
    weakSelf.bottomNames = [NSMutableArray array];
    
    [weakSelf.bottomtitles enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.symbol) {
            
            [weakSelf.bottomNames addObject:obj.symbol];
        }
    }];
    
//    if (self.titles.count > 0) {
//        for (CurrencyTitleModel *tit in self.titles) {
//            tit.IsSelect = NO;
//        }
//    }

    // Do any additional setup after loading the view.
}

- (void)initSubViews
{
    
    
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = kWhiteColor;
    
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
        
        make.height.equalTo(@(kHeight(384)));
    }];
    
    UIImageView *bgBiew = [[UIImageView alloc] init];
    [self.view addSubview:bgBiew];
    [whiteView addSubview:bgBiew];
    bgBiew.image = kImage(@"back");
    bgBiew.userInteractionEnabled = YES;
    [bgBiew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView.mas_left);
        make.right.equalTo(whiteView.mas_right);
        make.top.equalTo(whiteView.mas_top);
        
        make.height.equalTo(@(kHeight(384)));
    }];
    
    whiteView.layer.cornerRadius = 4;
    whiteView.clipsToBounds = YES;
    self.nameLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [whiteView addSubview:self.nameLable];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.text = [LangSwitcher switchLang:@"验证你的钱包助记词" key:nil];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(30);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
    }];
    self.contentLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    //    self.title = [LangSwitcher switchLang:@"我的" key:nil];
    [whiteView addSubview:self.contentLable];
    self.contentLable.textAlignment = NSTextAlignmentLeft;
    self.contentLable.numberOfLines = 0;
    self.contentLable.text = [LangSwitcher switchLang:@"根据你记下的助记词,按顺序点击,验证你备份的助记词正确无误" key:nil];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    

    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
     paraStyle.lineSpacing = 7;
    NSDictionary *dic = @{ NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.contentLable.text attributes:dic];
    
    self.contentLable.attributedText = attributeStr;
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(19);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
    }];
    
    [self initTopCollectionView];
    [self initColllention];
    
    self.sureButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text = [LangSwitcher switchLang:@"确认" key:nil];
    [self.sureButton setTitle:text forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(buildSureWallet) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:kHexColor(@"#f5f5f5") forState:UIControlStateDisabled];
    self.sureButton.enabled = NO;
//    [self.view addSubview:self.sureButton];
//    self.view.backgroundColor = kWhiteColor;
//
//    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).offset(-(kBottomInsetHeight+10));
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.height.equalTo(@45);
//        
//    }];
    
}
- (void)initTopCollectionView{
    
        CustomLayoutWallet *layout = [[CustomLayoutWallet alloc] init];
        layout.minimumLineSpacing = 10.0; // 竖
    layout.minimumInteritemSpacing = 10.0;
    layout.itemSize = CGSizeMake(80, 36);
        UIImage *image1 = [UIImage imageNamed:@"bch"];
        UIImage *image2 = [UIImage imageNamed:@"eth"];
        UIImage *image3 = [UIImage imageNamed:@"ltc"];
        NSArray *array = @[image2, image2, image3, image2, image3, image1, image3, image1, image1];

        QHCollectionViewNine *nineView = [[QHCollectionViewNine alloc] initWithFrame:CGRectZero collectionViewLayout:layout withImage:array];
        self.nineView = nineView;
    [self.whiteView addSubview:nineView];
    [nineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView.mas_top).offset(kHeight(153));
        make.left.equalTo(self.whiteView.mas_left).offset(30);
        make.right.equalTo(self.whiteView.mas_right).offset(-30);
        make.height.equalTo(@(kHeight(180)));

    }];
        nineView.backgroundColor = kWhiteColor;

        self.nineView.type = SearchTypeTop;
        nineView.refreshDelegate = self;
        nineView.layer.cornerRadius = 6;
        nineView.clipsToBounds = YES;
//        [self.view addSubview:nineView];
    
}

- (void)initColllention
{
    CustomLayoutWallet *layout = [[CustomLayoutWallet alloc] init];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.itemSize = CGSizeMake(kScreenWidth/3, 46);

    layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
    UIImage *image1 = [UIImage imageNamed:@"bch"];
    UIImage *image2 = [UIImage imageNamed:@"eth"];
    UIImage *image3 = [UIImage imageNamed:@"ltc"];
    NSArray *array = @[image2, image2, image3, image2, image3, image1, image3, image1, image1];
    QHCollectionViewNine *bottomView = [[QHCollectionViewNine alloc] initWithFrame:CGRectMake(0, 422, kScreenWidth, 200) collectionViewLayout:layout withImage:array];
    self.bottomView = bottomView;
    bottomView.refreshDelegate = self;
    bottomView.backgroundColor = kWhiteColor;
    self.bottomView.type = SearchTypeBottom;
    [self.view addSubview:bottomView];
    
    bottomView.layer.cornerRadius = 6;
    bottomView.clipsToBounds = YES;
//    bottomView.backgroundColor = kWhiteColor;
}

- (void)refreshCollectionView:(QHCollectionViewNine *)refreshCollectionview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger temp = 0;
    CurrencyTitleModel *tit = [CurrencyTitleModel new];
    if (refreshCollectionview.type == SearchTypeTop) {
        BOOL isStopNow = NO;

        NSMutableArray *arr = self.bottomtitles;
        CurrencyTitleModel *title = self.titles[indexPath.row];
        for (int i = 0; i < self.bottomtitles.count; i++) {
            

            if ([self.bottomNames containsObject:title.symbol]) {
                
                for (CurrencyTitleModel *titleModel in arr) {
                    if (titleModel.symbol == title.symbol&& titleModel.IsSelect == YES) {
                        titleModel.IsSelect = NO;
                        tit = titleModel;
                        temp = i;
                        isStopNow = YES;
                        
                    }
                    
                    if (isStopNow) {
                        break;
                    }
                }
                
            }
            if (isStopNow) {
                break;
            }

        }
       
        [self.titles removeObjectAtIndex:indexPath.row];
        [self.topNames removeObjectAtIndex:indexPath.row];
        self.nineView.titles = self.titles;
        if (self.titles.count < 12) {
            self.sureButton.selected = NO;
        }
        [self.nineView reloadData];
//        [self.bottomView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil]];
//        [self.bottomtitles removeObjectAtIndex:temp];
//        self.bottomView.bottomtitles = self.bottomtitles;
//
//        [self.bottomView reloadData];
//        [self.bottomtitles insertObject:tit atIndex:temp];
         self.bottomtitles = arr.mutableCopy;
        [self.bottomView.bottomtitles removeAllObjects];
        [self.bottomView reloadData];
        [self.bottomView removeFromSuperview];
        [self initColllention];
        self.bottomView.bottomtitles = self.bottomtitles;
        [self.bottomView reloadData];


        
    }else{
        
        
        
        if (!self.titles) {
            self.titles = [NSMutableArray array];
        }
        NSMutableArray *arr = self.topNames;
        CurrencyTitleModel *tit = self.bottomtitles[indexPath.row];
        if ([arr containsObject:tit.symbol] &&tit.IsSelect == YES) {
            return;
            
        }else{
            
            CurrencyTitleModel *title =self.bottomtitles[indexPath.row];
            
            if (title.IsSelect == YES) {
                return;
            }
            title.IsSelect = YES;
            [self.titles addObject:self.bottomtitles[indexPath.row]];
            [self.topNames addObject:title.symbol];

            
        }
        
        
        self.nineView.titles = self.titles;
        
        self.bottomView.bottomtitles = self.bottomtitles.mutableCopy;
        [self.nineView reloadData];
        if (self.titles.count == 12) {
            self.sureButton.enabled = YES;
            [self buildSureWallet];
        }
//        self.bottomView.IsNeedRefash = NO;
        [self.bottomView.bottomtitles removeAllObjects];
        [self.bottomView reloadData];
        [self.bottomView removeFromSuperview];
        [self initColllention];
        self.bottomView.bottomtitles = self.bottomtitles;
        [self.bottomView reloadData];

//        [self.bottomView reloadItemsAtIndexPaths:@[indexPath]];
        
        
//        [self.bottomView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil]];
    }
    
    
    NSLog(@"%s",__func__);
    
}


- (void)buildSureWallet
{
    
    WalletNewFeaturesVC * newVC = [WalletNewFeaturesVC new];
    
    //        [self.navigationController pushViewController:newVC animated:YES];
    
    
//    return;
    //验证助记词
    if ([self.titles isEqualToArray:self.userTitles]) {
        
        NSLog(@"%@",self.titleWord);
        
//        NSString *word =  [[NSUserDefaults standardUserDefaults] objectForKey:self.titleWord];
        if (self.isCopy == YES) {
            
            
            NSString *text = [LangSwitcher switchLang:@"备份成功,请妥善保管助记词" key:nil];
            
            [TLAlert alertWithMsg:text];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WalletNewFeaturesVC * newVC = [WalletNewFeaturesVC new];
                //        [self.navigationController pushViewController:newVC animated:YES];
                [UIApplication sharedApplication].keyWindow.rootViewController = newVC;
                return ;
            });
        }
        NSString *prikey   =[MnemonicUtil getPrivateKeyWithMnemonics:self.titleWord];

        NSString *address = [MnemonicUtil getAddressWithPrivateKey:prikey];
        
//        [[NSUserDefaults standardUserDefaults] setObject:self.titleWord forKey:KWalletWord];
//
//        [[NSUserDefaults standardUserDefaults] setObject:prikey forKey:KWalletPrivateKey];
//        [[NSUserDefaults standardUserDefaults] setObject:address forKey:KWalletAddress];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *user = [TLUser user].userId;
        //创建钱包后 储存助记伺 地址 私钥
        TLDataBase *dateBase = [TLDataBase sharedManager];
        if ([dateBase.dataBase open]) {
            BOOL sucess = [dateBase.dataBase executeUpdate:@"insert into THAUser(userId,Mnemonics,wanAddress,wanPrivate,ethPrivate,ethAddress,PwdKey,name) values(?,?,?,?,?,?,?,?)",user,self.titleWord,address,prikey,prikey,address,self.pwd,self.name];
            
            NSLog(@"插入地址私钥%d",sucess);
        }
      
        NSString *text = [LangSwitcher switchLang:@"助记词顺序验证通过,请妥善保管助记词" key:nil];
        
        [TLAlert alertWithMsg:text];
        //验证通过
        
      
        
        WalletNewFeaturesVC * newVC = [WalletNewFeaturesVC new];
//        [self.navigationController pushViewController:newVC animated:YES];
        [UIApplication sharedApplication].keyWindow.rootViewController = newVC;
       
    }else{
        //验证失败
        NSString *text = [LangSwitcher switchLang:@"助记词验证失败,请检查备份" key:nil];
        [TLAlert alertWithMsg:text];
        return;
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
