//
//  BannerModel.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BannerModel.h"
//Category
#import "NSString+Extension.h"

@implementation BannerModel

- (NSString *)pic {
    
    return [_pic convertImageUrl];
}

@end
