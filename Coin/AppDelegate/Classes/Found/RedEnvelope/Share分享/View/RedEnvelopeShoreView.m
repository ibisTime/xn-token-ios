//
//  RedEnvelopeShoreView.m
//  Coin
//
//  Created by QinBao Zheng on 2018/7/2.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "RedEnvelopeShoreView.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"
#import "TLUser.h"
#import "UIImageView+WebCache.h"
#import "TLUser.h"
#import "NSString+Extension.h"

@interface RedEnvelopeShoreView()

@property (nonatomic ,strong) UIButton *shareWeichat;

@property (nonatomic ,strong) UIButton *shareWcFriend;

@property (nonatomic ,strong) UIButton *sharewweibo;

@property (nonatomic ,strong) UIButton *downBtn;

@end
@implementation RedEnvelopeShoreView

//-(UIImageView *)headImage
//{
//    if (!_headImage) {
//        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kHeight(70)/2, kHeight(116), kHeight(27), kHeight(27))];
//        _headImage.image = kImage(@"红包-关闭");
//    }
//    return _headImage;
//}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       

        UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40)/520*760)];
        backImg.image = kImage(@"红包背景1");
        self.backImg = backImg;
        [self addSubview:backImg];
        
        UILabel *stateLabel = [UILabel labelWithFrame:CGRectMake(0, 60, SCREEN_WIDTH - 40, 16) textAligment:(NSTextAlignmentCenter) backgroundColor:kClearColor font:HGboldfont(16) textColor:kHexColor(@"#f8aa73")];
        [self.backImg addSubview:stateLabel];
        self.stateLabel = stateLabel;
        stateLabel.text = [LangSwitcher switchLang:@"扫码领红包" key:nil];

        
//        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(backImg.xx-50, kHeight(42), kHeight(17), kHeight(17))];
//        headImage.userInteractionEnabled = YES;
//        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(diss)];
//        [headImage addGestureRecognizer:ta];
//
//        headImage.image = kImage(@"红包-关闭");
//        [self addSubview:headImage];
        
//        UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.frame];
//        backImage.image = kImage(@"logo 白");
//
//        [backImg addSubview:backImage];
//        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.mas_centerX);
//            make.top.equalTo(backImg.mas_top).offset(20);
//        }];
        
        UILabel *share = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
        
        [self addSubview:share];
        share.text = [NSString stringWithFormat:@"-  %@  -",[LangSwitcher switchLang:@"分享到" key:nil]];
        [share mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@(backImg.yy + 10));
        }];
        self.shareWeichat = [UIButton buttonWithImageName:@"微信" selectedImageName:@"微信 亮色"];
        [self.shareWeichat setBackgroundColor:kHexColor(@"#F5F5F5") forState:UIControlStateNormal];
        self.shareWeichat.tag = 10000;
        [self addSubview:self.shareWeichat];
        [self.shareWeichat addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.shareWeichat.layer.cornerRadius = 24;
        self.shareWeichat.clipsToBounds = YES;
        [self.shareWeichat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(backImg.yy +40));
            make.left.equalTo(@45);
            make.width.height.equalTo(@48);
        }];
        
        UILabel *wei = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:13];
        wei.text = [LangSwitcher switchLang:@"微信" key:nil];
        [self addSubview:wei];
        
        [wei mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shareWeichat.mas_bottom).offset(5);
            make.centerX.equalTo(self.shareWeichat.mas_centerX);
        }];
        self.shareWcFriend = [UIButton buttonWithImageName:@"朋友圈" selectedImageName:@"朋友圈 亮色"];
        [self.shareWcFriend setBackgroundColor:kHexColor(@"#F5F5F5") forState:UIControlStateNormal];
        [self addSubview:self.shareWcFriend];
        self.shareWcFriend.tag = 10001;

         [self.shareWcFriend addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.shareWcFriend.layer.cornerRadius = 24;
        self.shareWcFriend.clipsToBounds = YES;
        [self.shareWcFriend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(backImg.yy +40));
            make.left.equalTo(self.shareWeichat.mas_right).offset(kWidth(70));
            make.width.height.equalTo(@48);
        }];
        UILabel *weiF = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:13];
        weiF.text = [LangSwitcher switchLang:@"朋友圈" key:nil];
        [self addSubview:weiF];
        
        [weiF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shareWcFriend.mas_bottom).offset(5);
            make.centerX.equalTo(self.shareWcFriend.mas_centerX);
        }];
        self.sharewweibo = [UIButton buttonWithImageName:@"微博" selectedImageName:@"微博 亮色"];
        [self.sharewweibo setBackgroundColor:kHexColor(@"#F5F5F5") forState:UIControlStateNormal];
        [self addSubview:self.sharewweibo];
        self.sharewweibo.tag = 10002;

          [self.sharewweibo addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.sharewweibo.layer.cornerRadius = 24;
        self.sharewweibo.clipsToBounds = YES;
        [self.sharewweibo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(backImg.yy +40));
            make.left.equalTo(self.shareWcFriend.mas_right).offset(kWidth(70));
            make.width.height.equalTo(@48);
        }];
        UILabel *weiwb = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:13];
        weiwb.text = [LangSwitcher switchLang:@"微博" key:nil];
        [self addSubview:weiwb];
        
        [weiwb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sharewweibo.mas_bottom).offset(5);
            make.centerX.equalTo(self.sharewweibo.mas_centerX);
        }];
        self.downBtn = [UIButton buttonWithImageName:@"下载" selectedImageName:@"下载"];
        [self.downBtn setBackgroundColor:kClearColor forState:UIControlStateNormal];
        [self addSubview:self.downBtn];
        self.downBtn.tag = 10003;

         [self.downBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sharewweibo.mas_bottom).offset(20);
            make.right.equalTo(self.mas_right).offset(kWidth(-30));
            make.width.height.equalTo(@30);
        }];

        



    }
    return self;
}

- (void)buttonClick: (UIButton *)btn
{
    NSInteger t = btn.tag - 10000;
    if (self.shareBlock) {
        self.shareBlock(t);
    }
    
    
}


- (void)diss
{
    
    
    if (self.redPackBlock) {
        self.redPackBlock();
    }
    
}
@end
