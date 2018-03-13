//
//  TopBottomView.h
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UILabel *topLbl;
@property (nonatomic, strong) UILabel *bottomLbl;

@end
