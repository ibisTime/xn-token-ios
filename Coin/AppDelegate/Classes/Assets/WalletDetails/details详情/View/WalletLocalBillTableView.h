//
//  WalletLocalBillTableView.h
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "BillModel.h"
#import "CurrencyModel.h"
#import "USDTRecordModel.h"
@interface WalletLocalBillTableView : TLTableView
@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;
@property (nonatomic,strong) CurrencyModel *billModel;
@property (nonatomic,strong) NSMutableArray <USDTRecordModel *>*ustds;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
