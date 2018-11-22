//
//  LocalBillCell.h
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillModel.h"
#import "CurrencyModel.h"
#import "USDTRecordModel.h"
@interface LocalBillCell : UITableViewCell

@property (nonatomic,strong) BillModel *billModel;

@property (nonatomic,strong) USDTRecordModel *usdtModel;

@property (nonatomic,strong) CurrencyModel *currencyModel;


@end
