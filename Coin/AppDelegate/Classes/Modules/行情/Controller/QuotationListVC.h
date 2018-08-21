//
//  QuotationListVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, QuotationListType) {
    
    QuotationListTypeETH = 0,   //以太坊
    QuotationListTypeBTC,       //比特币
};

@interface QuotationListVC : TLBaseVC

@property (nonatomic, assign) QuotationListType quototationType;

@end
