//
//  AdsService.m
//  Coin
//
//  Created by  tianlei on 2017/12/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AdsService.h"
#import "AdvertiseModel.h"
#import "PublishBuyVC.h"
#import "TradeSellVC.h"
#import "TLPublishVC.h"
//
#import "TradeBuyVC.h"
//
#import "PublishSellVC.h"

@implementation AdsService

+ (void)pushToAdsDetail:(AdvertiseModel *)advertiseModel currentVC:(UIViewController *)currentVC {
    
    
    

    
    
    if ([advertiseModel.tradeType isEqualToString:kAdsTradeTypeSell]) {
        //卖币广高， 我要购买
        
        //1.1.1 待交易也可以下架
        if ([advertiseModel isMineAds]) {

            TLPublishVC *sellVC = [[TLPublishVC alloc] init];
            sellVC.adsCode = advertiseModel.code;
            sellVC.publishType = PublishTypePublishRedit;
            sellVC.VCType = TLPublishVCTypeSell;
            [currentVC.navigationController pushViewController:sellVC animated:YES];

//            PublishSellVC *sellVC = [[PublishSellVC alloc] init];
//            sellVC.adsCode = advertiseModel.code;
//            sellVC.publishType = PublishTypePublishRedit;
//            [currentVC.navigationController pushViewController:sellVC animated:YES];
            return;

        }
        
        TradeBuyVC *buyVC = [TradeBuyVC new];
        buyVC.adsCode = advertiseModel.code;
        //        buyVC.type = TradeBuyPositionTypeTrade;
        [currentVC.navigationController pushViewController:buyVC animated:YES];
        
    } else if([advertiseModel.tradeType isEqualToString:kAdsTradeTypeBuy]) {
        //买币广高， 我要出售

        //1.1.1 待交易也可以下架
        if ([advertiseModel isMineAds]) {
            
            TLPublishVC *buyVC = [[TLPublishVC alloc] init];
            buyVC.adsCode = advertiseModel.code;
            buyVC.publishType = PublishTypePublishRedit;
            buyVC.VCType = TLPublishVCTypeBuy;
            [currentVC.navigationController pushViewController:buyVC animated:YES];
            
//            PublishBuyVC *buyVC = [[PublishBuyVC alloc] init];
//            buyVC.adsCode = advertiseModel.code;
//            buyVC.publishType = PublishTypePublishRedit;
//            [currentVC.navigationController pushViewController:buyVC animated:YES];
            return;
 
        }
        
        TradeSellVC *sellVC = [TradeSellVC new];
        sellVC.adsCode = advertiseModel.code;
        //        sellVC.type = TradeBuyPositionTypeTrade;
        [currentVC.navigationController pushViewController:sellVC animated:YES];
        
    }
    
}

@end
