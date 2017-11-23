//
//  IMAContactManager.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, IMAContactChangedNotifyType) {
    // 联系人列表事件
    EIMAContact_AddNewSubGroup   =    0x0001 ,            // 新建分组
    EIMAContact_DeleteSubGroup   =    0x0001 << 1,        // 删除分组
    EIMAContact_AddFriend        =    0x0001 << 2,        // 添加好友
    EIMAContact_DeleteFriend     =    0x0001 << 3,        // 删除好友
    
    EIMAContact_LoadDefaultFriends =  0x0001 << 4,        // 加到在默认分组的好友完毕
    EIMAContact_FriendInfoChanged =    0x0001 << 5,       // 用户信息信息
    
    // 黑名单事件
    EIMAContact_BlackListAddIn  = 0x0001 << 6,            // 加入黑名单
    EIMAContact_BlackListMoveOut  = 0x0001 << 7,          // 移除黑名单

    EIMAContact_SubGroupChanged =    0x0001 << 8,         // 分组更新
    
    
    EIMAContact_FriendListEvents = EIMAContact_AddNewSubGroup | EIMAContact_DeleteSubGroup | EIMAContact_AddFriend | EIMAContact_DeleteFriend | EIMAContact_LoadDefaultFriends | EIMAContact_FriendInfoChanged | EIMAContact_SubGroupChanged,
    EIMAContact_BlackListEvents = EIMAContact_BlackListAddIn | EIMAContact_BlackListMoveOut,
    
    //    EIMAContact_GroupListEvents = EIMAContact_JoinGroup | EIMAContact_ExitGroup,
    
    EIMAContact_MoveFriend     =    0x0001 << 9,        // 移动分组
    
    EIMAContact_SubGroupReloadAll = 0x0001 << 10,
    
    EIMAContact_AllEvents          = EIMAContact_FriendListEvents | EIMAContact_BlackListEvents,
};

// 联系人变更通知
@interface IMAContactChangedNotifyItem : NSObject

@property (nonatomic, assign) IMAContactChangedNotifyType type;     // 类型
@property (nonatomic, strong) IMASubGroup *subGroup;                // 被操作的分组
@property (nonatomic, strong) IMAUser     *user;                    // 被操作的用户
@property (nonatomic, assign) NSUInteger  index;                    // 被操对象的index

@property (nonatomic, strong) IMAContactChangedNotifyItem *toItem;  // 只在移动分组时使用


- (instancetype)initWith:(IMAContactChangedNotifyType)type;

- (NSString *)notificationName;

@end


typedef void (^IMAContactChangedCompletion)(IMAContactChangedNotifyItem *item);

typedef void (^IMASubGroupCompletion)(IMASubGroup *sg);
/**
 *  联系人管理类。包括好友，群的管理，这里的类与界面无关，只是对数据的操作，界面上对联系人的操作，调用这个类的接口即可。
 */
@interface IMAContactManager : NSObject
{
@protected
    // 好友分组IMASubGroup列表
    CLSafeMutableArray      *_subGroupList;
    
    
@protected
    // 群列表IMAGroup
    CLSafeMutableArray      *_groupList;
    
    // 黑名单列表
    CLSafeMutableArray      *_blackList;
}

@property (nonatomic, readonly) CLSafeMutableArray *subGroupList;
@property (nonatomic, readonly) CLSafeMutableArray *groupList;
@property (nonatomic, readonly) CLSafeMutableArray *blackList;

@property (nonatomic, copy) IMAContactChangedCompletion contactChangedCompletion;

@property (nonatomic, assign) BOOL hasNewDependency;



- (void)saveToLocal;

// 异步配置联系人内容
- (void)asyncConfigContact;

// 异步配置群相关内容
- (void)asyncConfigGroup;

// 添空上次选中标记后的subGroupList
- (CLSafeMutableArray *)clearPickedSubGroupList;

// 通过分组旬查询分组
- (IMASubGroup *)getSubGroupOf:(NSString *)sgNAme;

// 查询用户的分组
// 若user为C2CType，查找对应的分组，找到返回，未找到返回为空
// 若user为Group，直接返回空(分组只处理好友，不处理群组)
- (IMASubGroup *)subgroupOf:(IMAUser *)user;

// 查询user对应内存的中对象
// 若user为C2CType，返回_subGroupList中的分组与user.userid相同的对象，未找到返回空
// 若user为Group，返回_groupList中与user.userid相同的对象，未找到返回为空
- (IMAUser *)isContainUser:(IMAUser *)user;

// 按用户id查找对应内存的中对象
- (IMAUser *)getUserByUserId:(NSString *)userID;

// 按群id查找对应内存的中对象
- (IMAUser *)getUserByGroupId:(NSString *)groupID;

// user是否为我的好友，YES，是, NO，则为陌生人
- (BOOL)isMyFriend:(IMAUser *)user;

// 用户是否在黑名单内
- (BOOL)isInBlackListByID:(NSString *)userID;
- (BOOL)isInBlackList:(IMAUser *)user;

// 删除用户，并删除对应的会话
// 若user为C2CType，删除_subGroupList中的对象，并删除相关的会话
// 若user为Group，删除_groupList中的对象，并删除相关的会话
- (void)removeUser:(IMAUser *)user;


// 删除用户，并删除对应的会话，并将其移到黑名单中
- (void)removeUserToBlackList:(IMAUser *)user;

// 将用户从黑名单中移除
- (void)removeUserOutBlackList:(IMAUser *)user;

// 添加用户到分组
- (void)addUser:(IMAUser *)user toSubGroup:(IMASubGroup *)sg;

// 添加用户到默认分组
- (void)addUserToDefaultSubGroup:(IMAUser *)user;

// 添加事件监听
- (void)addContactChangedObserver:(id)observer handler:(SEL)selector forEvent:(NSUInteger)eventID;
// 移除事件监听
- (void)removeContactChangedObser:(id)observer;
@end




// TIMAdpter内部方法
// 外部用户不要调用(只供TIMAdapter内部调用，
// 像本Demo中，不要在TIMChat目录下的代码调用以下方法)


// 主要是一些事件通知，用于同步
@interface IMAContactManager (Protected)


// 添加了新的分组后，调用此方法
- (void)onAddNewSubGroup:(IMASubGroup *)group;
// 删除分组后，调用此方法
- (void)onDeleteSubGroup:(IMASubGroup *)group;
// 添加用户到分组后，调用此方法
- (void)onAddUser:(IMAUser *)user toSubGroup:(IMASubGroup *)group;
// 删除好友后，调用此方法
- (void)onDeleteFriend:(IMAUser *)user;
// 用户信息更新后，调用此方法
- (void)onFriendInfoChanged:(IMAUser *)user remark:(NSString *)remark;
// 默认分组加载完毕后调用（目前已废弃）
- (void)onLoadDefaultSubGroup:(IMASubGroup *)group;

// 添加到黑名单后调用
- (void)onAddToBlackList:(IMAUser *)user;
// 移除黑名单调用
- (void)onRemoveOutBlackList:(IMAUser *)user;
// 移动分组后调用
- (void)onMove:(IMAUser *)user from:(IMASubGroup *)fromG to:(IMASubGroup *)toG;
// 添加群后调用
- (void)onAddGroup:(IMAGroup *)group;

@end




