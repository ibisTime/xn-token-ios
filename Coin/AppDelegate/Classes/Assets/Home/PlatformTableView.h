//
//  PlatformTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "CurrencyModel.h"
typedef NS_ENUM(NSInteger, PlatformType) {
    
    PlatformTypeAll = 0,        //全部
    PlatformTypeMoney,          //资金
    PlatformTypePlatform,       //具体平台
};

typedef void(^selectCurrent)(NSInteger );

@interface PlatformTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*platforms;
//类型
@property (nonatomic, assign) PlatformType type;

@property (nonatomic,copy)selectCurrent selectBlock;

@property (nonatomic , copy)NSString *isWallet;

//@property (nonatomic, assign) BOOL isLocal;

@end
