//
//  CoinAddressListVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CoinAddressListVC.h"

#import "CoinAddressTableView.h"
#import "CoinService.h"
#import "CoinAddAddressVC.h"
#import "TLPwdRelatedVC.h"
#import "CoinChangeView.h"
#import "FilterView.h"

@interface CoinAddressListVC ()<RefreshDelegate>

//暂无交易
@property (nonatomic, strong) UIView *placeHolderView;
//受信任的
@property (nonatomic, strong) CoinAddressTableView *tableView;
//提币地址列表
@property (nonatomic, strong) NSMutableArray <CoinAddressModel *>*addressArr;
@property (nonatomic, strong) CoinChangeView *topTitleView;
@property (nonatomic, strong) FilterView *filterPicker;
@property (nonatomic, strong) TLPageDataHelper *helper;
@property (nonatomic, strong) NSString *chooseCoin;

@end

@implementation CoinAddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isCanLookManyCoin) {
        
        self.chooseCoin = self.coin;
        CoinChangeView *topTitleView = [[CoinChangeView alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
        topTitleView.title = [self titleWithCoin:kETH];
        self.navigationItem.titleView = topTitleView;
        self.topTitleView = topTitleView;
        [topTitleView addTarget:self
                         action:@selector(changeCoin)
               forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
        self.title = [LangSwitcher switchLang:@"地址管理" key:nil];

    }
    
    if (!self.coin) {
    
        NSLog(@"请传入提现地址");
        return;
        
    }
    
    //暂无地址
    [self initPlaceHolderView];
    //tableview
    [self initTableView];
    //添加新地址
    [self initAddressBtn];
    //获取关注列表
    [self requestFansList];
    
}




- (NSString *)titleWithCoin:(NSString *)currentCoin {
    
    return [NSString stringWithFormat:@"地址管理（%@）",currentCoin];
    
}

- (void)changeCoin {
    
    [self.filterPicker show];
    
}

#pragma mark- 币种切换事件
- (FilterView *)filterPicker {
    
    if (!_filterPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = [CoinUtil shouldDisplayCoinArray];
        
        //        NSArray *typeArr = @[@"", @"charge", @"withdraw", @"buy", @"sell"];
        
        _filterPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _filterPicker.title = @"请选择货币类型";
        _filterPicker.tagNames = textArr;
        _filterPicker.selectBlock2 = ^(NSInteger index,NSString *tagName) {
            
            //进行界面刷新
            weakSelf.topTitleView.title = [weakSelf titleWithCoin:tagName];
            [weakSelf changeCoin:tagName helper:weakSelf.helper];
            [weakSelf.tableView beginRefreshing];
            weakSelf.chooseCoin = tagName;
        };
        
    }
    
    return _filterPicker;
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[CoinAddressTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    self.tableView.estimatedRowHeight = 60;
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
    
    if (self.isCanLookManyCoin) {
        
        addVC.coin = self.chooseCoin;

    } else {
        
        addVC.coin = self.coin;

    }
    addVC.success = ^{
        
        [weakSelf.tableView beginRefreshing];
    };
    
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)changeCoin:(NSString *)coin helper:(TLPageDataHelper *)helper {
    
    helper.parameters[@"currency"] = coin;

}
#pragma mark - Data
- (void)requestFansList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
        
    helper.code = @"802175";
    helper.start = 1;
    helper.limit = 20;
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;
    helper.parameters[@"type"] = @"Y";
    //0: 未认证 1: 已认证  2:已弃用
    helper.parameters[@"statusList"] = @[@"0", @"1"];
    helper.tableView = self.tableView;
    [helper modelClass:[CoinAddressModel class]];
    self.helper = helper;
    [self changeCoin:self.coin helper:helper];
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


@end
