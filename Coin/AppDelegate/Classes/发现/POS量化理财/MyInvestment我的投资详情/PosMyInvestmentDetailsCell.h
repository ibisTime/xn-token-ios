//
//  PosMyInvestmentDetailsCell.h
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PosMyInvestmentModel.h"
@interface PosMyInvestmentDetailsCell : UITableViewCell

@property (nonatomic , strong)PosMyInvestmentModel *model;

@property (nonatomic , strong)UIButton *nameButton;
@property (nonatomic , strong)UILabel *timeLabel;
@property (nonatomic , strong)UILabel *numberLabel;
@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)UIView *line;
@property (nonatomic , strong)UILabel *shareLabel;
@property (nonatomic , strong)UILabel *earningsLabel;
@end
