//
//  TLAdpaterView.m
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLAdpaterView.h"
#import "TLUIHeader.h"

@implementation TLAdpaterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentLbl = [TLBaseLabel labelWithFrame:CGRectZero
                                         textAligment:NSTextAlignmentLeft
                                      backgroundColor:[UIColor whiteColor]
                                                 font:[UIFont systemFontOfSize:12]
                                            textColor:[UIColor themeColor]];
        [self addSubview:self.contentLbl];
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right);
            
        }];
        
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(0.7);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
    }
    return self;
}

@end
