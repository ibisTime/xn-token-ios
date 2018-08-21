//
//  TLAlipayManager.h
//  ZHCustomer
//
//  Created by  蔡卓越 on 2017/2/12.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLAlipayManager : NSObject

+ (void)payWithOrderStr:(NSString *)orderStr;

+ (instancetype)manager;

//回调的callback
@property (nonatomic, copy) void(^payCallBack)(BOOL isSuccess, NSDictionary *resultDict);

+ (void)hadleCallBackWithUrl:(NSURL *)url;

@end
