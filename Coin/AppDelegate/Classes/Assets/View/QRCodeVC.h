//
//  QRCodeVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface QRCodeVC : TLBaseVC

@property (nonatomic,copy)  void(^scanSuccess)(NSString *result);

@end
