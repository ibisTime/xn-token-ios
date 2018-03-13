//
//  KeyValueModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseModel.h"

@interface KeyValueModel : TLBaseModel

@property (nonatomic, copy) NSString *cvalue;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *ckey;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *updater;

@end
