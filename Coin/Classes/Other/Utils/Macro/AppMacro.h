//
//  AppMacro.h
//  LetWeCode
//
//  Created by 蔡卓越 on 15/10/28.
//  Copyright © 2015年 蔡卓越. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
#pragma mark - ToolsMacros

// 如果数据为NULL，设为nil
#define PASS_NULL_TO_NIL(instance) (([instance isKindOfClass:[NSNull class]]) ? nil : instance)

// 处理nil，为空字符串@""
#define STRING_NIL_NULL(x) if(x == nil || [x isKindOfClass:[NSNull class]]){x = @"";}

//
#define ARRAY_NIL_NULL(x) \
if(x == nil || [x isKindOfClass:[NSNull class] ]) \
{x = @[];}

// 统一处理打印日志
#ifdef DEBUG
#define NSLog(...) printf("%s\n\n", [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

#define ArtDEPRECATED(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#pragma mark - HttpMacros


#endif /* AppMacro_h */
