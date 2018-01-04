//
//  PublishBuyVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishBuyVC.h"
#import "PublishBuyView.h"

#import "OverTimeModel.h"
#import "QuotationModel.h"
#import "KeyValueModel.h"

#import "APICodeMacro.h"

#import "UIBarButtonItem+convience.h"
#import "NSString+Check.h"
#import "PublishService.h"

@interface PublishBuyVC ()
//
@property (nonatomic, strong) PublishBuyView *publishView;
//底部按钮
@property (nonatomic, strong) UIView *bottomView;
//data
@property (nonatomic, strong) NSMutableArray *timeArr;
//key/value
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*values;

//穿进去的广告模型
@property (nonatomic, strong) AdvertiseModel *advertise;

@end

@implementation PublishBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = [LangSwitcher switchLang:@"发布购买" key:nil];
    
    self.timeArr = [NSMutableArray array];
    
    
    if (self.publishType == PublishTypePublishOrSaveDraft) {
        
        [self loadInfo];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"625226";
    http.parameters[@"adsCode"] = self.adsCode;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self loadInfo];
        self.advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
        self.publishView.advertise = self.advertise;
        
    } failure:^(NSError *error) {
        
        
    }];
  
}

- (void)loadInfo {
    
    
    [self addRightItem];
    //发布购买
    [self initPublishView];
    //获取付款期限
    [self requestOverTime];
    //查询以太币和比特币行情
    [self queryCoinQuotation];
    //获取提示
    [self requestTradeRemind];
}

#pragma mark - Init
- (void)addRightItem {
    
    if (self.publishType == PublishTypePublishOrSaveDraft) {
        
        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"保存草稿" key:nil]
                                    titleColor:kTextColor
                                         frame:CGRectMake(0, 0, 70, 44)
                                            vc:self
                                        action:@selector(keepDraft)];

    }else if (self.publishType == PublishTypePublishRedit) {
        //重新编辑，为下架
        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"下架" key:nil]
                                    titleColor:kTextColor
                                         frame:CGRectMake(0, 0, 70, 44)
                                            vc:self
                                        action:@selector(xiaJia)];
        
    }
    
    
}

#pragma mark- 重新编辑时，右上角为下架
//下架广告
- (void)xiaJia {
    
    CoinWeakSelf;
    
    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"提示" key:nil]
                        msg:[LangSwitcher switchLang:@"您确定要下架此广告?" key:nil]
                 confirmMsg:[LangSwitcher switchLang:@"确认" key:nil]
                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                     cancle:^(UIAlertAction *action) {
        
        
    } confirm:^(UIAlertAction *action) {
        
        [weakSelf requestAdvertiseOff];
    }];
    
}

