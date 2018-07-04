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
@implementation RedEnvelopeShoreView

-(UIImageView *)headImage
{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kHeight(70)/2, kHeight(170), kHeight(70), kHeight(70))];
        _headImage.image = kImage(@"圆 按钮");
    }
    return _headImage;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.frame];
        backImage.image = kImage(@"红包底部背景");
        [self addSubview:backImage];


        UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(20), kHeight(116), kWidth(335), kHeight(434))];
        backImg.image = kImage(@"红包 短");
        [self addSubview:backImg];

        [self addSubview:self.headImage];
        
        UIImageView *Image = [[UIImageView alloc]init];
        [Image sd_setImageWithURL: [NSURL URLWithString: [[TLUser user].photo convertImageUrl]] placeholderImage:kImage(@"头像")];        
        Image.layer.cornerRadius = 30;
        Image.clipsToBounds = YES;
        [self addSubview:Image];
        [Image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@5);
            make.bottom.right.equalTo(@-5);
        }];

        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(260), kWidth(kScreenWidth - 70), kHeight(20))];
        nameLabel.text = [TLUser user].nickname;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = Font(14);
        nameLabel.textColor = kTextColor5;
        [self addSubview:nameLabel];

        UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(284), kWidth(kScreenWidth - 70), kHeight(22))];
        stateLabel.text = [LangSwitcher switchLang:@"给您发了一个红包" key:nil];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.font = Font(16);
        stateLabel.textColor = [UIColor whiteColor];
        [self addSubview:stateLabel];


        UILabel *detailedLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(35), kHeight(336), kWidth(kScreenWidth - 70), kHeight(33))];
        detailedLabel.text = @"糖包一响,黄金万两";
        detailedLabel.textAlignment = NSTextAlignmentCenter;
        detailedLabel.font = boldFont(24);
        detailedLabel.textColor = kTextColor7;
        [self addSubview:detailedLabel];


        _shoreButton  = [UIButton buttonWithTitle:@"分享" titleColor:kTextColor6 backgroundColor:kClearColor titleFont:0];
        _shoreButton.frame = CGRectMake(kScreenWidth/2 - kHeight(45), kHeight(400), kHeight(90), kHeight(90));
        _shoreButton.titleLabel.font = boldFont(20);
        [_shoreButton setBackgroundImage:kImage(@"圆 按钮") forState:(UIControlStateNormal)];
        [self addSubview:_shoreButton];
        

    }
    return self;
}


@end
