//
//  IMAShowAble.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

// 抽象数据显示接口
@protocol IMAShowAble <NSObject>

// 显示的标题
- (NSString *)showTitle;

// 显示图像的地址
- (NSURL *)showIconUrl;

@end
