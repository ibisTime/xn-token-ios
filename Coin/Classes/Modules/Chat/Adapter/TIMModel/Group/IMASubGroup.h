//
//  IMASubGroup.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

// 分组
// 对应IMSDK里面的TIMFriendGroup
// 目前分组里的数据没有作排序
// 用户可根据具体逻辑作排序
@interface IMASubGroup : NSObject<IMAContactDrawerShowAble>

@property(nonatomic, copy) NSString         *name;              // 分组名

@property (nonatomic, strong) CLSafeMutableArray *friends;      // 分组内的好友信息

@property (nonatomic, assign) BOOL isFold;                      // 是否折叠

@property (nonatomic, assign) BOOL isPicked;                    // 对应好友选择界面的折叠状态

// 创建默认分组
- (instancetype)initDefaultSubGroup;

// 创建空分组
- (instancetype)initWithName:(NSString *)subGroupName;

// 将TIMFriendGroup转成IMASubGroup
- (instancetype)initWith:(TIMFriendGroupWithProfiles *)group;

// 是否是默认分组
- (BOOL)isDefaultSubGroup;

// 同步折叠状态
- (void)syncFoldOf:(IMASubGroup *)sg;


@end
