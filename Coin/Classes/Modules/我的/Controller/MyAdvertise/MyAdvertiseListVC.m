//
//  MyAdvertiseListVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MyAdvertiseListVC.h"

#import "MyAdvertiseTableView.h"

#import "PublishBuyVC.h"
#import "PublishSellVC.h"

#import "TradeBuyVC.h"
#import "TradeSellVC.h"

@interface MyAdvertiseListVC ()<RefreshDelegate>

//tableview
@property (nonatomic, strong) MyAdvertiseTableView *tableView;
//广告列表
@property (nonatomic, strong) NSArray <AdvertiseModel *>*advertises;
//暂无交易
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation MyAdvertiseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //暂无广告
    [self initPlaceHolderView];
    //
    [self initTableView];
    //获取广告列表
    [self requestAdvertiseList];
    //添加通知
    [self addNotification];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[MyAdvertiseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = self.placeHolderView;
    
    self.tableView.refreshDelegate = self;
    

    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (void)initPlaceHolderView {
    
    self.placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 40)];
    
    UIImageView *advertiseIV = [[UIImageView alloc] init];
    
    advertiseIV.image = kImage(@"暂无订单");
    
    advertiseIV.centerX = kScreenWidth/2.0;
    
    [self.placeHolderView addSubview:advertiseIV];
    
    [advertiseIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@90);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = self.type == MyAdvertiseTypeDraft ? [LangSwitcher switchLang:@"暂无草稿" key:nil]: [LangSwitcher switchLang:@"暂无交易" key:nil];
    
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.placeHolderView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(advertiseIV.mas_bottom).offset(20);
        make.centerX.equalTo(advertiseIV.mas_centerX);
        
    }];
}

- (void)addNotification {
    
    //下架
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAdvertiseList) name:kAdvertiseOff object:nil];
}

#pragma mark - Data
- (void)requestAdvertiseList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"625227";
    helper.start = 1;
    helper.limit = 10;
    helper.parameters[@"coin"] = @"ETH";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    if (self.type == MyAdvertiseTypeDraft) {
        
        helper.parameters[@"statusList"] = @[@"0"];

    } else if (self.type == MyAdvertiseTypeDidPublish) {
        
        helper.parameters[@"statusList"] = @[@"1", @"2", @"3"];

    }
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[AdvertiseModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray <AdvertiseModel *>*objs, BOOL stillHave) {
            
            weakSelf.advertises = objs;
            
            weakSelf.tableView.advertises = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView beginRefreshing];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.advertises = objs;
            
            weakSelf.tableView.advertises = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate

- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AdvertiseModel *advertiseModel = self.advertises[indexPath.row];
    
    if (self.type == MyAdvertiseTypeDraft) {
        // 草稿
        
        if ( advertiseModel.adsType == AdsTradeTypeBuy) {
            
            PublishBuyVC *buyVC = [PublishBuyVC new];
            buyVC.publishType = PublishTypePublishDraft;
            buyVC.adsCode = advertiseModel.code;
            [self.navigationController pushViewController:buyVC animated:YES];
            
        } else if (advertiseModel.adsType == AdsTradeTypeSell) {
            
            PublishSellVC *sellVC = [PublishSellVC new];
            sellVC.publishType = PublishTypePublishDraft;
            sellVC.adsCode = advertiseModel.code;
            [self.navigationController pushViewController:sellVC animated:YES];
            
        }
        
    } else if (self.type == MyAdvertiseTypeDidPublish) {
        //已发布  和 交易中的
        
        if (advertiseModel.adsType == AdsTradeTypeBuy) {
            
            //
            if ([advertiseModel.status isEqualToString:kAdsStatusDaiJiaoYi]) {
                //待交易, 可进行编辑
                PublishBuyVC *publishBuyVC = [[PublishBuyVC alloc] init];
                publishBuyVC.publishType = PublishTypePublishRedit;
                publishBuyVC.adsCode = advertiseModel.code;
                [self.navigationController pushViewController:publishBuyVC animated:YES];

                return;
            }
        
            TradeBuyVC *buyVC = [TradeBuyVC new];
            buyVC.adsCode = advertiseModel.code;
            buyVC.type = TradeBuyPositionTypeMyPublish;
            [self.navigationController pushViewController:buyVC animated:YES];
            
        } else if (advertiseModel.adsType == AdsTradeTypeSell) {
            
            if ([advertiseModel.status isEqualToString:kAdsStatusDaiJiaoYi]) {
                //待交易, 可进行编辑
                PublishSellVC *publishSellVC = [[PublishSellVC alloc] init];
                publishSellVC.publishType = PublishTypePublishRedit;
                publishSellVC.adsCode = advertiseModel.code;
                [self.navigationController pushViewController:publishSellVC animated:YES];
                
                return;
            }

            TradeSellVC *sellVC = [TradeSellVC new];
            sellVC.adsCode = advertiseModel.code;
            sellVC.type = TradeBuyPositionTypeMyPublish;
            [self.navigationController pushViewController:sellVC animated:YES];
        }
        
    }
}



@end
