//
//  RedEnvelopeShoreView.h
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedEnvelopeShoreView : UIView

@property (nonatomic , strong)UIImageView *headImage;
@property (nonatomic , strong)UIButton *shoreButton;
@property (nonatomic , copy)NSString *content;
@property (nonatomic , strong) UILabel *detailedLabel;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *stateLabel;
@property (nonatomic , copy)void (^redPackBlock)();
@property (nonatomic , copy)void (^shareBlock)(NSInteger inter);
@property (nonatomic , strong) UIImageView *backImg;
@end
