//
//  PublishTipView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PublishTipEventBlock)(NSInteger index);

@interface PublishTipView : UIView

@property (nonatomic, strong) PublishTipEventBlock publishBlock;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles;

- (void)show;

- (void)hide;

@end
