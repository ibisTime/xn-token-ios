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
    }
    if ([LangSwitcher currentLangType] == LangTypeSimple || [LangSwitcher currentLangType] == LangTypeTraditional) {
        
            _pinyin=_chineseName.pinyin;
        
//        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ (+%@)",[_searchResultArr[indexPath.row] valueForKey:@"chineseName"],[[_searchResultArr[indexPath.row] valueForKey:@"interCode"] substringFromIndex:2]]];
    }
    
//        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ (+%@)",[_searchResultArr[indexPath.row] valueForKey:@"interName"],[[_searchResultArr[indexPath.row] valueForKey:@"interCode"] substringFromIndex:2]]];
        
    
    
}

-(void)setInterName:(NSString<Optional> *)interName
{
    if (interName) {
        _interName = interName;
        
    }
    
    if ([LangSwitcher currentLangType] == LangTypeSimple || [LangSwitcher currentLangType] == LangTypeTraditional) {
        
    }else
    {
        _pinyin=_interName.pinyin;
    }
}



- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}

@end
