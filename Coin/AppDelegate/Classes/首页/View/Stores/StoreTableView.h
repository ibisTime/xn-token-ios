//
//  StoreTableView.h
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLTableView.h"
//M
#import "StoreModel.h"

@interface StoreTableView : TLTableView
//
@property (nonatomic, strong) NSArray <StoreModel *>*stores;

@end
