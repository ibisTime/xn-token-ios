//
//  PublishSellVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishSellVC.h"
#import "PublishSellView.h"

#import "OverTimeModel.h"
#import "QuotationModel.h"

#import "APICodeMacro.h"

#import "UIBarButtonItem+convience.h"
#import "NSString+Check.h"

@interface PublishSellVC ()

@property (nonatomic, strong) PublishSellView *publishView;
//底部按钮
@property (nonatomic, strong) UIView *bottomView;
//data
@property (nonatomic, strong) NSMutableArray *timeArr;

@end

@implementation PublishSellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布出售";
    
    self.timeArr = [NSMutableArray array];
    
    //保留草稿
    [self addRightItem];
    //发布出售
    [self initPublishView];
    //获取收款期限
    [self requestOverTime];
    //查询以太币和比特币行情
    [self queryCoinQuotation];
    
}

#pragma mark - Init
- (void)addRightItem {
    
    [UIBarButtonItem addRightItemWithTitle:@"保留草稿" titleColor:kTextColor frame:CGRectMake(0, 0, 70, 44) vc:self action:@selector(keepDraft)];
}

- (void)initPublishView {
    
    CoinWeakSelf;
    
    self.publishView = [[PublishSellView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.publishView.sellBlock = ^(PublishDraftModel *draft) {
        
        [weakSelf publishAdvertisementWithDraft:draft];
    };
    
    self.publishView.backgroundColor = kBackgroundColor;
    
    [self.view addSubview:self.publishView];
}

#pragma mark - Events
- (void)keepDraft {
    
    PublishDraftModel *draft = [PublishDraftModel new];
    
    draft.protectPrice = self.publishView.lowNumTF.text;
    
    draft.premiumRate = self.publishView.premiumRateTF.text;
    
    draft.minTrade = self.publishView.minNumTF.text;
    
    draft.maxTrade = self.publishView.maxNumTF.text;
    
    draft.buyTotal = self.publishView.buyTotalTF.text;
    
    draft.payType = [NSString stringWithFormat:@"%ld", self.publishView.payTypeIndex];
    
    draft.payLimit = self.publishView.payLimitPicker.text;
    
    draft.leaveMessage = self.publishView.leaveMsgTV.text;
    
    draft.isPublish = NO;
    
    [self publishAdvertisementWithDraft:draft];
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.publishView.scrollView.contentSize = CGSizeMake(kScreenWidth, self.publishView.highSettingView.yy + 10);
}

#pragma mark - Data
- (void)requestOverTime {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625907";
    
    http.parameters[@"parentKey"] = @"trade_time_out";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <OverTimeModel *>*data = [OverTimeModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        [data enumerateObjectsUsingBlock:^(OverTimeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.timeArr addObject:obj.dvalue];
            
        }];
        
        self.publishView.timeArr = [self.timeArr copy];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)publishAdvertisementWithDraft:(PublishDraftModel *)draft {
    
    
    if (draft.isPublish) {
        
        if (![draft.protectPrice valid]) {
            
            return ;
        }
        
        if (![draft.premiumRate valid]) {
            
            [TLAlert alertWithInfo:@"请输入溢价比例"];
            return ;
        }
        
        if (![draft.protectPrice valid]) {
            
            [TLAlert alertWithInfo:@"请输入最低可成交的价格"];
            return ;
        }
        
        if (![draft.minTrade valid]) {
            
            [TLAlert alertWithInfo:@"请输入交易的最小限额"];
            return ;
        }
        
        if (![draft.maxTrade valid]) {
            
            [TLAlert alertWithInfo:@"请输入交易的最大限额"];
            return ;
        }
        
        if (![draft.buyTotal valid]) {
            
            [TLAlert alertWithInfo:@"请输入出售总量"];
            return ;
        }
        
        if (![draft.payType valid]) {
            
            [TLAlert alertWithInfo:@"请选择收款方式"];
            return ;
        }
        
        if (![draft.payLimit valid]) {
            
            [TLAlert alertWithInfo:@"请选择收款期限"];
            return ;
        }
        
        if (![draft.leaveMessage valid]) {
            
            [TLAlert alertWithInfo:@"请填写广告留言"];
            return ;
        }
        
    }
    
    CGFloat rate = [draft.premiumRate doubleValue]/100.0;
    
    NSString *premiumRate = [NSString stringWithFormat:@"%.4lf", rate];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625220";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"leaveMessage"] = draft.leaveMessage;
    http.parameters[@"maxTrade"] = draft.maxTrade;
    http.parameters[@"minTrade"] = draft.minTrade;
    http.parameters[@"onlyTrust"] = @"0";
    http.parameters[@"payLimit"] = draft.payLimit;
    http.parameters[@"payType"] = draft.payType;
    http.parameters[@"premiumRate"] = premiumRate;
    http.parameters[@"protectPrice"] = draft.protectPrice;
    //发布类型（0=存草稿，1=发布）
    http.parameters[@"publishType"] = draft.isPublish == YES ? @"1": @"0";
    http.parameters[@"totalCount"] = [draft.buyTotal convertToSysCoin];
    http.parameters[@"tradeCurrency"] = @"CNY";
    http.parameters[@"tradeCoin"] = @"ETH";
    //0=买币, 1=卖币
    http.parameters[@"tradeType"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *str = draft.isPublish == YES ? @"发布成功": @"保留成功";
        
        [TLAlert alertWithSucces:str];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAdvertiseListRefresh object:@"0"];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)queryCoinQuotation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625290";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <QuotationModel *>*data = [QuotationModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        [data enumerateObjectsUsingBlock:^(QuotationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.coin isEqualToString:@"ETH"]) {
                
                self.publishView.marketPrice = [NSString stringWithFormat:@"%.4lf", obj.mid];
                
            }
            //            else if ([obj.coin isEqualToString:@"BTC"]) {
            //
            //                self.quotationView.btcQuotation = obj;
            //
            //            }
            else {
                
                
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
