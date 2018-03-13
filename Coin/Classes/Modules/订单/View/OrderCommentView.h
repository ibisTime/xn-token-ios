//
//  OrderCommentView.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OrderCommentBlock)(NSString *result);

@interface OrderCommentView : UIView

@property (nonatomic, copy) OrderCommentBlock commentBlock;

//显示
- (void)show;

//隐藏
- (void)hide;

@end
