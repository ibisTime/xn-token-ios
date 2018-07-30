//
//  LocalSettingCell.h
//  Coin
//
//  Created by shaojianfei on 2018/7/30.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"

@interface LocalSettingCell : UITableViewCell
@property (nonatomic, strong) SettingModel *settingModel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UISwitch *sw;

@property (nonatomic, assign) BOOL arrowHidden;

@property (nonatomic, assign) BOOL switchHidden;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, copy) void (^ SwitchBlock) (NSInteger switchBlock);
@end
