//
//  FilterView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectBlock)(NSInteger index);

@interface FilterView : UIView

//数据
@property (nonatomic,copy) NSArray *tagNames;

@property (nonatomic,copy) DidSelectBlock selectBlock;

- (void)show;

@end
