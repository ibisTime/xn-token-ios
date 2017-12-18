//
//  AdsDetailBottomOpView.m
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AdsDetailBottomOpView.h"

#import "TLUIHeader.h"

@interface AdsDetailBottomOpView()



@end

@implementation AdsDetailBottomOpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //左
        self.chatBtn = [[UIButton alloc] init];
        [self addSubview:self.chatBtn];
        [self.chatBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        [self.chatBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.chatBtn setTitle:[LangSwitcher switchLang:@"联系对方" key:nil]
                      forState:UIControlStateNormal];
        [self.chatBtn setImage:[UIImage imageNamed:@"聊天"] forState:UIControlStateNormal];
        [self.chatBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //右
        self.opBtn = [[UIButton alloc] init];
        [self.opBtn setBackgroundColor:[UIColor themeColor] forState:UIControlStateNormal];
        [self addSubview:self.opBtn];

        //
        //
        [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self);
            make.width.equalTo(self.mas_width).dividedBy(2);
        }];
        
        [self.opBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.equalTo(self.mas_width).dividedBy(2);
        }];
        
    }
    return self;
}


- (void)setOpType:(AdsDetailBottomOpType)opType {
    
    _opType = opType;
    
    NSString *rightOpKey = nil;
    switch (_opType) {
            
        case AdsDetailBottomOpTypeSell: {
            
            rightOpKey = [LangSwitcher switchLang:@"出售" key:nil];
            
        }  break;
            
        case AdsDetailBottomOpTypeBuy: {
            
            rightOpKey= [LangSwitcher switchLang:@"购买" key:nil];  

        }  break;
            
    }
    
    //
    [self.opBtn setTitle:rightOpKey
                   forState:UIControlStateNormal];

    
}

- (void)test {
    
    NSArray *views = [[NSArray alloc] init];
    [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                       withFixedSpacing:10
                            leadSpacing:10
                            tailSpacing:10];
    //
    [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                    withFixedItemLength:10
                            leadSpacing:0
                            tailSpacing:0];
    
}

/**
 *  多个控件固定间隔的等间隔排列，变化的是控件的长度或者宽度值
 *
 *  @param axisType        轴线方向
 *  @param fixedSpacing    间隔大小
 *  @param leadSpacing     头部间隔
 *  @param tailSpacing     尾部间隔
 */
//- (void)mas_distributeViewsAlongAxis:(MASAxisType)axisType
//                    withFixedSpacing:(CGFloat)fixedSpacing l
//eadSpacing:(CGFloat)leadSpacing
//tailSpacing:(CGFloat)tailSpacing;

/**
 *  多个固定大小的控件的等间隔排列,变化的是间隔的空隙
 *
 *  @param axisType        轴线方向
 *  @param fixedItemLength 每个控件的固定长度或者宽度值
 *  @param leadSpacing     头部间隔
 *  @param tailSpacing     尾部间隔
 */
//- (void)mas_distributeViewsAlongAxis:(MASAxisType)axisType
//                 withFixedItemLength:(CGFloat)fixedItemLength
//                         leadSpacing:(CGFloat)leadSpacing
//                         tailSpacing:(CGFloat)tailSpacing;



@end
