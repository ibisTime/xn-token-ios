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
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        _informationLabel.attributedText = [self ReturnsTheDistanceBetween:@"【Theia是全球首款跨链生态钱包，同时支持BTC、ETH、USDT等多币数字货币储存。注册即送10积分，千万BTC/ETH/WAN矿山，等您来挖】千万BTC/ETH/WAN矿山，等您来挖】千万BTC/ETH/WAN矿山，等您来挖】千万BTC/ETH/WAN矿山，等您来挖】"];
//        _informationLabel.numberOfLines = 0;
//        [_informationLabel sizeToFit];
//        NSString *lang;
//        LangType type = [LangSwitcher currentLangType];
//        if (type == LangTypeSimple || type == LangTypeTraditional) {
//            lang = @"ZH_CN";
//        }else if (type == LangTypeKorean)
//        {
//            lang = @"KO";
//        }else{
//            lang = @"EN";
//
//        }
//        TLNetworking *http = [TLNetworking new];
//        http.showView = self;
//        http.code = @"660917";
//        http.parameters[@"ckey"] = @"redPacketShareUrl";
//        [http postWithSuccess:^(id responseObject) {
//            NSString *str = [NSString stringWithFormat:@"%@/user/register.html?inviteCode=%@&lang=%@",responseObject[@"data"][@"cvalue"],[TLUser user].secretUserId,lang];
//
//
//            [self setNeedsDisplay];
//        } failure:^(NSError *error) {
//
//        }];
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
