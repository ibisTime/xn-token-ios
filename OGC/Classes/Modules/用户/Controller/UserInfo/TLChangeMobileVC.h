//
//  ZHChangeMobileVC.h
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLAccountSetBaseVC.h"

@interface TLChangeMobileVC : TLAccountSetBaseVC


@property (nonatomic,copy) void(^changeMobileSuccess)(NSString *mobile);

@end
