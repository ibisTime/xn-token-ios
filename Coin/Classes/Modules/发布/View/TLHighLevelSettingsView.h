//
//  TLHighLevelSettingsView.h
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertiseModel.h"

@interface TLHighLevelSettingsView : UIButton

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UIButton *topBtn;

//任何时间
@property (nonatomic, strong) UIButton *anyTimeBtn;

//自定义
@property (nonatomic, strong) UIButton *customTimeBtn;

//仅信任的人
@property (nonatomic, strong) UIButton *onlyTrustBtn;

- (void)beginWithCustomTime;
- (void)beginWithAnyime;


- (BOOL)isCustomTime;
- (BOOL)isOnlyTrust;

- (NSArray <NSDictionary *>*)obtainDisplayTimes;

//初始化的时候加上
//@property (nonatomic, strong) NSArray<Displaytime *> *displayTime;


+ (CGFloat)normalHeight;

+ (CGFloat)fullHeight;

- (CGFloat)nextShouldHeight;

@end
