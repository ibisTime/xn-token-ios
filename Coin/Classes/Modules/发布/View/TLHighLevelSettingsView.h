//
//  TLHighLevelSettingsView.h
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLHighLevelSettingsView : UIButton

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UIButton *topBtn;

+ (CGFloat)normalHeight;

+ (CGFloat)fullHeight;

- (CGFloat)nextShouldHeight;

@end
