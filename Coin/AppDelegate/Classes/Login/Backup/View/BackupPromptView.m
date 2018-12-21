//
//  BackupPromptView.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/19.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "BackupPromptView.h"

@implementation BackupPromptView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *nameLabel = [UILabel labelWithFrame:CGRectMake(10, 55, SCREEN_WIDTH - 120, 18) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(14) textColor:kHexColor(@"#000000")];
        
        NSString *attStr = [LangSwitcher switchLang:@"请按顺序 " key:nil];
        NSString *str =[LangSwitcher switchLang:@"请按顺序 抄写下方四个助记词" key:nil];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        [AttributedStr addAttribute:NSFontAttributeName value:HGboldfont(18) range:NSMakeRange(0, attStr.length + 1)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#0064ff") range:NSMakeRange(0, attStr.length + 1)];
        nameLabel.attributedText = AttributedStr;
        [self addSubview:nameLabel];
        
        
        UILabel *totalLabel = [UILabel labelWithFrame:CGRectMake(0, nameLabel.yy + 11, SCREEN_WIDTH - 100, 14) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#000000")];
        totalLabel.text = [LangSwitcher switchLang:@"共三页" key:nil];
        [self addSubview:totalLabel];
        
        UIButton *IKonwBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"我知道了" key:nil] titleColor:kWhiteColor backgroundColor:kHexColor(@"#0064ff") titleFont:16];
        self.IKonwBtn = IKonwBtn;
        IKonwBtn.frame = CGRectMake(75, totalLabel.yy + 20, SCREEN_WIDTH - 250, 40);
        kViewRadius(IKonwBtn, 10);
        [self addSubview:IKonwBtn];
        
        
        UIButton *promptBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"请勿截图保存助记词" key:nil] titleColor:kHexColor(@"#0064ff") backgroundColor:kClearColor titleFont:14];
        promptBtn.frame = CGRectMake(10, IKonwBtn.yy + 60, SCREEN_WIDTH - 120, 14);
        
        [promptBtn SG_imagePositionStyle:(SGImagePositionStyleDefault) spacing:2.5 imagePositionBlock:^(UIButton *button) {
            [promptBtn setImage:kImage(@"提示") forState:(UIControlStateNormal)];
        }];
        [self addSubview:promptBtn];
        
        
        UILabel *ownershipLbl = [UILabel labelWithFrame:CGRectMake(50, promptBtn.yy + 7.5, SCREEN_WIDTH - 200, 0) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:FONT(12) textColor:kHexColor(@"#acacac")];
        self.ownershipLbl = ownershipLbl;
        ownershipLbl.text = [LangSwitcher switchLang:@"获得助记词等于掌控资产所有权" key:nil];
        ownershipLbl.numberOfLines = 0;
        [ownershipLbl sizeToFit];
        [self addSubview:ownershipLbl];
        
    }
    return self;
}

@end
