//
//  DetailSugarView.h
//  Coin
//
//  Created by shaojianfei on 2018/9/14.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSugarView : UIView
@property (nonatomic ,strong) UILabel *count;
@property (nonatomic ,strong) UIButton *tameBtn;
@property (nonatomic ,strong) UILabel *total;
@property (nonatomic ,strong) UILabel *alltotal;
@property (nonatomic ,strong) UIButton *shareBtn;
@property (nonatomic ,strong) UIImageView *back;
@property (nonatomic ,copy) void (^clickBlock) ();

@property (nonatomic ,copy) void (^shareBlock) ();

@end
