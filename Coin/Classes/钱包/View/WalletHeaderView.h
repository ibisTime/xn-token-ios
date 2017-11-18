//
//  WalletHeaderView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WalletHeaderBlock)(void);

@interface WalletHeaderView : UIView

@property (nonatomic, copy) WalletHeaderBlock headerBlock;
//美元汇率
@property (nonatomic, copy) NSString *usdRate;
//港元汇率
@property (nonatomic, copy) NSString *hkdRate;

@end
