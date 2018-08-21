//
//  TLDatePickerView.h
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/20.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLDatePicker : NSObject

@property (nonatomic,strong) UIDatePicker *datePicker;
- (void)show;

@property (nonatomic,copy)  void(^confirmAction)(NSDate *date);

@end
