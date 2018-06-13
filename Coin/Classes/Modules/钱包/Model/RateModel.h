//
//  RateModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface RateModel : TLBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *soure;

@property (nonatomic, copy) NSString *imageName;


//币种
@property (nonatomic, copy) NSString *currency;

//参照货币
@property (nonatomic, copy) NSString *referCurrency;
//数据源
@property (nonatomic, copy) NSString *origin;
//汇率
@property (nonatomic, strong) NSNumber *rate;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *createDatetime;
@property (nonatomic, copy) NSString *pushedDatetime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *smsContent;
@property (nonatomic, copy) NSString *smsTitle;
@property (nonatomic, copy) NSString *topushDatetime;
@property (nonatomic, copy) NSString *updateDatetime;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, strong) NSNumber *channelType;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *isRead;
@property (nonatomic, strong) NSNumber *pushType;
@property (nonatomic, strong) NSNumber *smsType;
@property (nonatomic, strong) NSNumber *status;





@end
