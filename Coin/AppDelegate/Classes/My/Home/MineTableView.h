//
//  MineTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"
#import "MineGroup.h"

@interface MineTableView : TLTableView

@property (nonatomic, strong) MineGroup *mineGroup;

@property (nonatomic , strong)NSString *priceStr;

@end
