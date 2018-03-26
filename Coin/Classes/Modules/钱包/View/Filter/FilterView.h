//
//  FilterView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectBlock)(NSInteger index);
typedef void(^DidSelectBlock2)(NSInteger index,NSString *tagName);

@interface FilterView : UIView


// default is NO
@property (nonatomic, assign) BOOL autoSelectOne;

//数据
@property (nonatomic,copy) NSArray *tagNames;

//以下2个不要同时实现，y应为都会调用
@property (nonatomic,copy) DidSelectBlock selectBlock;
@property (nonatomic, copy) DidSelectBlock2 selectBlock2;

@property (nonatomic, assign) NSInteger selectIndex;

//title
@property (nonatomic, strong) NSString *title;

- (void)show;

- (void)hide;

@end
