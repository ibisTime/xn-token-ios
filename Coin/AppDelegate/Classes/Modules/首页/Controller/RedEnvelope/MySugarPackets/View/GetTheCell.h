//
//  GetTheCell.h
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetTheModel.h"
@interface GetTheCell : UITableViewCell

@property (nonatomic, strong)GetTheModel *getModel;

@property (nonatomic, assign) BOOL isClose;

@end
