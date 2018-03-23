//
//  OrderListVC.h
//  Coin
//
//  Created by  tianlei on 2017/12/11.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "OrderModel.h"

@protocol OrderListVCLoadDelegate<NSObject>

- (void)loadFinsh:(UIViewController *)vc orderGroups:(NSMutableArray <OrderModel *>* )orderGroups;

@end

@interface OrderListVC : TLBaseVC

@property (nonatomic, copy) NSArray <NSString *> *statusList;
@property (nonatomic, copy) NSString *tradeCoin;
@property (nonatomic,strong) NSMutableArray <OrderModel *>*orderGroups;
//@property (nonatomic, copy) NSString *belongUser;
@property (nonatomic, strong) TLPageDataHelper *pageDataHelper;
@property (nonatomic, weak) id<OrderListVCLoadDelegate> delegate;

- (void)refresh;
- (void)reloadData;

@end
