//
//  QuestionDetail.h
//  Coin
//
//  Created by shaojianfei on 2018/8/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "QuestionModel.h"
typedef void(^WalletAddBlock)(void);

@interface QuestionDetail : TLTableView

@property (nonatomic,strong)  QuestionModel *model;

@property (nonatomic,strong) NSArray <QuestionModel *>*questions;

@property (nonatomic,copy) WalletAddBlock addBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
@end
