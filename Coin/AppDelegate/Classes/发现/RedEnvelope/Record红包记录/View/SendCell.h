//
//  SendCell.h
//  Coin
//
//  Created by QinBao Zheng on 2018/7/3.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendModel.h"
#import "GetTheModel.h"
@interface SendCell : UITableViewCell

@property (nonatomic, strong)SendModel *sendModel;
@property (nonatomic, assign) BOOL isClose;

@end