//下架广告
- (void)requestAdvertiseOff {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625224";
    http.showView = self.view;
    http.parameters[@"adsCode"] = self.advertise.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"下架成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAdvertiseOff object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)initPublishView {
    
    CoinWeakSelf;
    
    self.publishView = [[PublishBuyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.publishView.buyBlock = ^(PublishDraftModel *draft) {
        
        [weakSelf publishAdvertisementWithDraft:draft];
    };
    
    self.publishView.backgroundColor = kBackgroundColor;
    
    [self.view addSubview:self.publishView];
}

#pragma mark - Events
- (void)keepDraft {
    
    PublishDraftModel *draft = [PublishDraftModel new];
    
    draft.protectPrice = self.publishView.highNumTF.text;

    draft.premiumRate = self.publishView.premiumRateTF.text;
    
    draft.minTrade = self.publishView.minNumTF.text;
    
    draft.maxTrade = self.publishView.maxNumTF.text;
    
    draft.buyTotal = self.publishView.buyTotalTF.text;
    
    draft.payType = [NSString stringWithFormat:@"%ld", self.publishView.payTypeIndex];
    
    draft.payLimit = self.publishView.payLimitPicker.text;
    
    draft.leaveMessage = self.publishView.leaveMsgTV.text;
    
    draft.isPublish = NO;
    
    draft.onlyTrust = [NSString stringWithFormat:@"%d", self.publishView.onlyTrustBtn.selected];

    [self publishAdvertisementWithDraft:draft];
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.publishView.scrollView.contentSize = CGSizeMake(kScreenWidth, self.publishView.highSettingView.yy);
}

#pragma mark - Data
- (void)requestOverTime {
    
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"625907";
    http.parameters[@"parentKey"] = @"trade_time_out";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <OverTimeModel *>*data = [OverTimeModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        [[data reversedArray] enumerateObjectsUsingBlock:^(OverTimeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.timeArr addObject:obj.dvalue];

        }];
        
        self.publishView.timeArr = [self.timeArr copy];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)publishAdvertisementWithDraft:(PublishDraftModel *)draft {
    
    CoinWeakSelf;
    
    if (![draft.premiumRate valid]) {
        
        

        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入溢价比例" key:nil]];
        return ;
    }
    
    if (![draft.protectPrice valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入最高可成交的价格" key:nil]];
        return ;
    }
    
    if (![draft.minTrade valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入交易的最小限额" key:nil]];
        return ;
    }
    
    if (![draft.maxTrade valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入交易的最大限额" key:nil]];
        return ;
    }
    
    if (![draft.buyTotal valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入购买总量" key:nil]];
        return ;
    }
    
    if (![draft.payType valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请选择付款方式" key:nil]];
        return ;
    }
    
    if (![draft.payLimit valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请选择付款期限" key:nil]];
        return ;
    }
    
    if (![draft.leaveMessage valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请填写广告留言" key:nil]];
        return ;
    }
    
    CGFloat rate = [draft.premiumRate doubleValue]/100.0;
    
    NSString *premiumRate = [NSString stringWithFormat:@"%.2lf", rate];
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"625220";
    http.showView = self.view;
   
    if (self.publishType == PublishTypePublishDraft) {
        
        http.parameters[@"publishType"] = kPublishDraft;
        http.parameters[@"adsCode"] = self.advertise.code;
        
        //
    } else if (self.publishType == PublishTypePublishRedit) {
        
        //
        http.parameters[@"publishType"] = kPublishRedit;
        http.parameters[@"adsCode"] = self.advertise.code;
        
    } else if (self.publishType == PublishTypePublishOrSaveDraft) {
        
        //发布或者存草稿
        http.parameters[@"publishType"] = draft.isPublish == YES ? kPublish : kSaveDraft;
        
    }

    //
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"leaveMessage"] = draft.leaveMessage;
    http.parameters[@"maxTrade"] = draft.maxTrade;
    http.parameters[@"minTrade"] = draft.minTrade;
    http.parameters[@"onlyTrust"] = draft.onlyTrust;
    http.parameters[@"payLimit"] = draft.payLimit;
    http.parameters[@"payType"] = draft.payType;
    http.parameters[@"premiumRate"] = premiumRate;
    http.parameters[@"protectPrice"] = draft.protectPrice;
    //
    http.parameters[@"totalCount"] = [draft.buyTotal convertToSysCoin];
    http.parameters[@"tradeCurrency"] = @"CNY";
    http.parameters[@"tradeCoin"] = @"ETH";
    //0=买币, 1=卖币
    http.parameters[@"tradeType"] = @"0";
    
    if (!self.publishView.anyTimeBtn.selected &&
        !self.publishView.startHourArr &&
        self.publishView.startHourArr.count > 0) {
        
        NSMutableArray *timeArr = [NSMutableArray array];
        
        [self.publishView.startHourArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *weekDay = [NSString stringWithFormat:@"%ld", idx+1];
            
            NSDictionary *temp = @{@"startTime": obj,
                                   @"endTime": weakSelf.publishView.endHourArr[idx],
                                   @"week": weekDay,
                                   };
            
            [timeArr addObject:temp];
        }];
        
        http.parameters[@"displayTime"] = timeArr;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *str = draft.isPublish == YES ? @"发布成功": @"保存成功";
        
        [TLAlert alertWithSucces:str];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.tabBarController.selectedIndex = 2;
            
            [self.navigationController popToRootViewControllerAnimated:YES];

        });
        
        if (draft.isPublish == YES) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kAdvertiseListRefresh object:@"1"];

        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)queryCoinQuotation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625292";
    http.parameters[@"coin"] = @"ETH";
    
    [http postWithSuccess:^(id responseObject) {
        
        QuotationModel *model = [QuotationModel tl_objectWithDictionary:responseObject[@"data"]];
        self.publishView.marketPrice = [NSString stringWithFormat:@"%.2lf", [model.mid doubleValue]];

        
//        NSArray <QuotationModel *>*data = [QuotationModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
//
//        [data enumerateObjectsUsingBlock:^(QuotationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if ([obj.coin isEqualToString:@"ETH"]) {
//
//                self.publishView.marketPrice = [NSString stringWithFormat:@"%.4lf", [obj.mid doubleValue]];
//
//            }
////            else if ([obj.coin isEqualToString:@"BTC"]) {
////
////                self.quotationView.btcQuotation = obj;
////
////            }
//            else {
//
//
//            }
//        }];
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestTradeRemind {
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"625915";
    
    helper.start = 1;
    helper.limit = 30;
    helper.parameters[@"type"] = @"buy_ads_hint";
    [helper modelClass:[KeyValueModel class]];
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.publishView.values = objs;
        
    } failure:^(NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
