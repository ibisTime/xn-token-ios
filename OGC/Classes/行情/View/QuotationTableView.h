//
//  QuotationTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/12/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"

#import "CoinQuotationModel.h"

@interface QuotationTableView : TLTableView

@property (nonatomic, strong) NSMutableArray <CoinQuotationModel *>*quotations;

@end
