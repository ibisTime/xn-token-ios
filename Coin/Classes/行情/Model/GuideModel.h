//
//  GuideModel.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/30.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface GuideModel : TLBaseModel

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, assign) NSInteger scanNum;

@property (nonatomic, assign) NSInteger commentNum;

@property (nonatomic, copy) NSString *advPic;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *keywords;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *content;

@end
