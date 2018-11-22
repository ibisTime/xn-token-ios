//
//  HomeCell.h
//  Coin
//
//  Created by haiqingzheng on 2018/4/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFindModel.h"
@interface HomeCell : UITableViewCell

@property (nonatomic , strong)HomeFindModel *findModel;

@property (nonatomic , strong)UILabel *textLab;
@property (nonatomic , strong)UILabel *introfucec;
@property (nonatomic , strong)UIImageView *iconImageView;

@end
