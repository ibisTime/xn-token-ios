//
//  IMAUserShowAble.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol IMAUserShowAble <IMAShowAble>

@end


@protocol IMAGroupShowAble <IMAShowAble>

// 群id
- (NSString *)groupId;

// 群人数
- (NSInteger)memberCount;

@end

