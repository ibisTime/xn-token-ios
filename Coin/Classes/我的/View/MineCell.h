//
//  MineCell.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

@interface MineCell : UITableViewCell

@property (nonatomic, strong) MineModel *mineModel;

@property (nonatomic, strong) UILabel *rightLabel;

@end
