//
//  StoreListVC.m
//  Coin
//
//  Created by 蔡卓越 on 2018/3/29.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "StoreListVC.h"

//M
#import "StoreModel.h"
#import "CountInfoModel.h"
//V
#import "StoreTableView.h"
//C
#import "StoreDetailVC.h"
#import "TLPlaceholderView.h"
@interface StoreListVC ()<RefreshDelegate>

//店铺
@property (nonatomic, strong) StoreTableView *tableView;
//暂无店铺
//@property (nonatomic, strong) UIView *placeHolderView;
//
@property (nonatomic, strong) NSArray <StoreModel *>*stores;

@property (nonatomic, strong) TLPlaceholderView *placeholderView;

@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UILabel *contentLab;

@end

@implementation StoreListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"首创玩法" key:nil];
    //
    [self initPlaceHolderView];
    //获取店铺列表
//    [self requestStoreList];
    //
//    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (StoreTableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[StoreTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
//        _tableView.placeHolderView = self.placeHolderView;
        _tableView.refreshDelegate = self;
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _tableView;
}

- (void)initPlaceHolderView {
    
    self.titleLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self.view addSubview:self.titleLable];
    self.titleLable.numberOfLines = 0;
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kHeight(20)));
        make.right.equalTo(@-10);
        make.left.equalTo(@10);

    }];
    
    self.titleLable.text = @"THA用户可以通过邀请制收取徒弟，并根据任务引导来教育徒弟，从而获得算力。另外，徒弟使用THA钱包购买量化理财或余币宝，师父可获得徒弟一定比例的收益奖励。";
    self.contentLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self.view addSubview:self.contentLab];
    self.contentLab.numberOfLines = 0;
    self.contentLab.text = @"Global Master and Apprentice Initiative: THA Users can receive apprentice through the invitation system, and instruct apprentice according to the task, thus obtain the calculation force. In addition, the apprentice uses THA Wallet to purchase quantitative financial products or Yubibao, masters can obtain a certain percentage of the Apprentice reward.";
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(20);
        make.right.equalTo(@-10);
        make.left.equalTo(@10);
    }];
    
    
//    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:nil text:[LangSwitcher switchLang:@" 敬请期待!" key:nil] textColor:kTextColor];
//
//    [self.view addSubview:self.placeholderView];
    
//    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
//
//    UIImageView *addressIV = [[UIImageView alloc] init];
//    addressIV.image = kImage(@"暂无订单");
//    addressIV.centerX = kScreenWidth/2.0;
//    [self.placeHolderView addSubview:addressIV];
//    [addressIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.equalTo(@0);
//        make.top.equalTo(@(kHeight(70)));
//
//    }];
//
//    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
//
//    textLbl.text = [LangSwitcher switchLang:@"暂无店铺" key:nil];
//
//    textLbl.textAlignment = NSTextAlignmentCenter;
//
//    [self.placeHolderView addSubview:textLbl];
//    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(addressIV.mas_bottom).offset(20);
//        make.centerX.equalTo(addressIV.mas_centerX);
//
//    }];
    
}

- (void)requestStoreList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"625327";
    //    helper.isList = YES;
    helper.parameters[@"orderColumn"] = @"ui_order";
    helper.parameters[@"orderDir"] = @"asc";
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[StoreModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.stores = objs;
            
            weakSelf.tableView.stores = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.stores = objs;
            
            weakSelf.tableView.stores = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StoreModel *store = self.stores[indexPath.row];
    
    StoreDetailVC *detailVC = [StoreDetailVC new];
    
    detailVC.code = store.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
