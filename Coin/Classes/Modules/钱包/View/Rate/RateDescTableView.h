//
//  RateDescTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"
#import "RateModel.h"

@interface RateDescTableView : TLTableView

@property (nonatomic, strong) NSArray <RateModel *>*rates;

@end
