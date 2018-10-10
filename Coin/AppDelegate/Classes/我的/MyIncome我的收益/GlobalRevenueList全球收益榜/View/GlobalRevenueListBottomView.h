//
//  GlobalRevenueListBottomView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyIncomeTopModel.h"
@interface GlobalRevenueListBottomView : UIView
@property (nonatomic , strong)MyIncomeTopModel *model;

@property (nonatomic , strong)UILabel *nameLabel;

@property (nonatomic , strong)UILabel *earningsLabel;

@property (nonatomic , strong)UILabel *rankingLabel;

@property (nonatomic , strong)UILabel *priceLabel;



@end
