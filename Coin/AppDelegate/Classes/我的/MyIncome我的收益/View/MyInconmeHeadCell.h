//
//  MyInconmeHeadCell.h
//  Coin
//
//  Created by QinBao Zheng on 2018/10/9.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyIncomeModel.h"

@interface MyInconmeHeadCell : UITableViewCell

@property (nonatomic , strong)MyIncomeModel *model;

@property (nonatomic , strong)UIButton *earningsButton;

@property (nonatomic , strong)UIButton *backButton;

@property (nonatomic , strong)NSDictionary *dataDic;
@property (nonatomic , strong)UILabel *nameLabel;
@end
