//
//  HomePageVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "CoinModel.h"

@interface HomePageVC : TLBaseVC


/**
 查询谁的信息就传哪个人的userId
 */
@property (nonatomic, copy) NSString *userId;

//查询什么币种的交易量
@property (nonatomic, strong) CoinModel *coinModel;


@end
