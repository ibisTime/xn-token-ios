//
//  EditEmailVC.h
//  Coin
//
//  Created by  tianlei on 2017/12/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface EditEmailVC : TLBaseVC

@property (nonatomic, copy) void(^done)(NSString *content) ;

@end
