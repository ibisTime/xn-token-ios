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

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation CoinChangeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:[UIFont systemFontOfSize:20]
                                   textColor:[UIColor textColor]];
        [self addSubview:self.titleLbl];
        
        //
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"交易_下拉"]];
        [self addSubview:self.arrowImageView];
        
        //
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_right).offset(5);
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right);
        }];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLbl.text = title;
}

@end
