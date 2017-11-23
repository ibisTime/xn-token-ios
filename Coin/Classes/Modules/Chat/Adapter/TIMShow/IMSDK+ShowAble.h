//
//  IMSDK+ShowAble.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <ImSDK/ImSDK.h>
#import <IMFriendshipExt/IMFriendshipExt.h>
#import <IMGroupExt/IMGroupExt.h>

// 为方便界面使用IMSDK里面的对象
// 将需要的转换成界面显示的接口

@interface TIMUserProfile (ShowAble)<IMAUserShowAble>

- (NSString *)getAllowType;
+ (NSDictionary *)allowTypeTips;

@end

@interface TIMFriendPendencyItem (ShowAble)<IMAUserShowAble>

// 申请理由
- (NSString *)applyInfo;

- (BOOL)isSendByMe;

@end


@interface TIMFriendFutureItem (ShowAble)<IMAUserShowAble>

// 申请理由
- (NSString *)detaiInfo;
- (BOOL)isMyFriend;

- (BOOL)isSendByMe;
- (BOOL)isPendency;
- (BOOL)isDecide;
- (BOOL)isRecormend;

@end

@interface TIMGroupPendencyItem (ShowAble)<IMAUserShowAble>
// 申请理由
- (NSString *)applyInfo;

- (NSString *)detailInfo;

- (NSString *)actionTitle;

- (BOOL)actionEnable;


@end

@interface TIMGroupInfo (ShowAble)<IMAGroupShowAble>

+ (instancetype)instanceFrom:(TIMCreateGroupInfo *)info;
@end

@interface TIMGroupMemberInfo (ShowAble)<IMAUserShowAble>

@end
