//
//  SettingGroup.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingModel.h"

@interface SettingGroup : NSObject

@property (nonatomic,copy) NSArray <SettingModel *>*items;

@property (nonatomic, copy) NSArray *sections;    //分组

@end
