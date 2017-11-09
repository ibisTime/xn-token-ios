//
//  SettingModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

@property (nonatomic,strong) NSString *imgName;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) void(^action)();

@end
