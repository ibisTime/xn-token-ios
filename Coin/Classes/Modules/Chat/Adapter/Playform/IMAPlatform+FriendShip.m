//
//  IMAPlatform+FriendShip.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/1.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform+FriendShip.h"

@implementation IMAPlatform (FriendShip)

//- (NSArray *)changeToUsers:(NSArray *)userProfiles
//{
//    if (userProfiles.count)
//    {
//        NSMutableArray *array = [NSMutableArray array];
//        for (TIMUserProfile *pro in userProfiles)
//        {
//            IMAUser *user = [[IMAUser alloc] initWithUserInfo:pro];
//            [array addObject:user];
//        }
//
//        return array;
//    }
//    return nil;
//}

- (void)asyncSearchUserBy:(NSString *)key with:(RequestPageParamItem *)page succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if ([NSString isEmpty:key])
    {
        DebugLog(@"key为空");
        return;
    }
    
    NSArray *accountIDs = @[key];
    NSString *phoneId = [NSString stringWithFormat:@"86-%@", key];
    NSArray *phoneIDs = @[phoneId];
    
    [[TIMFriendshipManager sharedInstance] getUsersProfile:accountIDs succ:^(NSArray *data) {
        if (succ)
        {
            succ(data);
        }
        
    } fail:^(int code, NSString *err) {
        DebugLog(@"Fail: %d->%@", code, err);
        [[TIMFriendshipManager sharedInstance] getUsersProfile:phoneIDs succ:^(NSArray *data){
            if (succ)
            {
                succ(data);
            }
        } fail:^(int code, NSString *err) {
            DebugLog(@"Fail: %d->%@", code, err);
            [[TIMFriendshipManager sharedInstance] searchUser:key pageIndex:page.pageIndex pageSize:page.pageSize succ:^(uint64_t totalNum, NSArray *data) {
                page.pageIndex++;
                if (data.count < page.pageSize)
                {
                    page.canLoadMore = NO;
                }
                if (succ)
                {
                    succ(data);
                }
            } fail:^(int code, NSString *err) {
                DebugLog(@"Fail: %d->%@", code, err);
                page.canLoadMore = NO;
                if (fail)
                {
                    fail(code, err);
                }
            }];
        }];
    }];
}

