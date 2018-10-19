//
//  SendVC.h
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "SendModel.h"
#import "GetTheModel.h"
@interface SendVC : TLBaseVC
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) SendModel *sen;
@property (nonatomic, strong) GetTheModel *getModel;

@property (nonatomic, assign) BOOL isSend;

@end
