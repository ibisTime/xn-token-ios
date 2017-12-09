//
//  TLAlipayManager.m
//  ZHCustomer
//
//  Created by  蔡卓越 on 2017/2/12.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLAlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation TLAlipayManager

+ (instancetype)manager {
    
    static TLAlipayManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[TLAlipayManager alloc] init];
    });
    
    return manager;
}

+ (void)payWithOrderStr:(NSString *)orderStr {

    
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"jiuzhoubao" callback:^(NSDictionary *resultDic) {
        NSLog(@"支付宝回调--%@",resultDic);

        [[TLAlipayManager manager] handleResult:resultDic];
        
    }];

}

+ (void)hadleCallBackWithUrl:(NSURL *)url {

    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        [[TLAlipayManager manager] handleResult:resultDic];

    }];

}

- (void)handleResult:(NSDictionary *)resultDic {

    
    BOOL isSuccess = NO;
    if( [resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        //支付宝支付成功
        isSuccess = YES;
        
    } else {
        
        NSLog(@"支付失败");
        
    }
    
    if ([TLAlipayManager manager].payCallBack) {
        
        [TLAlipayManager manager].payCallBack(isSuccess, resultDic);
        
    }


}
- (void)pay {
    
//  服务端把  orderString传给客户端


}

@end
