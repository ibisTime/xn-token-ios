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

//@property (nonatomic, strong) MineModel *mineModel;
@property (nonatomic, strong) UIButton *iconImageView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong)UIView *line;

/**
 index 传 0，1，。。。
 */
//- (void)showBadge;   //显示小红点
//
//- (void)hideBadge; //隐藏小红点

@end
