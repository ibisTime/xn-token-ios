//
//  CoinChangeView.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CoinChangeView.h"
#import "UILable+convience.h"
#import "UIColor+theme.h"
#import "TLUIHeader.h"

@interface CoinChangeView()

@property (nonatomic, strong) UIView *adapterView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation CoinChangeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI {
    
    //
    //背景
    self.adapterView = [[UIView alloc] init];
    [self addSubview:self.adapterView];
    self.adapterView.userInteractionEnabled = NO;
    
    
    //
    self.titleLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:[UIFont systemFontOfSize:16]
                                  textColor:[UIColor textColor]];
    [self.adapterView addSubview:self.titleLbl];
    
    [self.adapterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);

    }];
    
    //
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"交易_下拉"]];
    [self.adapterView addSubview:self.arrowImageView];
    
    //
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(self.adapterView);
        make.centerY.equalTo(self.adapterView);

    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_right).offset(5);
        make.centerY.equalTo(self.adapterView);
        make.right.equalTo(self.adapterView.mas_right);
        make.width.mas_equalTo(15);

    }];
    
    
    
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLbl.text = title;
}

@end
