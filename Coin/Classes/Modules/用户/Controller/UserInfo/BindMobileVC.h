//
//  BindMobileVC.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/24.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLBaseVC.h"
//#import "WXApi.h"

typedef void(^BindMobileBlock)(NSString *mobile, NSString *verifyCode);

@interface BindMobileVC : TLBaseVC

@property (nonatomic,copy) BindMobileBlock bindMobileBlock;

//@property (nonatomic, strong) SendAuthResp *resp;

@end
