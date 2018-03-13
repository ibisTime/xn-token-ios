//
//  TLSingleTimeView.h
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseModel.h"

@interface TLSingleTimeView : UIButton

@property (nonatomic, strong) UILabel *weekLbl;
@property (nonatomic, strong) UILabel *beginTimeLbl;
@property (nonatomic, strong) UILabel *endTimeLbl;


/**
 2次编辑应该从外面传入，
 */
@property (nonatomic, strong) Displaytime *displayTime;

@end
