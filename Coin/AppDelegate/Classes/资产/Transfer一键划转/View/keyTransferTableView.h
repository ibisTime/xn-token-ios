//
//  keyTransferTableView.h
//  Coin
//
//  Created by 郑勤宝 on 2018/10/25.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "CurrencyModel.h"
#import "TransferNumberCell.h"
@interface keyTransferTableView : TLTableView

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*models;

@property (nonatomic, strong)CurrencyModel *model;

@property (nonatomic, assign) BOOL isLocal;

@property (nonatomic , copy)NSString *poundage;

@property (nonatomic, strong)TransferNumberCell *cell;


@end
