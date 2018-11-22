//
//  WallAccountVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/6.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WallAccountVC.h"
#import "RechargeCoinVC.h"
#import "ZMAuthVC.h"
#import "TLPwdRelatedVC.h"
#import "WallAccountHeadView.h"
#import "WithdrawalsCoinVC.h"
#import "Masonry.h"
#import "TLUser.h"
#import "BillTableView.h"
#import "BillModel.h"
#import "NSString+Check.h"
#import "FilterView.h"
#import "UIBarButtonItem+convience.h"
#import "BillVC.h"
#import "BillDetailVC.h"
@interface WallAccountVC ()<RefreshDelegate>
@property (nonatomic, strong) BillTableView *tableView;

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;

@property (nonatomic, strong) TLPageDataHelper *helper;
//筛选
@property (nonatomic, strong) FilterView *filterPicker;
//暂无推荐历史
@property (nonatomic, strong) UIView *placeHolderView;
@property (nonatomic , strong) WallAccountHeadView *headView;

@property (nonatomic , strong) UIView *bottomViw;
//充币
@property (nonatomic, strong) UIButton *rechargeBtn;
//提币
@property (nonatomic, strong) UIButton *withdrawalsBtn;
//账单
@property (nonatomic, strong) UIButton *billBtn;
@property (nonatomic , strong) UIScrollView *contentScrollView;

@end

@implementation WallAccountVC

- (void)viewDidLoad {
    
  
//    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    //暂无明细
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;

    [self initHeadView];
    [self initPlaceHolderView];
    [self initTableView];
    [self initBottonView];

    //筛选
    [self addFilterItem];
    //获取账单
    [self requestBillList];

    // Do any additional setup after loading the view.
}
#pragma mark - Init
- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[[LangSwitcher switchLang:@"全部" key:nil],
                             [LangSwitcher switchLang:@"充币" key:nil],
                             [LangSwitcher switchLang:@"提币" key:nil],
                             [LangSwitcher switchLang:@"取现手续费" key:nil],
                             [LangSwitcher switchLang:@"红包退回" key:nil],
                             [LangSwitcher switchLang:@"抢红包" key:nil],
                             [LangSwitcher switchLang:@"发红包" key:nil],
                             [LangSwitcher switchLang:@"量化理财投资" key:nil],
                             [LangSwitcher switchLang:@"量化理财还款" key:nil],
                             [LangSwitcher switchLang:@"积分抽奖" key:nil]




                             ];
        
        NSArray *typeArr = @[@"",
                             @"charge",
                             @"withdraw",
                             @"withdrawfee",
                             @"redpacket_back",
                             @"sendredpacket_in",
                             @"sendredpacket_out",
                             @"lhlc_invest",
                             @"lhlc_repay",
                             @"jf_lottery_in"

                             ];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
//        _filterPicker.title =  [LangSwitcher switchLang: @"请选择交易类型" key:nil];
        
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            weakSelf.helper.parameters[@"bizType"] = typeArr[index];
            
            [weakSelf.tableView beginRefreshing];
        };
        
        _filterPicker.tagNames = textArr;
        
    }
    
    return _filterPicker;
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] init];
    [self.view addSubview:self.placeHolderView];
    
    [self.placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];

    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = [LangSwitcher switchLang:@"暂无明细" key:nil];
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.placeHolderView.mas_top).offset(150);
        make.centerX.equalTo(self.placeHolderView.mas_centerX);
        
    }];
}

- (void)initTableView {
    
    self.tableView = [[BillTableView alloc]
                      initWithFrame:CGRectMake(0, kHeight(90), kScreenWidth, kSuperViewHeight-kTabBarHeight)
                      style:UITableViewStyleGrouped];
   
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.refreshDelegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);

    self.tableView.sectionHeaderHeight = 22;
    [self.view addSubview:self.tableView];
    CoinWeakSelf;
    self.tableView.addBlock = ^{
        [weakSelf clickFilter];
    };
    
}

