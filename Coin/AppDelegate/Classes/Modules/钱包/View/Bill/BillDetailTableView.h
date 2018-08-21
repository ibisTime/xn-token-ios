//
//  BillDetailTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTableView.h"
#import "BillModel.h"

@interface BillDetailTableView : TLTableView

@property (nonatomic, strong) BillModel *bill;

@end
