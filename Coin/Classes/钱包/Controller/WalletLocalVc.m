
//  WalletLocalVc.m
//  Coin
//
//  Created by shaojianfei on 2018/6/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletLocalVc.h"
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
#import "WalletForwordVC.h"
#import "WalletLocalBillTableView.h"
#import "LocalBillDetailVC.h"
@interface WalletLocalVc ()<RefreshDelegate>
@property (nonatomic, strong) WalletLocalBillTableView *tableView;

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

@implementation WalletLocalVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeadView];
    [self initPlaceHolderView];
    [self initTableView];
    [self initBottonView];
    [self addPlaceholderView];

    //筛选
    [self addFilterItem];
    //获取账单
    [self requestBillList];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [LangSwitcher switchLang: [NSString stringWithFormat:@"%@",self.currency.symbol] key:nil];;
}
#pragma mark - Init
- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[[LangSwitcher switchLang:@"全部" key:nil],
                             [LangSwitcher switchLang:@"充币" key:nil],
                             [LangSwitcher switchLang:@"提币" key:nil],
                             [LangSwitcher switchLang:@"取现手续费" key:nil]
                             ];
        
        NSArray *typeArr = @[@"",
                             @"charge",
                             @"withdraw",
                             @"withdrawfee"];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _filterPicker.title =  [LangSwitcher switchLang: @"请选择交易类型" key:nil];
        
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            weakSelf.helper.parameters[@"bizType"] = typeArr[index];
            
            [weakSelf.tableView beginRefreshing];
        };
        
        _filterPicker.tagNames = textArr;
        
    }
    
    return _filterPicker;
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, kScreenWidth,  40)];
    
    //    UIImageView *billIV = [[UIImageView alloc] init];
    //
    //    billIV.image = kImage(@"暂无订单");
    //
    //    [self.placeHolderView addSubview:billIV];
    //    [billIV mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.centerX.equalTo(@0);
    //        make.top.equalTo(@140);
    //
    //    }];
    
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
    
    self.tableView = [[WalletLocalBillTableView alloc]
                      initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                      style:UITableViewStyleGrouped];
    
    self.tableView.placeHolderView = self.placeHolderView;
    self.tableView.tableHeaderView = self.headView;
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.refreshDelegate = self;
    self.tableView.billModel = self.currency;
    self.tableView.sectionHeaderHeight = 22;
    [self.view addSubview:self.tableView];
    
}

- (void)addFilterItem {
    
//    if (self.billType == LocalTypeAll) {
//
//        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"筛选" key:nil]
//                                    titleColor:kTextColor
//                                         frame:CGRectMake(0, 0, 40, 30)
//                                            vc:self
//                                        action:@selector(clickFilter:)];
//
//    }
}

#pragma mark - Events
- (void)clickFilter:(UIButton *)sender {
    
    [self.filterPicker show];
    
}

#pragma mark - Data
- (void)requestBillList {
    
    //--//
    __weak typeof(self) weakSelf = self;
    
    NSString *bizType = @"";
    
    if (self.billType == LocalTypeRecharge) {
        
        bizType = @"charge";
        
    } else if (self.billType == LocalTypeWithdraw) {
        
        bizType = @"withdraw";
        
    } else if (self.billType == LocalTypeFrozen) {
        
        bizType = @"";
    }
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    self.helper = helper;
    
    helper.code = @"802271";
    helper.start = 1;
    helper.limit = 10;
    
//    helper.parameters[@"bizType"] = bizType;
//    helper.parameters[@"kind"] = self.billType == LocalTypeFrozen ? @"1": @"0";
    
    helper.parameters[@"symbol"] = self.currency.symbol;
    helper.parameters[@"address"] = self.currency.address;

    //    helper.parameters[@"channelType"] = @"C";
    //    helper.parameters[@"status"] = @"";
    
    //0 刚生成待回调，1 已回调待对账，2 对账通过, 3 对账不通过待调账,4 已调账,9,无需对账
    //pageDataHelper.parameters[@"status"] = [ZHUser user].token;
    
    [helper modelClass:[BillModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
//            if (weakSelf.tl_placeholderView.superview != nil) {
//                
//                [weakSelf removePlaceholderView];
//            }
            if (objs.count == 0) {
                [weakSelf addPlaceholderView];

            }
            weakSelf.bills = objs;
            weakSelf.tableView.billModel = weakSelf.currency;

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
            weakSelf.tableView.billModel = weakSelf.currency;
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
    
    WallAccountHeadView *headView = [[WallAccountHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    self.headView = headView;
    [self.view addSubview:headView];
    self.headView.ISLocal = YES;
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
        make.bottom.equalTo(@(-kBottomInsetHeight));
        make.height.equalTo(@50);
    }];
    
    //底部操作按钮
    
    NSArray *textArr = @[
                         [LangSwitcher switchLang:@"收款" key:nil],
                         [LangSwitcher switchLang:@"转账" key:nil]
                         ];
    
    NSArray *imgArr = @[@"充币", @"提币"];
    
    CGFloat btnW = (kScreenWidth - 2*0)/2.0;
    
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [UIButton buttonWithTitle:textArr[idx] titleColor:kTextColor backgroundColor:kClearColor titleFont:16.0];
        [btn addTarget:self action:@selector(btnClickCurreny:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:kHexColor(@"#ffffff") forState:UIControlStateNormal];
        
        [btn setImage:kImage(imgArr[idx]) forState:UIControlStateNormal];
        
        btn.tag = 201806+idx;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        [self.bottomViw addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(idx*btnW));
            make.top.equalTo(self.bottomViw.mas_top).offset(0);
            make.width.equalTo(@(btnW));
            make.height.equalTo(@(50));
            
        }];
        
        if (idx != 1) {
            [btn setBackgroundColor:kWhiteColor forState:UIControlStateNormal];
            [btn setTitleColor:kHexColor(@"#108ee9") forState:UIControlStateNormal];
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
            
            [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
            [btn setBackgroundColor:kHexColor(@"#108ee9") forState:UIControlStateNormal];

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
    
    //判断是否认证身份
    //    if (![[TLUser user].realName valid]) {
    //
    //        ZMAuthVC *zmAuthVC = [ZMAuthVC new];
    //
    //        zmAuthVC.title = [LangSwitcher switchLang:@"实名认证" key:nil];
    //
    //        zmAuthVC.success = ^{
    //
    //            //实名认证成功后，判断是否设置资金密码
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
    //
    //        };
    //
    //        [self.navigationController pushViewController:zmAuthVC animated:YES];
    //
    //        return ;
    //    }
    
    //实名认证成功后，判断是否设置资金密码
    //    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
    //
    //        TLPwdType pwdType = TLPwdTypeSetTrade;
    //        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
    //        pwdRelatedVC.isWallet = YES;
    //        pwdRelatedVC.success = ^{
    //
    //            [weakSelf clickWithdrawWithCurrency:currencyModel];
    //        };
    //        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
    //        return ;
    //
    //    }
    
    WalletForwordVC *coinVC = [WalletForwordVC new];
    coinVC.currency = currencyModel;
    [self.navigationController pushViewController:coinVC animated:YES];
}


-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LocalBillDetailVC *detailVc  =  [LocalBillDetailVC new];
    detailVc.bill = self.bills[indexPath.row];
    detailVc.currentModel = self.currency;
    [self.navigationController pushViewController:detailVc animated:YES];
    
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
