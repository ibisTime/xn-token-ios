
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
#import "BillModel.h"
#import "NSString+Check.h"
#import "FilterView.h"
#import "UIBarButtonItem+convience.h"
#import "WalletForwordVC.h"
#import "WalletLocalBillTableView.h"
#import "LocalBillDetailVC.h"
#import "TLBillBTCVC.h"
#import "USDTRecordModel.h"
@interface WalletLocalVc ()<RefreshDelegate>
@property (nonatomic, strong) WalletLocalBillTableView *tableView;

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;
@property (nonatomic,strong) NSMutableArray <USDTRecordModel *>*ustds;

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
    [self initTableView];
    [self initBottonView];
    [self addPlaceholderView];

    //获取账单
    // Do any additional setup after loading the view.
    self.title = [LangSwitcher switchLang: [NSString stringWithFormat:@"%@",self.currency.symbol] key:nil];
    if ([self.currency.symbol isEqualToString:@"BTC"]) {
        [self requestBtcList];

    }
    else if ([self.currency.symbol isEqualToString:@"LXT"])
    {
        [self requestLXTList];
    }
    else if ([self.currency.symbol isEqualToString:@"USDT"])
    {
        [self requestUSDTList];
    }
    else
    {
        [self requestBillList];
    }

}

-(void)requestUSDTList
{
    __weak typeof(self) weakSelf = self;
    
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    self.helper = helper;
    
    helper.code = @"802505";
    helper.start = 0;
    helper.limit = 10;
//    helper.parameters[@"address"] = @"1x6YnuBVeeE65dQRZztRWgUPwyBjHCA5g";
    helper.parameters[@"address"] = self.currency.address;
    [helper modelClass:[USDTRecordModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count == 0) {
                [weakSelf addPlaceholderView];
                
            }
            
            weakSelf.ustds = objs;
            
            weakSelf.tableView.billModel = weakSelf.currency;
            
            weakSelf.tableView.ustds = objs;
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
            weakSelf.tableView.ustds = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
    
}

- (void)requestLXTList
{
    __weak typeof(self) weakSelf = self;


    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];

    helper.tableView = self.tableView;
    self.helper = helper;

    helper.code = @"802308";
    helper.start = 0;
    helper.limit = 10;
    helper.parameters[@"address"] = self.currency.address;
    CoinModel *coin = [CoinUtil getCoinModel:self.currency.symbol];

    helper.parameters[@"contractAddress"] = coin.contractAddress;
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

- (void)requestBtcList
{
    //--//
    __weak typeof(self) weakSelf = self;
//
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    self.helper = helper;
    
    helper.code = @"802221";
    helper.start = 0;
    helper.limit = 10;
    helper.parameters[@"address"] = self.currency.address;
    [helper modelClass:[BillModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
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



- (void)initTableView {
    
    self.tableView = [[WalletLocalBillTableView alloc]
                      initWithFrame:CGRectMake(0, 110, kScreenWidth, SCREEN_HEIGHT - 170 - kNavigationBarHeight)
                      style:UITableViewStyleGrouped];
    
    self.tableView.placeHolderView = self.placeHolderView;
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.refreshDelegate = self;
    self.tableView.billModel = self.currency;
    self.tableView.defaultNoDataImage = kImage(@"暂无订单");
    self.tableView.defaultNoDataText = [LangSwitcher switchLang:@"暂无明细" key:nil];
//    self.tableView.sectionHeaderHeight = 22;
    [self.view addSubview:self.tableView];
    
}

//- (void)addFilterItem

#pragma mark - Events
//- (void)clickFilter:(UIButton *)sender {
//
//    [self.filterPicker show];
//
//}

#pragma mark - Data
- (void)requestBillList {
    
    //--//
    __weak typeof(self) weakSelf = self;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    self.helper = helper;
    
    helper.code = @"802271";
    helper.start = 1;
    helper.limit = 10;
    helper.parameters[@"symbol"] = self.currency.symbol;
    helper.parameters[@"address"] = self.currency.address;
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
  
    self.view.backgroundColor = kWhiteColor;
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = kHexColor(@"#0848DF");
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(60));
    }];
   
    
    WallAccountHeadView *headView = [[WallAccountHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
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
    bottomView.backgroundColor = [UIColor redColor];
    bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 60 - kNavigationBarHeight, SCREEN_WIDTH, 60);
    [self.view addSubview:bottomView];

    bottomView.backgroundColor = kWhiteColor;
    bottomView.layer.cornerRadius=5;
    bottomView.layer.shadowOpacity = 0.22;// 阴影透明度
    bottomView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    bottomView.layer.shadowRadius=3;// 阴影扩散的范围控制
    bottomView.layer.shadowOffset=CGSizeMake(1, 1);// 阴影的范围
    //底部操作按钮
    
    NSArray *textArr = @[
                         [LangSwitcher switchLang:@"收款" key:nil],
                         [LangSwitcher switchLang:@"转账" key:nil]
                         ];
    NSArray *imgArr = @[@"充币", @"提币"];
    
    
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithTitle:textArr[i] titleColor:kTextColor backgroundColor:kClearColor titleFont:12.0];
        [btn addTarget:self action:@selector(btnClickCurreny:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(i % 2 * SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 60);
        [btn SG_imagePositionStyle:(SGImagePositionStyleTop) spacing:3 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(imgArr[i]) forState:UIControlStateNormal];
        }];
        btn.tag = 201806+i;
        [bottomView addSubview:btn];
    }
    
    UIView *vLine = [[UIView alloc] init];
    
    vLine.backgroundColor = kLineColor;
    
    [self.bottomViw addSubview:vLine];
    vLine.frame =CGRectMake(SCREEN_WIDTH/2, 0, 0.5, 60);
    
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
    
    WalletForwordVC *coinVC = [WalletForwordVC new];
    coinVC.currency = currencyModel;
    [self.navigationController pushViewController:coinVC animated:YES];
}


-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([self.currency.symbol isEqualToString:@"BTC"]) {
        TLBillBTCVC *vc = [TLBillBTCVC  new];
        vc.bill = self.bills[indexPath.row];
        vc.currentModel = self.currency;
        vc.address = self.currency.address;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        LocalBillDetailVC *detailVc  =  [LocalBillDetailVC new];
        if ([self.currency.symbol isEqualToString:@"USDT"]) {
            detailVc.usdtModel = self.ustds[indexPath.row];
        }else
        {
            detailVc.bill = self.bills[indexPath.row];
        }
        detailVc.currentModel = self.currency;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    
    
}


@end
