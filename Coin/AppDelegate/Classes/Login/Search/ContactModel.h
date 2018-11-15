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

@property (nonatomic,strong) NSString *interSimpleCode;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
