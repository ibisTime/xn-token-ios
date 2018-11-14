//
//  CountryModel.h
//  Coin
//
//  Created by shaojianfei on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryModel : NSObject
//国际编码
@property (nonatomic , copy) NSString *interCode;
//国际名称
@property (nonatomic , copy) NSString *interName;
//中文名称
@property (nonatomic , copy) NSString *chineseName;
//国际简码
@property (nonatomic , copy) NSString *interSimpleCode;
//所属洲际
@property (nonatomic , copy) NSString *continent;
//顺序
@property (nonatomic , copy) NSString *orderNo;
//状态 0=未上架 1=已上架
@property (nonatomic , copy) NSString *status;

@property (nonatomic , copy) NSString *pic;

@property (nonatomic , copy) NSString *code;

//@property (nonatomic,strong) NSString <Ignore>*pinyin;

@end
