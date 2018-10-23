//
//  AddMoneyCell.h
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"

//@protocol AddMoneyDelegate <NSObject>
//
//-(void)SelectTheButton:(UIButton *)sender;
//
//@end

@interface AddMoneyCell : UITableViewCell

//@property (nonatomic, assign) id <AddMoneyDelegate> AddMoneyDelegate;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) CurrencyModel *currency;

@property (nonatomic , strong)AddAccoutModel *model;
@property (nonatomic, assign)NSInteger PersonalWallet;
@end
