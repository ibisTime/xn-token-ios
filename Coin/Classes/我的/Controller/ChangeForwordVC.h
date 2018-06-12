//
//  ChangeForwordVC.h
//  Coin
//
//  Created by shaojianfei on 2018/6/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
typedef NS_ENUM(NSInteger, CheckWprdType) {
    
    CheckWprdTypeFirst = 0,   //第一次
    CheckWprdTypeSecond = 1  //第二次
};


@interface ChangeForwordVC : TLBaseVC

@property (nonatomic, assign) CheckWprdType Type;

@property (nonatomic, assign) BOOL IsImport;

@end
