//
//  ChatUserProfile.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/31.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseModel.h"


/**
 设个单例，把 我的信息 和 我要聊天的用户存储进去
 */
@interface ChatUserProfile : TLBaseModel
//我的头像
@property (nonatomic, copy) NSString *minePhoto;
//我的昵称
@property (nonatomic, copy) NSString *mineNickName;

//对方的头像
@property (nonatomic, copy) NSString *friendPhoto;
//对面的昵称
@property (nonatomic, copy) NSString *friendNickName;
@property (nonatomic, copy) NSString *friendUserId;

+ (instancetype)sharedUser;

@end
