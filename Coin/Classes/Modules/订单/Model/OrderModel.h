//
//  OrderModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "UserInfo.h"

@interface OrderModel : TLBaseModel

@property (nonatomic, copy) NSString *updateDatatime;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *buyUser;

@property (nonatomic, copy) NSString *leaveMessage;

@property (nonatomic, copy) NSString *tradeCoin;

@property (nonatomic, copy) NSString *tradeAmount;

@property (nonatomic, copy) NSString *countString;

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) NSString *feeString;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, strong) UserInfo *sellUserInfo;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *invalidDatetime;

@property (nonatomic, copy) NSString *sellUser;

@property (nonatomic, strong) NSNumber *tradePrice;

@property (nonatomic, strong) UserInfo *buyUserInfo;

@property (nonatomic, copy) NSString *markDatetime;

@property (nonatomic, copy) NSString *adsCode;

@property (nonatomic, copy) NSString *tradeCurrency;

@property (nonatomic, copy) NSString *remark;
//买家评价内容(buy to sell)
@property (nonatomic, copy) NSString *bsComment;
//卖家评价内容(sell to buy)
@property (nonatomic, copy) NSString *sbComment;
//订单
@property (nonatomic, copy) NSString *statusStr;
//昵称
@property (nonatomic, copy) NSString *nickName;
//头像
@property (nonatomic, copy) NSString *photo;
//是不是买家
@property (nonatomic, assign) BOOL isBuy;
//按钮文字
@property (nonatomic, copy) NSString *btnTitle;
//按钮背景颜色
@property (nonatomic, strong) UIColor *bgColor;
//是否可点击
@property (nonatomic, assign) BOOL enable;
//提示
@property (nonatomic, strong) NSString *promptStr;

+ (NSArray *)endStatusList;
+ (NSArray *)ingStatusList;

@end

FOUNDATION_EXTERN NSString * const kTradeOrderStatusToSubmit;
FOUNDATION_EXTERN NSString * const kTradeOrderStatusToPay;
FOUNDATION_EXTERN NSString * const kTradeOrderStatusPayed;
FOUNDATION_EXTERN NSString * const kTradeOrderStatusReleased;
FOUNDATION_EXTERN NSString * const kTradeOrderStatusComplete;
FOUNDATION_EXTERN NSString * const kTradeOrderStatusCancel;
FOUNDATION_EXTERN NSString * const kTradeOrderStatusArbitrate;


