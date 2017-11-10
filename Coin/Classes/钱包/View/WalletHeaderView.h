//
//  WalletHeaderView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WalletHeaderBlock)();

@interface WalletHeaderView : UIView

@property (nonatomic, copy) WalletHeaderBlock headerBlock;
//汇率
@property (nonatomic, copy) NSString *rate;

@end
