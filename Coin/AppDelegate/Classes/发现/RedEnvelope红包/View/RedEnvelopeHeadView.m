//
//  RedEnvelopeHeadView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "RedEnvelopeHeadView.h"
#import "LangSwitcher.h"
#import "AppColorMacro.h"
@implementation RedEnvelopeHeadView

//-(UILabel *)nameLabel
//{
//    if (!_nameLabel) {
//        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 0, kScreenWidth - 108, 44)];
//        _nameLabel.text = [LangSwitcher switchLang:@"发红包" key:nil];
//        _nameLabel.textAlignment = NSTextAlignmentCenter;
//        _nameLabel.font = Font(18);
//        _nameLabel.textColor = [UIColor whiteColor];
//    }
//    return _nameLabel;
//}

-(UIButton *)recordButton
{
    if (!_recordButton) {
        
        _recordButton.tag = 101;
    }
    return _recordButton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.backButton];

        [self addSubview:self.nameLabel];
        [self addSubview:self.recordButton];
    }
    return self;
}

-(void)buttonClick:(UIButton *)sender
{
    [_delegate RedEnvelopeHeadButton:sender.tag - 100];
}



@end
