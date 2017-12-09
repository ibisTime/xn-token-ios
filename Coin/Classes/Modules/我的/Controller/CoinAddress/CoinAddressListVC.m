//
//  CoinAddressListVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CoinAddressListVC.h"

#import "CoinAddressTableView.h"

#import "CoinAddAddressVC.h"
#import "TLPwdRelatedVC.h"

@interface CoinAddressListVC ()<RefreshDelegate>

//暂无交易
@property (nonatomic, strong) UIView *placeHolderView;
//受信任的
@property (nonatomic, strong) CoinAddressTableView *tableView;
//提币地址列表
@property (nonatomic, strong) NSMutableArray <CoinAddressModel *>*addressArr;

@end

@implementation CoinAddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LangSwitcher switchLang:@"地址管理" key:nil];
    
    //暂无地址
    [self initPlaceHolderView];
    //tableview
    [self initTableView];
    //添加新地址
    [self initAddressBtn];
    //获取关注列表
    [self requestFansList];
    
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[CoinAddressTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
        self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 60 + kBottomInsetHeight, 0));
    }];
    
}

- (void)initAddressBtn {
    
    UIView *addressView = [[UIView alloc] init];
    
    addressView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@(60 + kBottomInsetHeight));
        
    }];
    
    UIButton *addressBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"添加新地址" key:nil] titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:16.0 cornerRadius:5];
    
    [addressBtn addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [addressView addSubview:addressBtn];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);
        make.top.equalTo(@7.5);
        
    }];
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *addressIV = [[UIImageView alloc] init];
    
    addressIV.image = kImage(@"暂无订单");
    
    addressIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:addressIV];
    [addressIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = [LangSwitcher switchLang:@"暂无地址" key:nil];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(addressIV.mas_bottom).offset(20);
        make.centerX.equalTo(addressIV.mas_centerX);
        
    }];
    
}

#pragma mark - Events
- (void)addNewAddress {
    
    CoinWeakSelf;
    
    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
        
        TLPwdType pwdType = TLPwdTypeSetTrade;
        
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        
        pwdRelatedVC.success = ^{
            
            [weakSelf addNewAddress];
        };
        
        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
        
        return ;
    }
    
    CoinAddAddressVC *addVC = [CoinAddAddressVC new];
    
    addVC.success = ^{
        
        [weakSelf.tableView beginRefreshing];
    };
    
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - Data
- (void)requestFansList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
        
    helper.code = @"625205";
    helper.start = 1;
    helper.limit = 20;
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"type"] = @"Y";
    //0: 未认证 1: 已认证  2:已弃用
    helper.parameters[@"statusList"] = @[@"0", @"1"];
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CoinAddressModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray <CoinAddressModel *>*objs, BOOL stillHave) {
            
            weakSelf.addressArr = objs;
            
            weakSelf.tableView.addressArr = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView beginRefreshing];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.addressArr = objs;
            
            weakSelf.tableView.addressArr = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CoinAddressModel *addressModel = self.addressArr[indexPath.row];
    
    if (self.addressBlock) {
        
        self.addressBlock(addressModel);
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
