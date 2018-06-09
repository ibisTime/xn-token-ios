//
//  AddSearchCell.h
//  ljs
//
//  Created by shaojianfei on 2018/5/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNumberModel.h"
#import "CurrencyTitleModel.h"
@interface AddSearchCell : UICollectionViewCell
@property (nonatomic , strong) AddNumberModel *numberModel;
@property (nonatomic , copy) CurrencyTitleModel *title;

@end
