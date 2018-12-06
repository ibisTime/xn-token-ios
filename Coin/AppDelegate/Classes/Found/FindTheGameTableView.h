//
//  FindTheGameTableView.h
//  Coin
//
//  Created by 郑勤宝 on 2018/12/4.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "FindTheGameModel.h"
#import "StrategyModel.h"
@interface FindTheGameTableView : TLTableView
@property (nonatomic , strong)FindTheGameModel *GameModel;

@property (nonatomic , strong)NSMutableArray <StrategyModel *>*model;
@end
