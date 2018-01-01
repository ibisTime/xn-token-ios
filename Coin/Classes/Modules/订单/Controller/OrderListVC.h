//
//  OrderListVC.h
//  Coin
//
//  Created by  tianlei on 2017/12/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "OrderModel.h"

@interface OrderListVC : TLBaseVC

@property (nonatomic, copy) NSArray *statusList;
@property (nonatomic,strong) NSMutableArray <OrderModel *>*orderGroups;
//@property (nonatomic, copy) NSString *belongUser;
@property (nonatomic, strong) TLPageDataHelper *pageDataHelper;

- (void)refresh;
- (void)reloadData;

@end
