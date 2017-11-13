//
//  BillVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BillVC.h"

#import "CoinHeader.h"

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

@end

@implementation BillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"账单";
    
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];

    [self initTableView];
    //筛选
    [self addFilterItem];
    //获取账单
    [self requestBillList];
    
}

- (void)tl_placeholderOperation {

    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[@"全部", @"充币", @"提币", @"转入", @"转出"];

        NSArray *typeArr = @[@"", @"charge", @"withdraw", @"buy", @"sell"];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _filterPicker.selectBlock = ^(NSInteger index) {
            
            weakSelf.helper.parameters[@"bitType"] = typeArr[index];
            
            [weakSelf.tableView beginRefreshing];
        };
        
        _filterPicker.tagNames = textArr;
        
    }
    
    return _filterPicker;
}

- (void)initTableView {
    
    self.tableView = [[BillTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无记录"];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)addFilterItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"筛选" titleColor:kTextColor frame:CGRectMake(0, 0, 40, 30) vc:self action:@selector(clickFilter:)];
}

#pragma mark - Events
- (void)clickFilter:(UIButton *)sender {
    
    [self.filterPicker show];
    
}

#pragma mark - Data
- (void)requestBillList {
    
    //--//
    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.tableView = self.tableView;
    self.helper = helper;
    
    helper.code = @"802524";
    helper.start = 1;
    helper.limit = 10;
    helper.parameters[@"bizType"] = @"";
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
