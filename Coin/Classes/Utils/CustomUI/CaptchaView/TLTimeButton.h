//
//  TLTimeButton.h
//  实验22
//
//  Created by 田磊 on 16/3/17.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import <UIKit/UIKit.h>

//倒计时按钮封装
@interface TLTimeButton : UIButton

- (void)begin;

- (instancetype)initWithFrame:(CGRect)frame totalTime:(NSInteger)total;
- (void)forbid;
- (void)available;

@end
