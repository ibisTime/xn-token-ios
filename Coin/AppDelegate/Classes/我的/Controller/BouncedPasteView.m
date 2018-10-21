//
//  BouncedPasteView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/9/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "BouncedPasteView.h"
#import "UILable+convience.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"
#import "TLUser.h"
#import "TLNetworking.h"
@implementation BouncedPasteView

-(UILabel *)informationLabel
{

    if (!_informationLabel) {
        _informationLabel = [UILabel labelWithFrame:CGRectMake(kWidth(6), kHeight(10), SCREEN_WIDTH - kWidth(112), 200) textAligment:(NSTextAlignmentLeft) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#2A2A2A")];
        _informationLabel.numberOfLines = 0;

    }
    return _informationLabel;
}

-(UIButton *)pasteButton
{
    if (!_pasteButton) {
        _pasteButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"复制" key:nil] titleColor:kHexColor(@"#333333") backgroundColor:kClearColor titleFont:16];
        _pasteButton.frame = CGRectMake(kWidth(20), _informationLabel.frame.size.height + kHeight(70), SCREEN_WIDTH - kWidth(90), kHeight(48));
        kViewBorderRadius(_pasteButton, 4, 1, kHexColor(@"#DEE0E5"));
    }
    return _pasteButton;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(kWidth(20), kHeight(30), SCREEN_WIDTH - kWidth(90), self.informationLabel.yy + kHeight(20))];
        backView.backgroundColor = kHexColor(@"#F8F8F8");
        [self addSubview:backView];
        kViewBorderRadius(backView, 4, 1, kHexColor(@"#DEE0E5"));

        [backView addSubview:self.informationLabel];
        [self addSubview:self.pasteButton];

    }
    return self;
}

//设置行间距
-(NSMutableAttributedString *)ReturnsTheDistanceBetween:(NSString *)str
{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:8];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:str];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return setString;
}

@end
