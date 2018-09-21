//
//  JoinMineTableView.h
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "JoinModel.h"
@interface JoinMineTableView : TLTableView

@property (nonatomic , strong) NSMutableArray <JoinModel *>*models;
@end