- (void)asyncSearchGroupBy:(NSString *)key with:(RequestPageParamItem *)page succ:(TIMGroupListSucc)succ fail:(TIMFail)fail
{
    if ([NSString isEmpty:key])
    {
        DebugLog(@"key为空");
        return;
    }
    
    NSArray *groups = @[key];
    
    __weak NSArray *wg = groups;
    
    [[TIMGroupManager sharedInstance] getGroupPublicInfo:wg succ:^(NSArray *arr) {
        if (succ)
        {
            succ(arr);
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail: %d->%@", code, msg);
        
        [[TIMGroupManager sharedInstance] searchGroup:key
                                                flags:TIM_GET_GROUP_BASE_INFO_FLAG_NAME | TIM_GET_GROUP_BASE_INFO_FLAG_MEMBER_NUM
                                                      | TIM_GET_GROUP_BASE_INFO_FLAG_FACE_URL | TIM_GET_GROUP_BASE_INFO_FLAG_OWNER_UIN
                                                      | TIM_GET_GROUP_BASE_INFO_FLAG_CREATE_TIME
                                               custom:nil
                                            pageIndex:(uint32_t)page.pageIndex
                                             pageSize:(uint32_t)page.pageSize
                                                 succ:^(uint64_t totalNum, NSArray *groups) {
            if (groups.count < page.pageSize)
            {
                page.canLoadMore = NO;
            }
            if (succ)
            {
                succ(groups);
            }
        } fail:^(int code, NSString *msg) {
            DebugLog(@"Fail: %d->%@", code, msg);
            page.canLoadMore = NO;
            if (fail)
            {
                fail(code, msg);
            }
        }];
    }];
}

- (void)asyncSendAddFriend:(IMAUser *)user withRemark:(NSString *)remark applyInfo:(NSString *)apinfo toSubGroup:(IMASubGroup *)group succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    // 1. 先检查是否是黑名单中，如果在，则不添加
    
    if ([remark isContainsEmoji])
    {
        [HUDHelper alert:@"备注名不能包含表情"];
        return;
    }
    
    if ([remark utf8Length] > 96) {
        [HUDHelper alert:@"备注名超长"];
        return;
    }
    
    if ([apinfo utf8Length] > 120)
    {
        [HUDHelper alert:@"验证信息过长"];
        return;
    }
    
    TIMAddFriendRequest *req = [[TIMAddFriendRequest alloc] init];
    req.identifier = [user userId];
    req.remark = remark;
    req.addWording = apinfo;
    req.friendGroup = group ? group.name ? group.name : @"" : @"";
    
    __weak IMASubGroup *wsg = group;
    
    [[TIMFriendshipManager sharedInstance] addFriend:@[req] succ:^(NSArray *data) {
        if (succ)
        {
            NSMutableArray *sussResults = [NSMutableArray array];
            for (TIMFriendResult *res in data)
            {
                if (res.status == TIM_FRIEND_STATUS_SUCC)
                {
                    [sussResults addObject:res];
                    [[IMAPlatform sharedInstance] asyncGetFirendInfo:res.identifier succ:^(IMAUser *auser) {
                        [[IMAPlatform sharedInstance].contactMgr addUser:user toSubGroup:wsg];
                    } fail:^(int code, NSString *msg) {
                        
                        NSString *errinfo = [NSString stringWithFormat:@"添加好友成功后，获取好友资料失败,%@",IMALocalizedError(code, msg)];
                        DebugLog(@"%@",errinfo);
                        [[HUDHelper sharedInstance] tipMessage:errinfo];
                    }];
                }
                else
                {
                    [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(res.status, msg) delay:1.0];
                }
            }
            succ(sussResults);
        }
        
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail: %d->%@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}
- (void)asyncFriendPendencyReport:(uint64_t)timestamp succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (timestamp <= 0)
    {
        DebugLog(@"参数错误");
        return;
    }
    
    [[TIMFriendshipManager sharedInstance] pendencyReport:timestamp succ:^{
        
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail: %d->%@", code, msg);
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncGetAllFriendPendency:(TIMFriendFutureMeta *)meta succ:(TIMGetFriendFutureListSucc)succ fail:(TIMFail)fail
{
    if (meta)
    {
        [self asyncGetAllFutureFriends:TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE meta:meta succ:succ fail:nil];
    }
}

- (void)asyncGetAllFutureFriends:(TIMFutureFriendType)futureFlag meta:(TIMFriendFutureMeta *)meta succ:(TIMGetFriendFutureListSucc)succ fail:(TIMFail)fail
{
    if (meta)
    {
        NSInteger tag = TIM_PROFILE_FLAG_NICK | TIM_PROFILE_FLAG_ALLOW_TYPE | TIM_PROFILE_FLAG_FACE_URL | TIM_PROFILE_FLAG_REMARK;
        
        [[TIMFriendshipManager sharedInstance] getFutureFriends:tag futureFlag:futureFlag custom:nil meta:meta succ:succ fail:^(int code, NSString *msg) {
            DebugLog(@"Fail:--> code=%d,msg=%@,fun=%s", code, msg,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
            if (fail)
            {
                fail(code, msg);
            }
        }];
    }
}

- (void)asyncDeleteFriendPendency:(TIMFriendPendencyItem *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if(item)
    {
        [[TIMFriendshipManager sharedInstance] deletePendency:item.type users:@[item.identifier] succ:succ fail:^(int code, NSString *err){
            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
            if (fail)
            {
                fail(code, err);
            }
        }];
    }
}

- (void)asyncApplyAddFriend:(IMAUser *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    [self asyncApplyAddFriend:item withRemark:nil succ:succ fail:fail];
}

- (void)asyncApplyAddFriend:(IMAUser *)item withRemark:(NSString *)remark succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if ([remark utf8Length] > 96)
    {
        DebugLog(@"remark过长");
        return;
    }
    
    if(item)
    {
        TIMFriendResponse *response = [[TIMFriendResponse alloc] init];
        response.identifier = [item userId];
        response.remark = remark;
        response.responseType = TIM_FRIEND_RESPONSE_AGREE_AND_ADD;
        [[TIMFriendshipManager sharedInstance] doResponse:@[response] succ:^(NSArray *data) {
            if (succ)
            {
                succ(data);
            }
        } fail:^(int code, NSString *err) {
            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
            
            if (fail)
            {
                fail(code, err);
            }
        }];
        
    }

}

- (void)asyncApplyAddFriendWithId:(NSString *)userid succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if(![NSString isEmpty:userid])
    {
        TIMFriendResponse *response = [[TIMFriendResponse alloc] init];
        response.identifier = userid;
        response.responseType = TIM_FRIEND_RESPONSE_AGREE_AND_ADD;
        [[TIMFriendshipManager sharedInstance] doResponse:@[response] succ:^(NSArray *data) {
            if (succ)
            {
                succ(data);
            }
        } fail:^(int code, NSString *err) {
            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
            
            if (fail)
            {
                fail(code, err);
            }
        }];
        
    }
}

- (void)asyncRefuseFriend:(TIMUserProfile *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if(item)
    {
        TIMFriendResponse *response = [[TIMFriendResponse alloc] init];
        response.identifier = item.identifier;
        response.responseType = TIM_FRIEND_RESPONSE_REJECT;
        [[TIMFriendshipManager sharedInstance] doResponse:@[response] succ:^(NSArray *data) {
            if (succ)
            {
                succ(data);
            }
        } fail:^(int code, NSString *err) {
            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
            
            if (fail)
            {
                fail(code, err);
            }
        }];
        
    }
    
}


- (void)asyncGetFirendInfo:(NSString *)userid succ:(void (^)(IMAUser *auser))succ fail:(TIMFail)fail
{
    if ([NSString isEmpty:userid])
    {
        if (succ)
        {
            succ(nil);
        }
        else
        {
            DebugLog(@"参数错误");
        }
        return;
    }
    [[TIMFriendshipManager sharedInstance] getFriendsProfile:@[userid] succ:^(NSArray *friends) {
        for (TIMUserProfile *pro in friends)
        {
            IMAUser *user = [[IMAUser alloc] initWithUserInfo:pro];
            if (succ)
            {
                succ(user);
            }
            break;
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail: %d->%@", code, msg);
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncGetStrangerInfo:(NSString *)userid succ:(void (^)(IMAUser *auser))succ fail:(TIMFail)fail
{
    if ([NSString isEmpty:userid])
    {
        if (succ)
        {
            succ(nil);
        }
        else
        {
            DebugLog(@"参数错误");
        }
        return;
    }
    
    
    
    [[TIMFriendshipManager sharedInstance] getFriendsProfile:@[userid] succ:^(NSArray *friends) {
        for (TIMUserProfile *pro in friends)
        {
            IMAUser *user = [[IMAUser alloc] initWithUserInfo:pro];
            if (succ)
            {
                succ(user);
            }
            break;
        }
    } fail:^(int code, NSString *msg) {
        DebugLog(@"Fail: %d->%@", code, msg);
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncDeleteFutureFriend:(TIMFriendFutureItem *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if(item)
    {
        
        switch (item.type)
        {
            case TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE:
            case TIM_FUTURE_FRIEND_PENDENCY_OUT_TYPE:
            {
                [[TIMFriendshipManager sharedInstance] deletePendency:(TIMPendencyGetType)item.type users:@[item.identifier] succ:succ fail:^(int code, NSString *err){
                    DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
                    [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
                    if (fail)
                    {
                        fail(code, err);
                    }
                }];
            }
                
                break;
                
            case TIM_FUTURE_FRIEND_RECOMMEND_TYPE:
            {
                [[TIMFriendshipManager sharedInstance] deleteRecommend:@[item.identifier] succ:succ fail:^(int code, NSString *err){
                    DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
                    [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
                    if (fail)
                    {
                        fail(code, err);
                    }
                }];
            }
                break;
            case TIM_FUTURE_FRIEND_DECIDE_TYPE:
            {
                [[TIMFriendshipManager sharedInstance] deleteDecide:@[item.identifier] succ:succ fail:^(int code, NSString *err){
                    DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
                    [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
                    if (fail)
                    {
                        fail(code, err);
                    }
                }];
            }
                
                break;
                
            default:
                break;
        }
        
    }

}

- (void)asyncApplyAddFutureFriend:(TIMFriendFutureItem *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    // 必须是TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE
    if(item && item.type == TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE)
    {
        IMAUser *u = [[IMAUser alloc] initWithUserInfo:item.profile];
        [self asyncApplyAddFriend:u withRemark:nil succ:^(NSArray *friends) {
            item.type = TIM_FUTURE_FRIEND_DECIDE_TYPE;
            IMAUser *user = [[IMAUser alloc] initWithUserInfo:item.profile];
            [[IMAPlatform sharedInstance].contactMgr addUserToDefaultSubGroup:user];
            if (succ)
            {
                succ(friends);
            }
        } fail:fail];
    }
    else
    {
        DebugLog(@"必须是TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE");
    }
}
- (void)asyncRefuseFutureFriend:(TIMFriendFutureItem *)item succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if(item && item.type == TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE)
    {
        [self asyncRefuseFriend:item.profile succ:^(NSArray *friends) {
            item.type = TIM_FUTURE_FRIEND_DECIDE_TYPE;
            
            if (succ)
            {
                succ(friends);
            }
        } fail:fail];
    }
    else
    {
        DebugLog(@"必须是TIM_FUTURE_FRIEND_PENDENCY_IN_TYPE");
    }

}

- (void)asyncClearRecommonds:(NSArray *)recommonds succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if (recommonds.count > 0)
    {
        __weak IMAPlatform *ws = self;
        [[TIMFriendshipManager sharedInstance] deleteRecommend:recommonds succ:^(NSArray *friends) {
            if (succ)
            {
                NSMutableArray *results = [ws filterResult:friends];
                succ(results);
            }
        } fail:^(int code, NSString *msg) {
            DebugLog(@"删除推荐好友失败,code=%d,msg=%@",code,msg);
            [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"删除推荐好友失败,code=%d,msg=%@",code,msg]];
            if (fail)
            {
                fail(code,msg);
            }
        }];
    }
}

- (void)asyncClearPendencysIn:(NSArray *)pendencys isInPendency:(BOOL)isIn succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if (pendencys.count > 0)
    {
        DebugLog(@"DeletePendencys font");
        
        __weak IMAPlatform *ws = self;
        [[TIMFriendshipManager sharedInstance] deletePendency:isIn ? TIM_PENDENCY_GET_COME_IN : TIM_PENDENCY_GET_SEND_OUT users:pendencys succ:^(NSArray *friends) {
            DebugLog(@"DeletePendencys succ");
            if (succ)
            {
                NSMutableArray *results = [ws filterResult:friends];
                succ(results);
            }
        } fail:^(int code, NSString *msg) {
            DebugLog(@"删除未决好友失败,code=%d,msg=%@",code,msg);
            [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"删除未决好友失败,code=%d,msg=%@",code,msg]];
            if (fail)
            {
                fail(code,msg);
            }
        }];
        DebugLog(@"DeletePendencys rail");
    }
}

- (void)asyncClearDecides:(NSArray *)decides succ:(TIMFriendSucc)succ fail:(TIMFail)fail
{
    if (decides.count > 0)
    {
        DebugLog(@"DeleteDecide front");
        __weak IMAPlatform *ws = self;
        [[TIMFriendshipManager sharedInstance] deleteDecide:decides succ:^(NSArray *friends) {
            DebugLog(@"DeleteDecide succ");
            if (succ)
            {
                NSMutableArray *results = [ws filterResult:friends];
                succ(results);
            }
        } fail:^(int code, NSString *msg) {
            DebugLog(@"删除已决好友失败,code=%d,msg=%@",code,msg);
            [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"删除已决好友失败,code=%d,msg=%@",code,msg]];
            if (fail)
            {
                fail(code,msg);
            }
        }];
        DebugLog(@"DeleteDecide rail");
    }
}

- (NSMutableArray *)filterResult:(NSArray *)array
{
    NSMutableArray *results = [NSMutableArray array];
    for (TIMFriendResult *result in array)
    {
        if (result.status == TIM_FRIEND_STATUS_SUCC)
        {
            IMAUser *user = [[IMAUser alloc] initWith:result.identifier];
            [results addObject:user];
        }
    }
    return results;
}

- (void)asyncGetSystemMessages:(RequestPageParamItem *)item last:(IMAMsg*)lastMsg succ:(TIMGetMsgSucc)succ fail:(TIMFail)fail
{
    TIMConversation* conversation = [[TIMManager sharedInstance] getConversation:TIM_SYSTEM receiver:@""];
    
    __block IMAMsg *wm = lastMsg;
    [conversation getMessage:(int)item.pageSize
                        last:(lastMsg ? lastMsg.msg : nil)
                        succ:^(NSArray *msgList) {
                            NSInteger index = 0;
                            NSMutableArray *msgs = [NSMutableArray array];
                            while (index < msgList.count)
                            {
                                TIMMessage *msg = [msgList objectAtIndex:index];
                                if (msg.isSelf)
                                {
                                    index++;
                                    continue;
                                }
                                
                                for (int i=0; i < [msg elemCount]; i++)
                                {
                                    TIMElem *elem = [msg getElem:i];
                                    if ([elem isKindOfClass:[TIMSNSSystemElem class]])
                                    {
                                        TIM_SNS_SYSTEM_TYPE type = ((TIMSNSSystemElem *)elem).type;
                                        if (type == TIM_SNS_SYSTEM_ADD_FRIEND_REQ || type == TIM_SNS_SYSTEM_ADD_FRIEND)
                                        {
                                            [msgs addObject:[IMAMsg msgWith:msg]];
                                        }
                                    }
                                    else if ([elem isKindOfClass:[TIMGroupSystemElem class]])
                                    {
                                        TIM_GROUP_SYSTEM_TYPE type = ((TIMGroupSystemElem *)elem).type;
                                        if (type == TIM_GROUP_SYSTEM_ADD_GROUP_REQUEST_TYPE)
                                        {
                                            [msgs addObject:[IMAMsg msgWith:msg]];
                                        }
                                    }
                                }
                                index++;
                            }
                            if (msgList.count > 0)
                            {
                                TIMMessage *msg = [msgList objectAtIndex:index-1];
                                wm = [IMAMsg msgWith:msg];
                            }
                            if (succ)
                            {
                                succ(msgs);
                            }
                        }
                        fail:^(int code, NSString *err) {
                            DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
                            [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
                            if (fail)
                            {
                                fail(code, err);
                            }
                        }];
}



@end
