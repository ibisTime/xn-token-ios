//
//  TransformCell.h
//  Coin
//
//  Created by shaojianfei on 2018/9/10.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNumberModel.h"
#import "CurrencyTitleModel.h"
#import "CurrencyModel.h"
@interface TransformCell : UICollectionViewCell
@property (nonatomic , strong) AddNumberModel *numberModel;
@property (nonatomic , copy) CurrencyTitleModel *title;
@property (nonatomic , strong) CurrencyModel *model;
@property (nonatomic , assign) BOOL isClick;

@end
