//
//  TLSwitchView.h
//  Coin
//
//  Created by  tianlei on 2018/2/05.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TLSwitchViewDelegate<NSObject>

- (UIView *)currentIndex:(NSInteger)index alreadyAdd:(BOOL)already;

@end

@interface TLSwitchView : UIView

//只负责添加controller的view
//controller之间的关系自己处理
@property (nonatomic, strong) NSMutableArray <UIViewController *> *vcs;

@property (nonatomic, weak) id<TLSwitchViewDelegate> delegate;

@property (nonatomic, assign) NSInteger count;


/**
 滚动到第几页
 @param idx 页数, 0 开始
 */
- (void)scrollToIndex:(NSInteger)idx;

@end
