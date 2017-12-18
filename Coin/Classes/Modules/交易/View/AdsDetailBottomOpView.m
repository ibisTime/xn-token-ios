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

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;


@end

@implementation AdsDetailBottomOpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.leftView = [[UIView alloc] init];
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self);
            make.width.equalTo(self.mas_width).dividedBy(2);
        }];
        
        //
        self.rightView = [[UIView alloc] init];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.equalTo(self.mas_width).dividedBy(2);
        }];
        
    }
    return self;
}

@end
