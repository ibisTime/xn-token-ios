//
//  PayTypeView.h
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayTypeModel.h"

@interface PayTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, strong) PayTypeModel *payType;

@end
