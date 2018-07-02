//
//  TLAccountTableView.h
//  Coin
//
//  Created by shaojianfei on 2018/6/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "CurrencyModel.h"

typedef void(^selectCurrent)(NSInteger );

@interface TLAccountTableView : TLTableView

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*platforms;
//类型
//@property (nonatomic, assign) PlatformType type;

@property (nonatomic,copy) selectCurrent selectBlock;
@end
