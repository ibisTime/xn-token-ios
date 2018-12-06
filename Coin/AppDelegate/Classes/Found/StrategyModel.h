//
//  StrategyModel.h
//  Coin
//
//  Created by 郑勤宝 on 2018/12/6.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StrategyModel : NSObject


@property (nonatomic , copy)NSString *ID;
@property (nonatomic , copy)NSString *dappId;
@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *author;
@property (nonatomic , copy)NSString *content;
@property (nonatomic , copy)NSString *label;
@property (nonatomic , copy)NSString *likeCount;
@property (nonatomic , copy)NSString *scanCount;
@property (nonatomic , copy)NSString *likeCountFake;
@property (nonatomic , copy)NSString *scanCountFake;
@property (nonatomic , copy)NSString *orderNo;
@property (nonatomic , copy)NSString *status;
@property (nonatomic , copy)NSString *createDatetime;



@end
