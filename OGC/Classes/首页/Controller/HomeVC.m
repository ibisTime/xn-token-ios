//
//  HomeVC.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "HomeVC.h"

//Macro
//Framework
//Category
//Extension
//M
#import "StoreModel.h"
//V
#import "StoreTableView.h"
#import "HomeHeaderView.h"
//C

@interface HomeVC ()
//头部
@property (nonatomic, strong) HomeHeaderView *headerView;
//店铺
@property (nonatomic, strong) StoreTableView *tableView;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//暂无店铺
@property (nonatomic, strong) UIView *placeHolderView;
//
@property (nonatomic, strong) NSArray <StoreModel *>*stores;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    //
    [self initPlaceHolderView];
    //
    [self initTableView];
    //获取店铺列表
    [self requestStoreList];
    //
//    [self.tableView beginRefreshing];
}

#pragma mark - Init
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
    
    textLbl.text = [LangSwitcher switchLang:@"暂无店铺" key:nil];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(addressIV.mas_bottom).offset(20);
        make.centerX.equalTo(addressIV.mas_centerX);
        
    }];
    
}

- (void)initTableView {
    
    self.tableView = [[StoreTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    //头部
    self.headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(185) + 100)];
    
    self.tableView.tableHeaderView = self.headerView;
    
    NSMutableArray <StoreModel *>*arr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        StoreModel *model = [StoreModel new];
        
        model.name = @"三眼蛤蟆";
        model.slogan = @"但也仅仅事关你艺术造诣上的突破，艺考这点事，犯不上每个人都得动用自己的天赋。艺考这东西已经体制化，僵硬化了用自己的天赋。艺考这东用自己的天赋。";
        model.address = @"余姚金街853-11号";
        
        [arr addObject:model];
    }
    
    self.tableView.stores = arr;
    
    [self.tableView reloadData];
}

#pragma mark - Data
- (void)requestStoreList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"";
    helper.parameters[@""] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[StoreModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.stores = objs;
            
            weakSelf.tableView.stores = objs;
            
            [weakSelf.tableView reloadData_tl];
            //获取banner列表
            [weakSelf requestBannerList];
            
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

- (void)requestBannerList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805806";
    helper.isList = YES;
    helper.parameters[@"location"] = @"index_banner";
    helper.parameters[@"type"] = @"2";
    helper.parameters[@"orderColumn"] = @"order_no";
    helper.parameters[@"orderDir"] = @"asc";
    
    [helper modelClass:[BannerModel class]];
    
    //店铺数据
    [helper refresh:^(NSMutableArray <BannerModel *>*objs, BOOL stillHave) {
        
        weakSelf.bannerRoom = objs;
        weakSelf.headerView.banners = objs;
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
