//
//  GlobalRevenueListCell.h
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyIncomeTopModel.h"
@interface GlobalRevenueListCell : UITableViewCell

@property (nonatomic , strong)MyIncomeTopModel *topModel;
@property (nonatomic , strong)UILabel *numberLabel;

@property (nonatomic , strong)UILabel *accountLabel;

@property (nonatomic , strong)UILabel *nameLabel;

@property (nonatomic , strong)UILabel *priceLabel;
@end
