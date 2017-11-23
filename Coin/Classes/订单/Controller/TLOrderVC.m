//
//  TLOrderVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderVC.h"

#import "TopLabelUtil.h"

#import "OrderListTableView.h"

@interface TLOrderVC ()<SegmentDelegate, RefreshDelegate>

//切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//
@property (nonatomic, strong) OrderListTableView *tableView;

@end

@implementation TLOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单";

    [self.view addSubview:self.labelUnil];
    
    [self initTableView];
}

#pragma mark - Init
-(TopLabelUtil *)labelUnil {
    
    if (!_labelUnil) {
        
        _labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 120, 25, 240, 44)];
        _labelUnil.delegate = self;
        _labelUnil.backgroundColor = [UIColor clearColor];
        _labelUnil.titleNormalColor = kTextColor;
        _labelUnil.titleSelectColor = kThemeColor;
        _labelUnil.titleFont = Font(17.0);
        _labelUnil.lineType = LineTypeTitleLength;
        
        _labelUnil.titleArray = @[@"进行中",@"已完成"];
    }
    
    return _labelUnil;
}

- (void)initTableView {
    
    self.tableView = [[OrderListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

#pragma mark - SegmentDelegate
-(void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    if (index == 1) {
        
//        self.tradeType = @"1";
        
    }else {
        
//        self.tradeType = @"0";
        
    }
    
//    self.helper.parameters[@"tradeType"] = self.tradeType;
    
    [self.tableView beginRefreshing];
    
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}

#pragma mark - RefreshDelegate

- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([self.tradeType isEqualToString:@"1"]) {
    
//        TradeBuyVC *buyVC = [TradeBuyVC new];
//
//        buyVC.advertise = self.advertises[indexPath.row];
//
//        [self.navigationController pushViewController:buyVC animated:YES];
//    } else {
//
//        TradeSellVC *sellVC = [TradeSellVC new];
//
//        sellVC.advertise = self.advertises[indexPath.row];
//
//        [self.navigationController pushViewController:sellVC animated:YES];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
