//
//  AdsTradeDetailVC.m
//  Coin
//
//  Created by  tianlei on 2017/12/09.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AdsTradeDetailVC.h"
#import "RichChatViewController.h"
#import "WaitingOrderVC.h"
#import "OrderModel.h"

@interface AdsTradeDetailVC ()

@end

@implementation AdsTradeDetailVC

- (void)goChatWithGroupId:(NSString *)groupId toUser:(UserInfo *)toUser {

    
    //    //对方
    //    TradeUserInfo *friendUserInfo = self.advertise.user;
    //
    //    //
    //    IMAUser *user = [[IMAUser alloc] initWith:self.advertise.userId];
    //    user.nickName = friendUserInfo.nickname;
    //    user.icon = [friendUserInfo.photo convertImageUrl];
    //    user.remark = friendUserInfo.nickname;
    //    user.userId = self.advertise.userId;
    //
    //我
    //    ChatUserProfile *userInfo = [ChatUserProfile sharedUser];
    //    userInfo.minePhoto = [TLUser user].photo;
    //    userInfo.mineNickName = [TLUser user].nickname;
    //    userInfo.friendPhoto = [friendUserInfo.photo convertImageUrl];
    //    userInfo.friendNickName = friendUserInfo.nickname;
    //
    //    ChatViewController *chatVC = [[CustomChatUIViewController alloc] initWith:user];
    //
    
    // 获取会话
    //    TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:groupId];
    
    //应该是从服务端获取得会话
    // 可以让它加载
    //    IMAConversation *imaConversation = [[IMAConversation alloc] initWith:conversation];
    
    //
    // 下面控制器，实际上只用到了，id 和 type ,
    // 由于 是创建的 IMAGroup 所以，type____自然为___group
    IMAGroup *group = [[IMAGroup alloc] initWith:groupId];
    
    // 单例
    ChatUserProfile *userInfo = [ChatUserProfile sharedUser];
    userInfo.minePhoto = [TLUser user].photo;
    userInfo.mineNickName = [TLUser user].nickname;
    //
    userInfo.friendPhoto = [toUser.photo convertImageUrl];
    userInfo.friendNickName = toUser.nickname;
    userInfo.friendUserId = toUser.userId;
    
    //
    WaitingOrderVC *chatVC = [[WaitingOrderVC alloc] initWith:group];
    chatVC.orderCode = groupId;
//    //
//    c
//    chatVC
//    ChatViewController *chatVC = [[RichChatViewController alloc] initWith:group];
//    chatVC.
//  //    chatVC.userInfo = userInfo;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}


@end
