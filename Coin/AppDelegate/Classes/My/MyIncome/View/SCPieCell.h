//
//  SCPieCell.h
//  SCChart
//
//  Created by 2014-763 on 15/3/24.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyIncomeModel.h"

@interface SCPieCell : UITableViewCell

@property (nonatomic , strong)UIButton *quantitativeButton;

@property (nonatomic , strong)UIButton *invitationButton;

@property (nonatomic , strong)UILabel *priceLabel;

@property (nonatomic , strong)MyIncomeModel *model;

@end
