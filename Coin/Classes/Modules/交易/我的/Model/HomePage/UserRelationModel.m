//
//  UserRelationModel.m
//  Coin
//
//  Created by 蔡卓越 on 2017/12/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UserRelationModel.h"
#import "CoinUtil.h"
#import "NSString+Extension.h"

@implementation UserRelationModel

- (NSString *)goodCommentRate {
    
    if (self.beiHaoPingCount == 0) {
        
        return @"0%";
    }
    
    CGFloat rate = 100*self.beiHaoPingCount/(self.beiPingJiaCount*1.0);
    
    NSString *rateStr = [NSString stringWithFormat:@"%.0lf%%", rate];
    
    return rateStr;
}

- (NSString *)tradeAmount {
    
    NSString *numStr = [NSString stringWithFormat:@"%@", self.totalTradeCountEth];
    NSString *realNum = [CoinUtil convertToRealCoin:numStr coin:kETH];
    CGFloat historyNum = [[realNum convertToRealMoneyWithNum:8] doubleValue];
    
    //判断个数
    NSString *history = @"";
    
    if (historyNum == 0) {
        
        history = @"0 ETH";
        
    } else if (historyNum > 0 && historyNum <= 0.5) {
        
        history = @"0-0.5 ETH";
        
    } else if (historyNum > 0.5 && historyNum <= 1) {
        
        history = [NSString stringWithFormat:@"0.5-1 ETH"];
        
    } else if (historyNum > 1) {
        
        
        history = [NSString stringWithFormat:@"%@+ ETH", [realNum convertToRealMoneyWithNum:0]];
    }
    
    return history;
}

@end
