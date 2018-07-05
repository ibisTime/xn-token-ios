//
//  BuildBackUpVC.h
//  Coin
//
//  Created by shaojianfei on 2018/6/8.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"

@interface BuildBackUpVC : TLBaseVC

@property (nonatomic ,copy) NSString *mnemonics;
@property (nonatomic ,copy) NSString *pwd;

@property (nonatomic ,assign) BOOL isCopy;

@end
