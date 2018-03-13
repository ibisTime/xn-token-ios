//
//  CustomElemCmd.h
//  TIMChat
//
//  Created by wilderliao on 16/6/22.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomElemCmd : NSObject

@property (nonatomic, assign) NSInteger userAction;             // 对应CustomElemCmd命令字，必须字段
@property (nonatomic, strong) NSString *actionParam;            // 自定义参数字段，可为空，为空不传
@property (nonatomic, strong) NSMutableDictionary *customInfo;

- (NSInteger)msgType;

- (instancetype)initWith:(NSInteger)command;
- (instancetype)initWith:(NSInteger)command param:(NSString *)param;

+ (instancetype)parseCustom:(TIMCustomElem *)elem;

// 将消息封装成Json，然后下发
- (NSData *)packToSendData;


@end
