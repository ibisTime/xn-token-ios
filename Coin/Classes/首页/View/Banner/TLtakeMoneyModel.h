//
//  TLtakeMoneyModel.h
//  Coin
//
//  Created by shaojianfei on 2018/8/16.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseModel.h"

@interface TLtakeMoneyModel : TLBaseModel
//产品编号
@property (nonatomic ,copy) NSString *code;
//备注
@property (nonatomic ,copy) NSString *remark;
//币种
@property (nonatomic ,copy) NSString *symbol;
//产品详情
@property (nonatomic ,copy) NSString *Description;
//预计年化收益率
@property (nonatomic ,copy) NSString *expectYield;
//实际年化收益率
@property (nonatomic ,copy) NSString *actualYield;
//产品期限（天）
@property (nonatomic ,copy) NSString *limitDays;
//起购金额
@property (nonatomic ,copy) NSString *minAmount;
//递增金额
@property (nonatomic ,copy) NSString *increAmount;
//限购金额
@property (nonatomic ,copy) NSString *limitAmount;
//募集总金额
@property (nonatomic ,copy) NSString *amount;
//可售金额
@property (nonatomic ,copy) NSString *avilAmount;
//已购金额
@property (nonatomic ,copy) NSString *saleAmount;
//募集成功金额
@property (nonatomic ,copy) NSString *successAmount;
//产品名
@property (nonatomic ,copy) NSString *name;
//产品状态
@property (nonatomic ,copy) NSString *status;
//创建时间
@property (nonatomic ,copy) NSString *createDatetime;
//募集开始时间
@property (nonatomic ,copy) NSString *startDatetime;
//募集结束时间
@property (nonatomic ,copy) NSString *endDatetime;
//起息时间
@property (nonatomic ,copy) NSString *incomeDatetime;
//到期时间
@property (nonatomic ,copy) NSString *arriveDatetime;
//还款日
@property (nonatomic ,copy) NSString *repayDatetime;
//汇款方式
@property (nonatomic ,copy) NSString *paymentType;
//审核人
@property (nonatomic ,copy) NSString *approver;
//审核时间
@property (nonatomic ,copy) NSString *approveDatetime;
//审核说明
@property (nonatomic ,copy) NSString *approveNote;
//更新人
@property (nonatomic ,copy) NSString *updater;
//更新时间
@property (nonatomic ,copy) NSString *updateDatetime;
//已购人数
@property (nonatomic ,copy) NSString *saleNum;
@end
