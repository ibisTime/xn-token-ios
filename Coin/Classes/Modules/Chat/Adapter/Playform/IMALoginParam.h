//
//  IMALoginParam.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <ImSDK/ImSDK.h>

/**
 *  封装用户登录参数，将参数保存到本地，以方便下次的自动登录，本类提供参数的保存，获取，判断票据是否过期等操作
 */
@interface TIMLoginParam (PlatformConfig)

- (IMAPlatformConfig *)config;
- (void)saveToLocal;

@end

@interface IMALoginParam : TIMLoginParam

@property (nonatomic, assign) NSInteger tokenTime;              // 时间戮
@property (nonatomic, strong) IMAPlatformConfig *config;        // 用户对应的配置


+ (instancetype)loadFromLocal;

// 保存至本地
- (void)saveToLocal;

// 是否过期
- (BOOL)isExpired;

// 是否有效
- (BOOL)isVailed;

@end
