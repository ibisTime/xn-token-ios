//
//  MyAdvertiseListVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, MyAdvertiseType) {
    
    MyAdvertiseTypeDraft = 0,   //草稿
    MyAdvertiseTypeDidPublish,  //已发布
};

@interface MyAdvertiseListVC : TLBaseVC
//广告类型
@property (nonatomic, assign) MyAdvertiseType type;

@end
