//
//  BillVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillVC.h"

#import "BillTableView.h"
#import "TLPlaceholderView.h"
#import "FilterView.h"

#import "BillModel.h"
#import "UIBarButtonItem+convience.h"

#import "BillDetailVC.h"

@interface BillVC ()<RefreshDelegate>

@property (nonatomic, strong) BillTableView *tableView;

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;

@property (nonatomic, strong) TLPageDataHelper *helper;
//筛选
@property (nonatomic, strong) FilterView *filterPicker;
//暂无推荐历史
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation BillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    //暂无明细
    [self initPlaceHolderView];
    
    [self initTableView];
    //筛选
    [self addFilterItem];
    //获取账单
    [self requestBillList];
    
}

- (void)tl_placeholderOperation {

    [self.tableView beginRefreshing];
}

- (void)setBillType:(BillType)billType {
    
    _billType = billType;
    
    if (billType == BillTypeAll) {
        
        self.title = [LangSwitcher switchLang:@"余额明细" key:nil];
        
    } else if (billType == BillTypeRecharge) {
        
        self.title = [LangSwitcher switchLang:@"充值明细" key:nil];
        
    } else if (billType == BillTypeWithdraw) {
        
        self.title = [LangSwitcher switchLang:@"提币明细" key:nil];
        
    } else if (billType == BillTypeFrozen) {
        
        self.title = [LangSwitcher switchLang:@"冻结明细" key:nil];
    }
    
}

#pragma mark - Init
- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[[LangSwitcher switchLang:@"全部" key:nil],
                             [LangSwitcher switchLang:@"充币" key:nil],
                             [LangSwitcher switchLang:@"提币" key:nil],
//                             [LangSwitcher switchLang:@"交易买入" key:nil],
//                             [LangSwitcher switchLang:@"交易卖出" key:nil],
//                             [LangSwitcher switchLang:@"交易手续费" key:nil],
//                             [LangSwitcher switchLang:@"取现手续费" key:nil],
//                             [LangSwitcher switchLang:@"邀请好友收入" key:nil],
                             ];

        NSArray *typeArr = @[@"", @"charge", @"withdraw"];
        
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
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *billIV = [[UIImageView alloc] init];
    
    billIV.image = kImage(@"暂无订单");
    
    [self.placeHolderView addSubview:billIV];
    [billIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = [LangSwitcher switchLang:@"暂无明细" key:nil];
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(billIV.mas_bottom).offset(20);
        make.centerX.equalTo(billIV.mas_centerX);
        
    }];
}

- (void)initTableView {
    
    self.tableView = [[BillTableView alloc]
                      initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                              style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    
}

- (void)addFilterItem {
    
    if (self.billType == BillTypeAll) {
        
        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"筛选" key:nil] 
                                    titleColor:kTextColor
                                         frame:CGRectMake(0, 0, 40, 30)
                                            vc:self
                                        action:@selector(clickFilter:)];

    }
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
    
    if (self.billType == BillTypeRecharge) {
        
        bizType = @"charge";
        
    } else if (self.billType == BillTypeWithdraw) {
        
        bizType = @"withdraw";
        
    } else if (self.billType == BillTypeFrozen) {
        
        bizType = @"";
    }
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    self.helper = helper;
    
    helper.code = @"802524";
    helper.start = 1;
    helper.limit = 10;
    
    helper.parameters[@"bizType"] = bizType;
    helper.parameters[@"kind"] = self.billType == BillTypeFrozen ? @"1": @"0";
    
    helper.parameters[@"accountNumber"] = self.accountNumber;

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

#pragma mark - RefreshDelegate

- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BillDetailVC *detailVC = [BillDetailVC new];
    
    detailVC.bill = self.bills[indexPath.row];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
