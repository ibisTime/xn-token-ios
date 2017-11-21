//
//  TradeBuyVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TradeBuyVC.h"

#import "TradeBuyView.h"

#import "CurrencyModel.h"

@interface TradeBuyVC ()

@property (nonatomic, strong) TradeBuyView *tradeView;

@end

@implementation TradeBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购买";
    [self initTradeView];
    //获取余额
    [self getLeftAmount];
    
}

#pragma mark - Init
- (void)initTradeView {
    
    self.tradeView = [[TradeBuyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.tradeView.advertise = self.advertise;
    
    [self.view addSubview:self.tradeView];
}

#pragma mark - Data
- (void)getLeftAmount {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802503";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isList = YES;
    
    [helper modelClass:[CurrencyModel class]];
    
    [helper refresh:^(NSMutableArray <CurrencyModel *>*objs, BOOL stillHave) {
        
        [objs enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
           
            if ([obj.currency isEqualToString:@"ETH"]) {
                
                weakSelf.tradeView.leftAmount = obj.amount;
            }
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
