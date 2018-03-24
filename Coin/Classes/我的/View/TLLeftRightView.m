//
//  TLLeftRightView.m
//  Coin
//
//  Created by  tianlei on 2018/2/08.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLLeftRightView.h"
#import "UILabel+Extension.h"
#import "UILabel+InitMethod.h"
#import "UILable+convience.h"
#import "UIColor+theme.h"
#import "TLUIHeader.h"

@interface TLLeftRightView()



@end

@implementation TLLeftRightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *leftLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:[UIColor themeColor]
                                                        font:12.0];
        leftLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:leftLbl];
        self.leftLbl = leftLbl;
        self.leftLbl.text = @"--";
        [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.width.equalTo(self);
        }];
        
        //
        self.rightLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:[UIColor textColor]
                                                  font:16.0];
        self.rightLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.rightLbl];
        self.rightLbl.text = @"--";
        [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.leftLbl.mas_bottom).offset(22);
            make.centerX.equalTo(self.leftLbl.mas_centerX);
            make.width.equalTo(self);
            
        }];
        
    }
    return self;
}

@end