- (void)addFilterItem {
//
//    if (self.billType == CurrentTypeAll) {
//
//        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"筛选" key:nil]
//                                    titleColor:kTextColor
//                                         frame:CGRectMake(0, 0, 60, 30)
//                                            vc:self
//                                        action:@selector(clickFilter:)];
//
//    }
}

#pragma mark - Events
- (void)clickFilter{
    
    [self.filterPicker show];
    
}

#pragma mark - Data
- (void)requestBillList {
    
    //--//
    __weak typeof(self) weakSelf = self;
    
    NSString *bizType = @"";
    
    if (self.billType == CurrentTypeRecharge) {
        
        bizType = @"charge";
        
    } else if (self.billType == CurrentTypeWithdraw) {
        
        bizType = @"withdraw";
        
    } else if (self.billType == CurrentTypeFrozen) {
        
        bizType = @"";
    }
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    self.helper = helper;
    
    helper.code = @"802524";
    helper.start = 1;
    helper.limit = 10;
    
    helper.parameters[@"bizType"] = bizType;
    helper.parameters[@"kind"] = self.billType == CurrentTypeFrozen ? @"1": @"0";
    
    helper.parameters[@"accountNumber"] = self.currency.accountNumber;
    
    //    helper.parameters[@"channelType"] = @"C";
    //    helper.parameters[@"status"] = @"";
    
    //0 刚生成待回调，1 已回调待对账，2 对账通过, 3 对账不通过待调账,4 已调账,9,无需对账
    //pageDataHelper.parameters[@"status"] = [ZHUser user].token;
    
    [helper modelClass:[BillModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (weakSelf.tl_placeholderView.superview != nil) {
                
                [weakSelf removePlaceholderView];
            }
            
            weakSelf.bills = objs;
            
            weakSelf.tableView.bills = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
    }];
    
    [self.tableView beginRefreshing];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (weakSelf.tl_placeholderView.superview != nil) {
                
                [weakSelf removePlaceholderView];
            }
            
            weakSelf.bills = objs;
            
            weakSelf.tableView.bills = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)initHeadView
{
    UIView *top = [[UIView alloc] init];
    [self.view addSubview:top];
    top.backgroundColor = kHexColor(@"#0848DF");
    
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    
    WallAccountHeadView *headView = [[WallAccountHeadView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 90)];
    self.headView = headView;
    [self.view addSubview:headView];
    
    if (self.currency) {
        headView.currency  = self.currency;
    }
    
}

