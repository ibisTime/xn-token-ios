//
//  WebVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface WebVC : TLBaseVC

@property (nonatomic,copy) NSString *url;


/**
 default is no
 */
@property (nonatomic, assign) BOOL canSendWX;

@end
