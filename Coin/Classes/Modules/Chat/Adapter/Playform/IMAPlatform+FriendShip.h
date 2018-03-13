//
//  IMAPlatform+FriendShip.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform.h"

// 关系链相关的操作

@interface IMAPlatform (FriendShip)

/**
 *  获取用户资料
 *
 *  @param users 要获取的用户列表 NSString* 列表
 *  @param succ  成功回调，返回 IMAUser* 列表
 *  @param fail  失败回调
 *
 *  @return 0 发送请求成功
 */
- (void)asyncSearchUserBy:(NSString *)key with:(RequestPageParamItem *)page succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)asyncSearchGroupBy:(NSString *)key with:(RequestPageParamItem *)page succ:(TIMGroupListSucc)succ fail:(TIMFail)fail;

/**
 *  向用户user发送好友申请
 *
 *  @param user  要添加的用户信息
 *  @parma remark 备注名
 *  @parma group 要加到的分组
 *  @param succ  成功回调
 *  @param fail  失败回调
 *
 *  @return 0 发送请求成功
 */

- (void)asyncSendAddFriend:(IMAUser *)user withRemark:(NSString *)remark applyInfo:(NSString *)apinfo toSubGroup:(IMASubGroup *)group succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

/**
 *  通过网络获取未决请求列表
 *
 *  @param meta  请求信息，详细参考RequestPageParamItem
 *  @param type  拉取类型（参考TIMPendencyGetType）
 *  @param succ 成功回调
 *  @param fail 失败回调
 *
 *  @return 0 发送请求成功
 */
- (void)asyncGetAllFriendPendency:(TIMFriendFutureMeta *)meta succ:(TIMGetFriendFutureListSucc)succ fail:(TIMFail)fail;

- (void)asyncGetAllFutureFriends:(TIMFutureFriendType)futureFlag meta:(TIMFriendFutureMeta *)meta succ:(TIMGetFriendFutureListSucc)succ fail:(TIMFail)fail;

- (void)asyncDeleteFriendPendency:(TIMFriendPendencyItem *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)asyncFriendPendencyReport:(uint64_t)timestamp succ:(TIMSucc)succ fail:(TIMFail)fail;

- (void)asyncApplyAddFriendWithId:(NSString *)userid succ:(TIMFriendSucc)succ fail:(TIMFail)fail;
- (void)asyncApplyAddFriend:(IMAUser *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail;
- (void)asyncApplyAddFriend:(IMAUser *)item withRemark:(NSString *)remark succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)asyncGetFirendInfo:(NSString *)userid succ:(void (^)(IMAUser *auser))succ fail:(TIMFail)fail;
- (void)asyncGetStrangerInfo:(NSString *)userid succ:(void (^)(IMAUser *auser))succ fail:(TIMFail)fail;

- (void)asyncDeleteFutureFriend:(TIMFriendFutureItem *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)asyncApplyAddFutureFriend:(TIMFriendFutureItem *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail;
- (void)asyncRefuseFutureFriend:(TIMFriendFutureItem *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail;

- (void)asyncGetSystemMessages:(RequestPageParamItem *)item last:(IMAMsg*)lastMsg succ:(TIMGetMsgSucc)succ fail:(TIMFail)fail;



@end
