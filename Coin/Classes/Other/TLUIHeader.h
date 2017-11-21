//
//  TLUIHeader.h
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#ifndef TLUIHeader_h
#define TLUIHeader_h

#import <Masonry/Masonry.h>

#import <UIKit/UIKit.h>

#import "UIColor+theme.h"
#import "UILable+convience.h"
#import "UIButton+Custom.h"
#import <CDCommon/UIView+Frame.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define FONT(x)    [UIFont systemFontOfSize:x]

#define CoinWeakSelf  __weak typeof(self) weakSelf = self;

#define kAdvertiseListRefresh @"kAdvertiseListRefresh"

#endif /* TLUIHeader_h */
