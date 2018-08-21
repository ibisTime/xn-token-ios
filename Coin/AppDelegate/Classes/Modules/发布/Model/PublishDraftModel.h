//
//  PublishDraftModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface PublishDraftModel : TLBaseModel
//溢价比例
@property (nonatomic, copy) NSString *premiumRate;
//保护价（最低价）
@property (nonatomic, copy) NSString *protectPrice;
//单笔最小交易额
@property (nonatomic, strong) NSString *minTrade;
//单笔最大交易额
@property (nonatomic, strong) NSString *maxTrade;
//购买总数
@property (nonatomic, copy) NSString *buyTotal;
//支付类型
@property (nonatomic, copy) NSString *payType;
//支付期限
@property (nonatomic, copy) NSString *payLimit;
//广告留言
@property (nonatomic, copy) NSString *leaveMessage;
//币种
@property (nonatomic, copy) NSString *tradeCoin;
//货币种类
@property (nonatomic, copy) NSString *tradeCurrency;
//高级设置
//0=任何人都可以交易、1=只有受信任的人可以交易
@property (nonatomic, copy) NSString *onlyTrust;

//时间数组
@property (nonatomic, strong) NSArray *timeArr;

/**
 发布类型（0=存草稿，1=发布）,不是广告本身属性，仅发布时使用
 */
@property (nonatomic, assign) BOOL isPublish;

@end

