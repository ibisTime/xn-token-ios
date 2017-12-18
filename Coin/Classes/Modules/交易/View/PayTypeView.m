//
//  PayTypeView.m
//  Coin
//
//  Created by  tianlei on 2017/12/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PayTypeView.h"
#import "UILabel+Extension.h"
#import "UILable+convience.h"
#import "TLUIHeader.h"

@interface PayTypeView()

@property (nonatomic, strong) UILabel *payTypeLbl;

@end

@implementation PayTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 0.5;

        self.payTypeLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentCenter
                                  backgroundColor:[UIColor whiteColor]
                                             font:Font(11)
                                        textColor:kClearColor];
        [self addSubview:self.payTypeLbl];
        [self.payTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(3, 3, 3, 3));
            
        }];
        
        
    }
    return self;
}

- (void)setPayType:(PayTypeModel *)payType {
    
    _payType = payType;
    
    self.payTypeLbl.text = _payType.text;
    self.payTypeLbl.textColor = _payType.color;
    self.layer.borderColor = _payType.color.CGColor;
    
}



@end
