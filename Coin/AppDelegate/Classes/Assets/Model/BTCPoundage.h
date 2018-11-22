//
//  BTCPoundage.h
//  Coin
//
//  Created by 郑勤宝 on 2018/10/26.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "utxoModel.h"
@interface BTCPoundage : NSObject

+(CGFloat)enterTheumber:(NSString *)number setFee:(NSString *)fee setUtxis:(NSMutableArray <utxoModel *>*)utxis;

+(CGFloat)usdtPoundage:(NSString *)number setFee:(NSString *)fee setUtxis:(NSMutableArray <utxoModel *>*)utxis;

@end
