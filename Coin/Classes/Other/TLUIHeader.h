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
#import "LangSwitcher.h"
#import "TLPlaceholderView.h"

//基类
#import "TLBaseLabel.h"

//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define FONT(x)    [UIFont systemFontOfSize:x]

#define CoinWeakSelf  __weak typeof(self) weakSelf = self;
//刷新广告列表
#define kAdvertiseListRefresh @"kAdvertiseListRefresh"
//信任
#define kTrustNotification  @"kTrustNotification"
//广告下架
#define kAdvertiseOff       @"kAdvertiseOff"
//提币成功
#define kWithDrawCoinSuccess @"kWithDrawCoinSuccess"
//聊天登录成功
#define kIMLoginNotification @"kIMLoginNotification"
//刷新订单列表
#define kOrderListRefresh   @"kOrderListRefresh"

#endif /* TLUIHeader_h */
