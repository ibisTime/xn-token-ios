//
//  TopBottomView.m
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TopBottomView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@implementation TopBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.topLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:[UIFont systemFontOfSize:17]
                                    textColor:kTextColor];
        [self addSubview:self.topLbl];
        
        //
        self.bottomLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentCenter
                              backgroundColor:[UIColor whiteColor]
                                         font:[UIFont systemFontOfSize:12]
                                    textColor:kTextColor2];
        [self addSubview:self.bottomLbl];
        
        //
        [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.equalTo(self);
            
        }];
        
        [self.bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.topLbl.mas_bottom).offset(3);
            make.left.right.equalTo(self);

        }];
        
    }
    return self;
}

@end
