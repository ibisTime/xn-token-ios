//
//  PosBuyBalanceCell.h
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
@interface PosBuyBalanceCell : UITableViewCell
@property (nonatomic , strong)UILabel *nameLabel;
@property (nonatomic , strong)UIButton *intoButton;
@property (nonatomic, strong)CurrencyModel *currencys;
@end
