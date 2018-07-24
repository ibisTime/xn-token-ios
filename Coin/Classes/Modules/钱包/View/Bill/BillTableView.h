//
//  BillTableView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillModel.h"
#import "TLTableView.h"
typedef void(^WalletAddBlock)(void);

@interface BillTableView : TLTableView

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;

@property (nonatomic,copy) WalletAddBlock addBlock;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
