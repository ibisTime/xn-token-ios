//
//  UserStatistics.m
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UserStatistics.h"
#import "NSNumber+Extension.h"
#import "NSString+Extension.h"
#import "CoinUtil.h"

@implementation UserStatistics


- (NSString *)goodCommentRate {
    
    if (self.beiHaoPingCount == 0) {
        
        return @"0%";
    }
    
    CGFloat rate = 100*self.beiHaoPingCount/(self.beiPingJiaCount*1.0);
    NSString *rateStr = [NSString stringWithFormat:@"%.0lf%%", rate];
    
    return rateStr;
}

- (NSString *)convertTotalTradeCountWithCoin:(NSString *)coin {
    
//    if (!self.totalTradeCount || self.totalTradeCount.length == 0) {
//        return nil;
//    }
    
    NSString *totalTradeCount = self.totalTradeCount;
    
    //
    NSString *realNum = [CoinUtil convertToRealCoin:totalTradeCount
                                               coin:coin];
    CGFloat historyNum = [[realNum convertToRealMoneyWithNum:8] doubleValue];
    
    //判断个数
    NSString *history = @"";
    
    if (historyNum == 0) {
        
        history = [NSString stringWithFormat:@"0 %@",coin];
        
    } else if (historyNum > 0 && historyNum <= 0.5) {
        
        history = [NSString stringWithFormat:@"0-0.5 %@",coin];
        
    } else if (historyNum > 0.5 && historyNum <= 1) {
        
        history = [NSString stringWithFormat:@"0.5-1 %@",coin];
        
    } else if (historyNum > 1) {
    
        history = [NSString stringWithFormat:@"%@+ %@", [realNum convertToRealMoneyWithNum:0],coin];
    }
    
    //
    return history;
    
}

@end
