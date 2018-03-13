//
//  HourPickerView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectBlock)(NSInteger firstIndex, NSInteger secondIndex);

@interface HourPickerView : UIView

//数据
@property (nonatomic,copy) NSArray *firstTagNames;
//
@property (nonatomic,copy) NSArray *secondTagNames;

@property (nonatomic,copy) DidSelectBlock selectBlock;
//title
@property (nonatomic, strong) NSString *title;

- (void)show;

- (void)hide;

@end
