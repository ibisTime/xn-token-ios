//
//  AdsDetailUserView.h
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseModel.h"

@interface AdsDetailUserView : UIButton

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) AdvertiseModel *ads;

@end
