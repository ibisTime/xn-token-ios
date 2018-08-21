//
//  IMAContactManager+Group.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAContactManager.h"

// 群组相关操作

@interface IMAContactManager (Group)

//@property (nonatomic, assign) NSInteger currentGroupListTime;       // 本地群列表的存储时间


// 群列表
- (void)asyncGroupList;
- (void)asyncBlackList;

// 群列表
- (void)syncGroupList;
- (TIMGroupInfo *)syncGetGroupInfo:(NSString *)groupId;

- (void)asyncGetGroupPendencyList:(TIMGetGroupPendencyListSucc)succ fail:(TIMFail)fail;

- (void)asyncGroupPendencyReport:(uint64_t)timestamp succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncAcceptAddGroup:(NSString*)msg pendencyItem:(TIMGroupPendencyItem *)item succ:(TIMSucc)succ fail:(TIMFail)fail;
- (void)asyncRefuseAddGroup:(NSString*)msg pendencyItem:(TIMGroupPendencyItem *)item succ:(TIMSucc)succ fail:(TIMFail)fail;

// 获取公开群
- (NSMutableDictionary *)publicGroups;

// 获取聊天室
- (NSMutableArray *)chatRooms;

// 获取讨论组
- (NSMutableArray *)chatGroup;


- (void)asyncCreateChatGroupWith:(NSString *)name members:(NSArray *)array succ:(void (^)(IMAGroup *group))succ fail:(TIMFail)fail;
- (void)asyncCreatePublicGroupWith:(NSString *)name members:(NSArray *)array succ:(void (^)(IMAGroup *group))succ fail:(TIMFail)fail;
- (void)asyncCreateChatRoomWith:(NSString *)name members:(NSArray *)array succ:(void (^)(IMAGroup *group))succ fail:(TIMFail)fail;

@end
