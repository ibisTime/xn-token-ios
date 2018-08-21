//
//  LocalSettingTableView.h
//  Coin
//
//  Created by shaojianfei on 2018/7/30.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTableView.h"
#import "SettingGroup.h"

@interface LocalSettingTableView : TLTableView
@property (nonatomic, strong) SettingGroup *group;
@property (nonatomic, copy) void (^ SwitchBlock) (NSInteger switchBlock);
@end
