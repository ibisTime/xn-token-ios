//
//  ZHShopListVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLCoinWithdrawOrderVC.h"

//#import "ZHShopCell.h"
#import "TLPageDataHelper.h"
#import "TLUIHeader.h"
#import "TLTableView.h"
#import "TLCoinWithdrawModel.h"
#import "TLCoinWithdrawOrderCell.h"

@interface TLCoinWithdrawOrderVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) TLTableView *orderTableView;
//公告view
@property (nonatomic,strong) NSMutableArray <TLCoinWithdrawModel *>*orders;
@property (nonatomic,assign) BOOL isFirst;


@end

@implementation TLCoinWithdrawOrderVC



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (self.isFirst) {
        self.isFirst = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.orderTableView beginRefreshing];
            
        });
        
        
    }
}

- (void)viewDidLayoutSubviews {
    
    self.orderTableView.frame = self.view.bounds;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isFirst  = YES;
    self.title = [LangSwitcher switchLang:@"提币订单" key:nil];
    
    TLTableView *tableView = [TLTableView tableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)
                                                    delegate:self dataSource:self];
    [self.view addSubview:tableView];
    self.orderTableView = tableView;
    self.orderTableView.allowsSelection = NO;
    self.orderTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImgAndText:[LangSwitcher switchLang:@"暂无订单" key:nil]];
    
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"802755";
    helper.parameters[@"applyUser"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"currency"] = self.coin;
    helper.tableView = self.orderTableView;
    [helper modelClass:[TLCoinWithdrawModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.orderTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            
            weakSelf.orders = objs;
            [weakSelf.orderTableView reloadData_tl];
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.orderTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.orders = objs;
            [weakSelf.orderTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
//    [self.orderTableView endRefreshingWithNoMoreData_tl];
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    [];
//
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark- dasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orders.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    static NSString *cellId = @"TLCoinWithdrawOrderCell";
    TLCoinWithdrawOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {

        cell = [[TLCoinWithdrawOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

    }
    cell.withdrawModel = self.orders[indexPath.row];
    return cell;
}

@end

