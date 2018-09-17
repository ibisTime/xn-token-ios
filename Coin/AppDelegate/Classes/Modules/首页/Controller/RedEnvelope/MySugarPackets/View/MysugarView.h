//
//  MysugarView.h
//  Coin
//
//  Created by shaojianfei on 2018/9/13.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MysugarView : UIView
@property (nonatomic ,strong) UILabel *count;
@property (nonatomic ,strong) UIButton *tameBtn;
@property (nonatomic ,strong) UILabel *total;
@property (nonatomic ,strong)  UIButton *eyesBtn;
@property (nonatomic ,strong) UIImageView *icon;
@property (nonatomic ,copy) void (^clickBlock) ();
@property (nonatomic ,copy) void (^closeBlock) (BOOL isClose);

@end
