//
//  QDetailCell.h
//  Coin
//
//  Created by shaojianfei on 2018/8/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
@interface QDetailCell : UITableViewCell
@property (nonatomic , strong) NSArray *imageArray;

@property (nonatomic ,strong) QuestionModel *model;
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *stateLab;
@end
