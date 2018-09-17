//
//  SendModel.h
//  Coin
//
//  Created by QinBao Zheng on 2018/7/3.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendModel : NSObject

//领取时间
@property (nonatomic , copy)NSString *createDatetime;
@property (nonatomic , copy)NSString *createDateTime;
@property (nonatomic , strong)NSDictionary *redPacketInfo;
//领取数量价值多少人民币
@property (nonatomic , copy)NSString *countCNY;
//账户类型
@property (nonatomic , copy)NSString *symbol;
//币
@property (nonatomic , copy)NSString *sendNum;
//发送人
@property (nonatomic , copy)NSString *sendUserNickname;
//头像
@property (nonatomic , copy)NSString *sendUserPhoto;

@property (nonatomic , copy)NSString *totalCountCNY;

@property (nonatomic , copy)NSString *totalCount;

@property (nonatomic , copy)NSString *code;

@property (nonatomic , copy)NSString *greeting;

@property (nonatomic , copy)NSString *type;

@property (nonatomic , copy)NSString *singleCount;

@property (nonatomic , copy)NSString * receivedNum;
@property (nonatomic , copy)NSString * userId;

@property (nonatomic , copy)NSString * receivedCount;
@property (nonatomic , copy)NSString * lastReceivedDatetime;
@property (nonatomic , copy)NSString * bestHandUser;
@property (nonatomic , copy)NSString * invalidDatetime;
@property (nonatomic , copy)NSString * status;
@property (nonatomic , copy)NSString * bestHandUserPhoto;
@property (nonatomic , copy)NSString * bestHandUserNickname;
@property (nonatomic , copy)NSString * isReceived;
@property (nonatomic , copy)NSString * bestHandCount;

@property (nonatomic , strong)NSArray *receiverList;


@end
