//
//  WallAccountHeadView.h
//  Coin
//
//  Created by shaojianfei on 2018/6/6.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
#import "TLUser.h"
@interface WallAccountHeadView : UIView
@property (nonatomic , strong) CurrencyModel *currency;
@property (nonatomic , assign) BOOL ISLocal;

@end
