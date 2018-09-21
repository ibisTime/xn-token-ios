//
//  RedEnvelopeShoreVC.h
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "RedEnvelopeShoreView.h"
#import "ZJAnimationPopView.h"
@interface RedEnvelopeShoreVC : TLBaseVC

@property (nonatomic , copy)NSString *code;
@property (nonatomic , copy)NSString *content;
@property (nonatomic , strong) RedEnvelopeShoreView *shoreVie;
@property (nonatomic , strong) ZJAnimationPopView *popView;
@property (nonatomic , strong) UILabel *introduce;
@property (nonatomic , strong) UILabel *introduce2;

@end
