//
//  TLMakeMoney.h
//  Coin
//
//  Created by shaojianfei on 2018/8/10.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "BillModel.h"
#import "QuestionModel.h"
#import "TLtakeMoneyModel.h"
typedef void(^WalletAddBlock)(void);

@interface TLMakeMoney : TLTableView
//@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;
@property (nonatomic,strong) NSArray <QuestionModel *>*questions;
@property (nonatomic,strong) NSArray <TLtakeMoneyModel *>*Moneys;

@property (nonatomic,copy) WalletAddBlock addBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
@end
