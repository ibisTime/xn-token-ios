//
//  AdsDetailBottomOpView.h
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 站在用户的角度，不是发布者的角度
 */
typedef NS_ENUM(NSUInteger, AdsDetailBottomOpType) {
    
    AdsDetailBottomOpTypeSell, //我要出售
    AdsDetailBottomOpTypeBuy //我要购买
    
};

@interface AdsDetailBottomOpView : UIView

- (instancetype)initWithFrame:(CGRect)frame;


@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UIButton *opBtn;

@property (nonatomic, assign) AdsDetailBottomOpType opType;

@end
