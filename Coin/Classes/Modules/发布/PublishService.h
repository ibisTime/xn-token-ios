//
//  PublishService.h
//  Coin
//
//  Created by  tianlei on 2017/12/07.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PublishType) {
    
    //以下 2 种方式，在 设置VC type时 应该不会单独出现
    PublishTypeSaveDraft = 0,  //发布
    PublishTypePublish = 1,
    
    // 以上两种在实际场景中未应用
    PublishTypePublishOrSaveDraft = 2, // 首次编辑， 可能为直接发布，也可能是保存草稿
    
    PublishTypePublishDraft = 3, //草稿发布
    PublishTypePublishRedit = 4  //重新编辑发布
    
};

@interface PublishService : NSObject

+ (NSString *)publishCodeByType:(PublishType) type;

+ (instancetype)shareInstance;

/**
 根据请求返回结果，获取超时时间
 */
- (void)handleOutLimitTime:(NSArray *)arr;
- (NSArray <NSString *> *)obtainLimitTimes;
//+ (NSArray <NSString *> *)timesArrayByRes:(NSArray *)arr;

- (void)handleHint:(id)res;

/**
 必须调用这个方法进行配置，才能区分买 卖
 */
- (void)configWith:(NSString *)tradeType;

//read-only
@property (nonatomic, copy) NSString *tradeType;
@property (nonatomic, copy) NSString *publishTitle;
//
@property (nonatomic, copy) NSString *ads_hint_key;
@property (nonatomic, copy) NSString *totalCountHintText;
@property (nonatomic, copy) NSString *totalCountHintPlaceholder;



// 余额高度
@property (nonatomic, assign) CGFloat balanceHeight;
@property (nonatomic, copy) NSString *protectPricePlaceholder;
@property (nonatomic, copy) NSString *protectPriceDisplay;


//获取的交易提醒
@property (nonatomic, copy) NSString *trust;
@property (nonatomic, copy) NSString *displayTime;
@property (nonatomic, copy) NSString *protectPrice;
@property (nonatomic, copy) NSString *totalCount;
@property (nonatomic, copy) NSString *maxTrade;
@property (nonatomic, copy) NSString *minTrade;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *premiumRate;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *payLimit;




//        @"trust"
//        @"displayTime"
//        @"protectPrice"
//        @"totalCount"
//        @"maxTrade"
//        @"minTrade"
//        @"payType"
//        @"premiumRate"
//        @"price"

- (void)publishSell:(UINavigationController *)navCtrl;
- (void)publishBuy:(UINavigationController *)navCtrl;


- (NSString *)convertHangQing:(NSString *)hangQing;

+ (BOOL)isDevPublish;

@end

FOUNDATION_EXTERN NSString *const kPublishTradeTypeSell;
FOUNDATION_EXTERN NSString *const kPublishTradeTypeBuy;

FOUNDATION_EXTERN NSString *const kSaveDraft;
FOUNDATION_EXTERN NSString *const kPublish;
FOUNDATION_EXTERN NSString *const kPublishDraft;
FOUNDATION_EXTERN NSString *const kPublishRedit;
