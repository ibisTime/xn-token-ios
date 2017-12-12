//
//  SettingModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *subText;

@property (nonatomic, copy) void(^action)();

@property (nonatomic, assign) BOOL isSelect;

@end
