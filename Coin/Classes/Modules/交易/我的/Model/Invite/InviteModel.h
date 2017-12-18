//
//  InviteModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseModel.h"

@class InviteUserStatistics;

@interface InviteModel : TLBaseModel

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) InviteUserStatistics *userStatistics;

@end

@interface InviteUserStatistics: NSObject
//交易次数
@property (nonatomic, assign) NSInteger jiaoYiCount;
//信任人数
@property (nonatomic, assign) NSInteger beiXinRenCount;
//评论次数
@property (nonatomic, assign) NSInteger beiPingJiaCount;
//好评次数
@property (nonatomic, assign) NSInteger beiHaoPingCount;
//好评率
@property (nonatomic, copy) NSString *goodCommentRate;

@end

