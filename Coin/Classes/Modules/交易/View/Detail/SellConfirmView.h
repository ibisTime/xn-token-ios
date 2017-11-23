//
//  SellConfirmView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/23.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderPriceModel.h"

typedef void(^SellConfirmBlock)(void);

@interface SellConfirmView : UIView

@property (nonatomic, copy) SellConfirmBlock confirmBlock;

@property (nonatomic, strong) OrderPriceModel *priceModel;

//显示
- (void)show;

//隐藏
- (void)hide;

@end
