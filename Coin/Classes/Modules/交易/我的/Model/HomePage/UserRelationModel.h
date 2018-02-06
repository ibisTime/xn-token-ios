//
//  UserRelationModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/12/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface UserRelationModel : TLBaseModel
//被信任次数
@property (nonatomic, assign) NSInteger beiXinRenCount;
//master 和 visitor 之间的交易次数
@property (nonatomic, copy) NSString *betweenTradeTimes;
//是否信任（0否 1是）
@property (nonatomic, copy) NSString *isTrust;
//被好评次数
@property (nonatomic, assign) NSInteger beiHaoPingCount;
//master的交易量
//@property (nonatomic, copy) NSString *totalTradeCount;

@property (nonatomic, copy) NSString *totalTradeCountEth;
@property (nonatomic, copy) NSString *totalTradeCountSc;



//被评价次数
@property (nonatomic, assign) NSInteger beiPingJiaCount;
//master交易次数
@property (nonatomic, assign) NSInteger jiaoYiCount;
//是否黑名单（0否 1是）
@property (nonatomic, copy) NSString *isAddBlackList;
//好评率
@property (nonatomic, copy) NSString *goodCommentRate;
//交易总量
@property (nonatomic, copy) NSString *tradeAmount;

@end
