//
//  IMAHost+HostAPIs.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/22.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAHost.h"

// 当前用户常用的操作
@interface IMAHost (HostAPIs)

- (void)asyncSetAllowType:(TIMFriendAllowType)type succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncSetNickname:(NSString*)nick  succ:(TIMSucc)succ fail:(TIMFail)fail;
//设置头像
- (void)asyncSetHeadIconURL:(NSString *)headIconURL succ:(TIMSucc)succ fail:(TIMFail)fail;
@end
