//
//  TLMoneyDetailsHeadView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/9/26.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLtakeMoneyModel.h"
@interface TLMoneyDetailsHeadView : UIView

@property (nonatomic , strong)UILabel *priceLabel;

@property (nonatomic , strong)TLtakeMoneyModel *moneyModel;

@property (nonatomic , strong)UIImageView *backImage;
@end
