//
//  JoinModel.h
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseModel.h"
@interface JoinModel : TLBaseModel
@property (nonatomic ,copy) NSString *ckey;
@property (nonatomic ,copy) NSString *cvalue;
/*
 ckey = Facebook;
 companyCode = "CD-TOKEN00018";
 cvalue = "@THAWallet";
 id = 23;
 remark = "Facebook\U8d26\U53f7";
 systemCode = "CD-TOKEN00018";
 type = followUs;
 updateDatetime = "Jul 11, 2018 5:57:15 PM";
 updater = admin;
 */
@end