- (void)initBottonView
{
  UIView *bottomView  = [[UIView alloc] init];
    self.bottomViw = bottomView;
    [self.view insertSubview:bottomView aboveSubview:self.tableView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.bottom.equalTo(@(0));
        make.height.equalTo(@(50));
    }];
    
    //底部操作按钮
    
    NSArray *textArr = @[
                         [LangSwitcher switchLang:@"充币" key:nil],
                         [LangSwitcher switchLang:@"提币" key:nil]
                         ];
    
    NSArray *imgArr = @[@"充币", @"提币"];
    
    CGFloat btnW = (kScreenWidth - 2*0)/2.0;
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithTitle:nil titleColor:kTextColor backgroundColor:kClearColor titleFont:12.0];
        [btn addTarget:self action:@selector(btnClickCurreny:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:kHexColor(@"#ffffff") forState:UIControlStateNormal];
        
        [btn setImage:kImage(imgArr[idx]) forState:UIControlStateNormal];
        
        
        
        btn.tag = 201806+idx;
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, -10, 0, 0)];
//        if ([LangSwitcher currentLangType] == LangTypeSimple) {
//
//        }else if ([LangSwitcher currentLangType] == LangTypeEnglish)
//        {
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, kWidth(50), 10, 0)];
//
//
//        }else if ([LangSwitcher currentLangType] == LangTypeKorean)
//        {
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, kWidth(35), 10, 0)];
//
//        }
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-12, 0, 0, 0)];

        UILabel *lab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12];
        lab.text = [LangSwitcher switchLang:textArr[idx] key:nil];
        [btn addSubview:lab];
        [self.bottomViw addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(idx*btnW));
            make.bottom.equalTo(self.bottomViw.mas_bottom);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(50));
            
        }];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(btn.mas_centerX).offset(2);
            make.top.equalTo(btn.mas_centerY).offset(5);

            
        }];
        if (idx != 1) {
            [btn setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
//            [btn setTitleColor:kTextColor forState:UIControlStateNormal];
            lab.textColor = kTextColor;
            UIView *vLine = [[UIView alloc] init];
            
            vLine.backgroundColor = kLineColor;
            
            [self.bottomViw addSubview:vLine];
            [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(btn.mas_right);
                make.centerY.equalTo(btn.mas_centerY);
                make.width.equalTo(@0.5);
                make.height.equalTo(@20);
                
            }];
        }
        else{
            lab.textColor = kTextColor;

//            [btn setTitleColor:kTextColor forState:UIControlStateNormal];
            [btn setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
            
        }
        if (idx == 0) {
            
            self.rechargeBtn = btn;
            
        } else{
            
            self.withdrawalsBtn = btn;
            
        }
        
    }];
    
    
}

- (void)btnClickCurreny: (UIButton *)btn
{
    NSInteger tag = btn.tag-201806;
    RechargeCoinVC *coinVC = [RechargeCoinVC new];

    switch (tag) {
        case 0:
            coinVC.currency = self.currency;
            [self.navigationController pushViewController:coinVC animated:YES];
            break;
        case 1:
            [self clickWithdrawWithCurrency:self.currency];

            break;
            
        default:
            break;
    }
    
}

- (void)clickWithdrawWithCurrency:(CurrencyModel *)currencyModel {
    
    CoinWeakSelf;
    
////    判断是否认证身份
//    if (![[TLUser user].realName valid]) {
//
//        ZMAuthVC *zmAuthVC = [ZMAuthVC new];
//
//        zmAuthVC.title = [LangSwitcher switchLang:@"实名认证" key:nil];
//
//        zmAuthVC.success = ^{
    
            //实名认证成功后，判断是否设置资金密码
//            if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
//
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"实名认证成功, 请设置资金密码" key:nil]];
//
//            } else {
//
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"实名认证成功" key:nil]];
//            }
//
//            [weakSelf clickWithdrawWithCurrency:currencyModel];
    
    
        
//        [self.navigationController pushViewController:zmAuthVC animated:YES];
//
//        return ;
//    }
    
//    实名认证成功后，判断是否设置资金密码
    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {

        TLPwdType pwdType = TLPwdTypeSetTrade;
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        pwdRelatedVC.isWallet = YES;
        pwdRelatedVC.success = ^{

            [weakSelf clickWithdrawWithCurrency:currencyModel];
        };
        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
        return ;

    }
    
    WithdrawalsCoinVC *coinVC = [WithdrawalsCoinVC new];
    coinVC.currency = currencyModel;
    [self.navigationController pushViewController:coinVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"返回";//字符串可随便定义或为nil
//    backItem.target = self;
//    backItem.image = kImage(@"返回");
//   
//    self.navigationItem.backBarButtonItem = backItem;

}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CoinWeakSelf;
    
    //    NSInteger tag = (sender.tag - 1200)%100;
    
//    BillModel *currencyModel = self.bills[indexPath.row];
    BillDetailVC *billVC = [BillDetailVC new];
    billVC.bill =  self.bills[indexPath.row];
//    billVC.accountNumber = currencyModel.accountNumber;
//    billVC.billType = BillTypeAll;
    [self.navigationController pushViewController:billVC animated:YES];
    
    
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
