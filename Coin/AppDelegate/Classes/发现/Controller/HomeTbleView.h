//
//  HomeTbleView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/10/19.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "HomeFindModel.h"
@interface HomeTbleView : TLTableView

@property (nonatomic,strong) NSArray <HomeFindModel *>*findModels;
@end
