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

-(UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _backButton.frame = CGRectMake(0, 0, 40, 40);
        [_backButton setImage:kImage(@"cancel") forState:(UIControlStateNormal)];
        [_backButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];

        _backButton.tag = 100;
    }
    return _backButton;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 0, kScreenWidth - 108, 44)];
        _nameLabel.text = [LangSwitcher switchLang:@"发红包" key:nil];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = Font(18);
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

-(UIButton *)recordButton
{
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _recordButton.frame = CGRectMake(kScreenWidth - 140, 10, 130, 44);
        [_recordButton setTitle:[LangSwitcher switchLang:@"我的红包" key:nil] forState:(UIControlStateNormal)];
        _recordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _recordButton.titleLabel.font = Font(14);
        [_recordButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_recordButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
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
