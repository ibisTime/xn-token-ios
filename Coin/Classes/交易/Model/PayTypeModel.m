//
//  PayTypeModel.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PayTypeModel.h"

#import "UIColor+Extension.h"

@implementation PayTypeModel

- (void)setPayType:(NSString *)payType {
    
    _payType = payType;
    
    NSInteger index = [payType integerValue];
    
    switch (index) {
        case 0:
        {
            self.text = @"支付宝";
            
            self.color = [UIColor colorWithHexString:@"#48b0fb"];
            
        }break;
         
        case 1:
        {
            self.text = @"微信";

            self.color = [UIColor colorWithHexString:@"#2ac64c"];

        }break;
            
        case 2:
        {
            self.text = @"银行转账";

            self.color = [UIColor colorWithHexString:@"#f15353"];

        }break;
            
        default:
            break;
    }
}
@end
