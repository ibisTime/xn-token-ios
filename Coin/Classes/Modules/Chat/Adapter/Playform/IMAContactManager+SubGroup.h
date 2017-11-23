//
//  IMAContactManager+SubGroup.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAContactManager.h"

// 分组相关的逻辑



@interface IMAContactManager (SubGroup)

//@property (nonatomic, assign) NSInteger currentSubGroupListTime;    // 本地分组信息的存储时间

- (void)saveSubGroupStateInfoToLocal;

// 方便添加好友时选择默认的分组
- (IMASubGroup *)defaultAddToSubGroup;

// 异步请求分组列表
- (void)asyncSubGroupList;

// 分组名是否有效
- (BOOL)isValidSubGroupName:(NSString *)sbName;


- (IMASubGroup *)subGroupOf:(IMAUser *)user;

/**
 *  新建空的好友分组
 *
 *  @param sgName  分组名称，不能为空
 *  @param succ  成功回调，返回创建的并已添加到_subGroupList 的 IMASubGroup实例
 *  @param fail  失败回调
 */
- (void)asyncCreateSubGroup:(NSString *)sgName succ:(IMASubGroupCompletion)succ fail:(TIMFail)fail;


/**
 *  删除好友分组
 *
 *  @param sg  要删除的好友分组对象
 *  @param succ  成功回调，返回前会先将sg从_subGroupList中移除
 *  @param fail  失败回调
 */
- (void)asyncDeleteSubGroup:(IMASubGroup *)sg succ:(TIMSucc)succ fail:(TIMFail)fail;

@end
