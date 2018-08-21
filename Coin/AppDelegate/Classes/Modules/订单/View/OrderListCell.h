//
//  OrderListCell.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderModel.h"

@interface OrderListCell : UITableViewCell

@property (nonatomic, strong) OrderModel *order;

+ (CGFloat)defaultCellHeight;

@end
