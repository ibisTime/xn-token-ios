//
//  QuestionModel.h
//  Coin
//
//  Created by shaojianfei on 2018/8/4.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseModel.h"

@interface QuestionModel : TLBaseModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *deviceSystem;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *reappear;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *commitUser;
@property (nonatomic, copy) NSString *commitNote;
@property (nonatomic, copy) NSString *commitDatetime;
@property (nonatomic, copy) NSString *approveUser;
@property (nonatomic, copy) NSString *approveDatetime;
@property (nonatomic, copy) NSString *approveNote;
@property (nonatomic, copy) NSString *payAmount;
@property (nonatomic, copy) NSString *payUser;
@property (nonatomic, copy) NSString *payDatetime;
@property (nonatomic, copy) NSString *payNote;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *repairVersionCode;
@property (nonatomic, assign) CGFloat rowHeight;

@end
