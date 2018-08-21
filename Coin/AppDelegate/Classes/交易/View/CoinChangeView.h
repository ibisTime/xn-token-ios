//
//  CoinChangeView.h
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinChangeView : UIButton

/**
 ios11 下 frame 可已为CGRectZero
 */
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, copy) NSString *title;

@end
