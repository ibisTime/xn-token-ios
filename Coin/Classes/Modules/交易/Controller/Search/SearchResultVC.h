//
//  SearchResultVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, SearchType) {
    
    SearchTypeAdvertise,    //搜广告
    SearchTypeUser,         //搜用户
    
};

@interface SearchResultVC : TLBaseVC

//搜索类型
@property (nonatomic, assign) SearchType searchType;
//搜广告
//最低价
@property (nonatomic, copy) NSString *minPrice;
//最高价
@property (nonatomic, copy) NSString *maxPrice;
//支付方式
@property (nonatomic, copy) NSString *payType;
//广告类型
@property (nonatomic, copy) NSString *advertiseType;
//搜用户
@property (nonatomic, copy) NSString *nickName;

@end
