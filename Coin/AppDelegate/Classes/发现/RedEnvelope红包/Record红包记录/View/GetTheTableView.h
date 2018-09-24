//
//  GetTheTableView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/7/3.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "GetTheModel.h"
#import "SendModel.h"
@interface GetTheTableView : TLTableView

@property (nonatomic, strong) NSMutableArray <GetTheModel *>*getthe;
@property (nonatomic, strong) NSMutableArray <SendModel *>*sends;

@property (nonatomic, assign) BOOL isRecvied;
@property (nonatomic, assign) BOOL isClose;

@end
