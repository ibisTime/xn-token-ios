//
//  IMAUser.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IMAUser : NSObject<IMAUserShowAble, IMAContactItemShowAble>
{
@protected
    NSString    *_userId;       // app对应的帐号
    NSString    *_icon;         // 头像
    NSString    *_remark;       // 名称
    NSString    *_nickName;     // 备注名
}

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *remark;


@property (nonatomic, assign) BOOL isSelected;  // for 好友选择界面

- (instancetype)initWith:(NSString *)userid;

- (instancetype)initWithUserInfo:(TIMUserProfile *)userprofile;

- (BOOL)isC2CType;

- (BOOL)isGroupType;

- (BOOL)isSystemType;

@end

