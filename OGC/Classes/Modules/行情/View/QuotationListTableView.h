//
//  QuotationListTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"
#import "QuotationModel.h"

@interface QuotationListTableView : TLTableView

@property (nonatomic, strong) NSArray <QuotationModel *>*quotations;

@end
