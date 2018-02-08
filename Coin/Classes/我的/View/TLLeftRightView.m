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
        leftLbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:leftLbl];
        self.leftLbl = leftLbl;
        self.leftLbl.text = @"--";
        [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.width.mas_greaterThanOrEqualTo(200);
        }];
        
        //
        self.rightLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:[UIColor textColor]
                                                  font:13.0];
        self.rightLbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.rightLbl];
        self.rightLbl.text = @"--";
        [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.left.equalTo(self.leftLbl.mas_right).offset(20);
            
        }];
        
    }
    return self;
}

@end
