//
//  UserStatistics.h
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface UserStatistics: TLBaseModel
//交易次数
@property (nonatomic, assign) NSInteger jiaoYiCount;
//信任人数
@property (nonatomic, assign) NSInteger beiXinRenCount;
//评论次数
@property (nonatomic, assign) NSInteger beiPingJiaCount;
//好评次数
@property (nonatomic, assign) NSInteger beiHaoPingCount;
//好评率
@property (nonatomic, copy) NSString *goodCommentRate;

@property (nonatomic, copy) NSString *totalTradeCount;


- (NSString *)convertTotalTradeCount;

@end
