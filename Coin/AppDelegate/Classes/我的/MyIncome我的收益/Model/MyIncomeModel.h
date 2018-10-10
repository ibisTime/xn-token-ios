//
//  MyIncomeModel.h
//  Coin
//
//  Created by QinBao Zheng on 2018/10/10.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyIncomeModel : NSObject
@property (nonatomic , copy)NSString *incomeInvite;
@property (nonatomic , copy)NSString *incomePop;
@property (nonatomic , copy)NSString *incomeRatioInvite;
@property (nonatomic , copy)NSString *incomeRatioPop;
@property (nonatomic , copy)NSString *incomeTotal;
@property (nonatomic , copy)NSString *incomeYesterday;
@property (nonatomic , copy)NSString *userId;
@property (nonatomic , strong)NSDictionary *top5;


@end
