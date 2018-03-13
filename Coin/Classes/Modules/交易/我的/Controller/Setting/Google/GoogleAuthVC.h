//
//  GoogleAuthVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/12/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, AuthStatusType) {
    
    AuthStatusTypeOpen = 0,         //开启
    AuthStatusTypeChange,           //修改
};

@interface GoogleAuthVC : TLBaseVC

@property (nonatomic, assign) AuthStatusType type;

@end
