//
//  ContactModel.h
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "JSONModel.h"

@interface ContactModel : JSONModel

@property (nonatomic,strong) NSString <Optional>*chineseName;
@property (nonatomic,strong) NSString <Optional>*interCode;
@property (nonatomic,strong) NSString <Ignore>*pinyin;//拼音



//国际编码
//@property (nonatomic , copy) NSString *interCode;
//国际名称
@property (nonatomic , copy) NSString *interName;
//中文名称
//@property (nonatomic , copy) NSString *chineseName;
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


//@property (nonatomic,strong) NSString *interSimpleCode;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
