//
//  FindTheGameModel.h
//  Coin
//
//  Created by 郑勤宝 on 2018/12/6.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindTheGameModel : NSObject

@property (nonatomic , copy)NSString *location;
@property (nonatomic , copy)NSString *status;
@property (nonatomic , copy)NSString *volume;
@property (nonatomic , copy)NSString *url;
@property (nonatomic , copy)NSString *company;
@property (nonatomic , copy)NSString *language;
@property (nonatomic , copy)NSString *action;
@property (nonatomic , copy)NSString *picList;
@property (nonatomic , copy)NSString *category;
@property (nonatomic , copy)NSString *createDatetime;
@property (nonatomic , copy)NSString *picIcon;
@property (nonatomic , copy)NSString *name;
@property (nonatomic , copy)NSString *isTop;
@property (nonatomic , copy)NSString *ID;
@property (nonatomic , copy)NSString *orderNo;
@property (nonatomic , copy)NSString *grade;
@property (nonatomic , copy)NSString *label;
@property (nonatomic , copy)NSString *desc;
@property (nonatomic , copy)NSString *download;
@property (nonatomic , copy)NSString *picScreenshot;
@property (nonatomic , copy)NSArray *labelList;
@property (nonatomic , strong)NSArray *picListArray;
@property (nonatomic , strong)NSArray *labelArray;
//"location" : "0",
//"status" : "1",
//"volume" : "10",
//"url" : "https:\/\/www.baidu.com",
//"company" : "网易",
//"language" : "ZH_CN",
//"action" : "third_part",
//"picList" : "-56dd96c481531f34_c_1535716086869.jpg",
//"category" : "0",
//"createDatetime" : "Dec 5, 2018 3:58:19 PM",
//"picIcon" : "-56dd96c481531f34_c_1535716086869.jpg",
//"name" : "强力球",
//"isTop" : "0",
//"id" : 1,
//"orderNo" : 1,
//"grade" : 1,
//"label" : "1",
//"desc" : "应用描述应用描述应用描述应用描述应用描述应用描述应用描述",
//"download" : "1000",
//"picScreenshot" : "-56dd96c481531f34_c_1535716086869.jpg"

@end
