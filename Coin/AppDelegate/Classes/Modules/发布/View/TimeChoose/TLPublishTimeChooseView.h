//
//  TLPublishTimeChooseView.h
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseModel.h"

@interface TLPublishTimeChooseView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (NSArray <NSDictionary *> *)obtainTimes;

@property (nonatomic, strong) NSArray<Displaytime *> *displayTime;

@end
