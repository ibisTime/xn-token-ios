//
//  WalletCell.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"
#import "CurrencyModel.h"

@interface WalletCell : UITableViewCell

@property (nonatomic, strong) CurrencyModel *currency;
//充币
@property (nonatomic, strong) UIButton *rechargeBtn;
//提币
@property (nonatomic, strong) UIButton *withdrawalsBtn;
//账单
@property (nonatomic, strong) UIButton *billBtn;
//冻结金额
@property (nonatomic, strong) UIButton *freezingAmountBtn;

@end
