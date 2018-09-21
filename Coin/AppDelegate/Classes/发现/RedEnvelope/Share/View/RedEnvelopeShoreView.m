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

-(UIImageView *)headImage
{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kHeight(70)/2, kHeight(116), kHeight(27), kHeight(27))];
        _headImage.image = kImage(@"红包-关闭");
    }
    return _headImage;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       

        UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(20), kHeight(116-30), kWidth(335), kHeight(434))];
        backImg.image = kImage(@"红 包");
        self.backImg = backImg;
        [self addSubview:backImg];
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(backImg.xx-50, kHeight(136-30), kHeight(17), kHeight(17))];
        headImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(diss)];
        [headImage addGestureRecognizer:ta];
        
        headImage.image = kImage(@"红包-关闭");
        [self addSubview:headImage];
        
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.frame];
        backImage.image = kImage(@"logo 白");
        
        [backImg addSubview:backImage];
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(backImg.mas_top).offset(20);
        }];
        
        UILabel *share = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
        
        [self addSubview:share];
        share.text = [NSString stringWithFormat:@"-  %@  -",[LangSwitcher switchLang:@"分享到" key:nil]];
        [share mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@(backImg.yy +10));
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
            make.top.equalTo(self.sharewweibo.mas_bottom).offset(14);
            make.right.equalTo(self.mas_right).offset(kWidth(-30));
            make.width.height.equalTo(@30);
        }];
//        UIImageView *Image = [[UIImageView alloc]init];
//        [Image sd_setImageWithURL: [NSURL URLWithString: [[TLUser user].photo convertImageUrl]] placeholderImage:kImage(@"头像")];
//        Image.layer.cornerRadius = 30;
//        Image.clipsToBounds = YES;
//        [_headImage addSubview:Image];
//        [Image mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.equalTo(@5);
//            make.bottom.right.equalTo(@-5);
//        }];
//        UILabel *nameLabel;
//        if (kDevice_Is_iPhoneX) {
//             nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(260), kWidth(kScreenWidth - 70), kHeight(20))];
//        }else{
//            
//            nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(260), kWidth(kScreenWidth - 70-20), kHeight(20))];
//        }
//        nameLabel = [UILabel new];
//        self.nameLabel = nameLabel;
//        nameLabel.text = [TLUser user].nickname;
//        nameLabel.textAlignment = NSTextAlignmentCenter;
//        nameLabel.font = Font(14);
//        nameLabel.textColor = kTextColor5;
//        [self addSubview:nameLabel];
//        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).offset(250);
//            make.centerX.equalTo(self.mas_centerX);
//        }];
        UILabel *stateLabel;
//        if (kDevice_Is_iPhoneX) {
//            stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(284), kWidth(kScreenWidth - 70), kHeight(22))];
//        }else{
//            stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(284), kWidth(kScreenWidth - 70-20), kHeight(22))];
//
//        }
//
        stateLabel = [UILabel new];
        [self.backImg addSubview:stateLabel];

        [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(kHeight(150)));
            make.centerX.equalTo(self.mas_centerX);
        }];
        self.stateLabel = stateLabel;
        stateLabel.text = [LangSwitcher switchLang:@"扫码领红包" key:nil];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.font = Font(24);
        stateLabel.textColor = [UIColor whiteColor];

//        UILabel *detailedLabel;
//        detailedLabel = [UILabel new];
//        [self addSubview:detailedLabel];
//
//        [detailedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(stateLabel.mas_bottom).offset(20);
//            make.centerX.equalTo(self.mas_centerX);
//        }];
//        if (kDevice_Is_iPhoneX) {
//            detailedLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(336), kWidth(kScreenWidth - 70), kHeight(33))];
//        }else{
//
//            detailedLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(336), kWidth(kScreenWidth - 70-70), kHeight(33))];
//        }
//        detailedLabel.text = self.content;
//        self.detailedLabel = detailedLabel;
//        detailedLabel.textAlignment = NSTextAlignmentCenter;
//        detailedLabel.font = boldFont(20);
//        detailedLabel.textColor = kTextColor7;


//        _shoreButton  = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"分享" key:nil] titleColor:kTextColor6 backgroundColor:kClearColor titleFont:0];
////        _shoreButton.frame = CGRectMake(kScreenWidth/2 - kHeight(45), kHeight(400), kHeight(90), kHeight(90));
//        _shoreButton.titleLabel.font = boldFont(20);
//        [_shoreButton setBackgroundImage:kImage(@"圆 按钮") forState:(UIControlStateNormal)];
//        [self addSubview:_shoreButton];
//        
//        [_shoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(stateLabel.mas_bottom).offset(50);
//            make.centerX.equalTo(self.mas_centerX);
//            make.width.height.equalTo(@(kHeight(90)));
//        }];

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
