//
//  TLUserLoginVC.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLAccountBaseVC.h"

@interface TLUserLoginVC : TLAccountBaseVC


@property (nonatomic,copy) void(^loginSuccess)();

@property (nonatomic,copy) void(^loginFailed)();

@property (nonatomic,strong) UIBarButtonItem *backItem;
@property (nonatomic , assign) BOOL  NeedLogin;

@property (nonatomic , assign) BOOL  IsAPPJoin;

@end
