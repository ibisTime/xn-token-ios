//
//  ContactModel.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "ContactModel.h"
#import "NSString+Utils.h"//category

@implementation ContactModel

//- (void)setName:(NSString<Optional> *)name{
//
//}

-(void)setChineseName:(NSString<Optional> *)chineseName
{
    if (chineseName) {
        _chineseName = chineseName;
        _pinyin=_chineseName.pinyin;
    }
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}

@end
