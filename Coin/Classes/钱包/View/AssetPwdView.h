//
//  AssetPwdView.h
//  Coin
//
//  Created by shaojianfei on 2018/7/25.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPasswordView.h"
@interface AssetPwdView : UIView

@property (nonatomic ,strong) TTPasswordView *password;

@property (nonatomic, copy) void(^passwordBlock)(NSString *password);

@property (nonatomic, copy) void(^HiddenBlock)();

@end
