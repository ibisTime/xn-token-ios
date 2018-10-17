//
//  PosMyInvestmentModel.h
//  Coin
//
//  Created by QinBao Zheng on 2018/9/27.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PosMyInvestmentModel : NSObject


@property (nonatomic , copy)NSString *status;
@property (nonatomic , copy)NSString *incomeBtc;
@property (nonatomic , copy)NSString *investAmountBtc;
@property (nonatomic , copy)NSString *productCode;
@property (nonatomic , copy)NSString *investNum;
@property (nonatomic , copy)NSString *code;
@property (nonatomic , copy)NSString *userId;
@property (nonatomic , copy)NSString *income;
@property (nonatomic , copy)NSString *leftPrincipal;
@property (nonatomic , copy)NSString *redeemAmount;
@property (nonatomic , copy)NSString *createDatetime;
@property (nonatomic , copy)NSString *investAmount;
@property (nonatomic , copy)NSString *redeemTimes;
@property (nonatomic , copy)NSString *expectIncome;
@property (nonatomic , copy)NSString *lastInvestDatetime;
@property (nonatomic , copy)NSString *saleAmount;

@property (nonatomic , strong)NSDictionary *userInfo;
@property (nonatomic , strong)NSDictionary *productInfo;


@end
