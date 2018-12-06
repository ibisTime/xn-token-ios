//
//  MineHeaderView.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/9.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MineHeaderView.h"
@interface MineHeaderView()

//背景


@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        [self initSubvies];
    }
    return self;
}

#pragma mark - Init
- (void)initSubvies {
    
    self.backgroundColor = kBackgroundColor;
    
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 188 + kStatusBarHeight)];
    bgIV.image = kImage(@"起始业背景");
    bgIV.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:bgIV];

    self.bgIV = bgIV;
    
//    UILabel *titleLab  = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:18.0];
//    [self.bgIV addSubview:titleLab];
//    titleLab.text = [LangSwitcher switchLang:@"我的" key:nil];
//    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.bgIV.mas_centerX);
//        make.top.equalTo(self.bgIV.mas_top).offset(kStatusBarHeight+9);
//    }];
    
//    UIView *titleView = [[UIView alloc] init];
//    titleView.backgroundColor = kWhiteColor;
//    titleView.layer.cornerRadius = 4.0;
//    titleView.clipsToBounds = YES;
//    [self addSubview:titleView];
//    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@15);
//        make.top.equalTo(self.mas_top).offset(kStatusBarHeight+44);
//        make.right.equalTo(@-15);
//        make.height.equalTo(@(kHeight(140)));
//    }];
//    CGFloat imgWidth = 66;

    self.photoBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.photoBtn setBackgroundImage:kImage(@"头像") forState:UIControlStateNormal];
    [self.photoBtn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.photoBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 40, 44 + kStatusBarHeight - 20, 80, 80);
    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    kViewBorderRadius(self.photoBtn, 40, 3, kWhiteColor);
    [self addSubview:self.photoBtn];
    
    
//    UIImageView *image = [[UIImageView alloc] init];
//    image.contentMode = UIViewContentModeScaleToFill;
//    image.image = kImage(@"1");
//    [self addSubview:image];
//    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.equalTo(@(imgWidth));
//        make.height.equalTo(@64);
//
//        make.left.equalTo(@(20));
//        make.top.equalTo(@(27));
//
//    }];
    
//    [image mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.equalTo(self.photoBtn.mas_centerX);
//        make.height.equalTo(@17);
//        make.width.equalTo(@20);
//
//        make.bottom.equalTo(self.photoBtn.mas_top).offset(-2);
//
//    }];
    
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:30.0];
    self.nameLbl.userInteractionEnabled = YES;
    self.nameLbl.frame = CGRectMake(0, self.photoBtn.yy + 15, SCREEN_WIDTH, 22);
    self.nameLbl.textAlignment = NSTextAlignmentCenter;
    self.nameLbl.font = HGboldfont(22);
    [self addSubview:self.nameLbl];
//    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(titleView.mas_top).offset(25);
//        make.left.equalTo(self.photoBtn.mas_right).offset(20);
//
//    }];
//    UIImageView *phone = [[UIImageView alloc] init];
//    phone.image = kImage(@"手机");
//    self.phone = phone;
//    [titleView addSubview:phone];
//    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLbl.mas_left);
//        make.top.equalTo(@(75));
//        make.width.equalTo(@10);
//        make.height.equalTo(@14);
//
//    }];
    //手机号
    self.mobileLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:14.0];
    self.mobileLbl.frame = CGRectMake(0, self.nameLbl.yy + 8, SCREEN_WIDTH, 14);
    self.mobileLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.mobileLbl];
    
    
    _realnameBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"身份认证未完成" key:nil] titleColor:kWhiteColor backgroundColor:kClearColor titleFont:10];
    
    
    
    _realnameBtn.frame = CGRectMake(15, self.mobileLbl.yy + 7.5, SCREEN_WIDTH - 30, 10);
    _realnameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    if ([TLUser isBlankString:[TLUser user].realName] == YES) {
        [_realnameBtn setTitle:[LangSwitcher switchLang:@"身份认证未完成" key:nil] forState:(UIControlStateNormal)];
        [_realnameBtn SG_imagePositionStyle:(SGImagePositionStyleDefault) spacing:3.5 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(@"提示1") forState:(UIControlStateNormal)];
        }];
    }else
    {
        [_realnameBtn setTitle:[LangSwitcher switchLang:@"身份认证已完成" key:nil] forState:(UIControlStateNormal)];
        [_realnameBtn SG_imagePositionStyle:(SGImagePositionStyleDefault) spacing:3.5 imagePositionBlock:^(UIButton *button) {
            [button setImage:kImage(@"已完成") forState:(UIControlStateNormal)];
        }];
        
    }
    
    
    
    [self addSubview:_realnameBtn];
    
//    [self.mobileLbl sizeToFit];
    


//    UIButton *integralBtn = [UIButton buttonWithTitle:@"" titleColor:kHexColor(@"#666666") backgroundColor:kClearColor titleFont:14];
//    integralBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [titleView addSubview:integralBtn];
//    self.integralBtn = integralBtn;
    

//    NSString *JF = [LangSwitcher switchLang:@"信用积分" key:nil];
//    NSString *str = [NSString stringWithFormat:@"%@ 0",[LangSwitcher switchLang:@"信用积分" key:nil]];
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
//    [attrStr addAttribute:NSForegroundColorAttributeName
//                    value:kHexColor(@"#666666")
//                    range:NSMakeRange(0, JF.length)];
//    [attrStr addAttribute:NSForegroundColorAttributeName
//                    value:RGB(0, 126, 246)
//                    range:NSMakeRange(JF.length, str.length - JF.length)];
//    [integralBtn setAttributedTitle:attrStr forState:(UIControlStateNormal)];


}


#pragma mark - Events
- (void)clickButton:(UIButton *)sender {
    
    NSInteger index = sender.tag - 1100;
    
    MineHeaderSeletedType type = index == 0 ? MineHeaderSeletedTypeBuy: MineHeaderSeletedTypeSell;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:)]) {
        
        [self.delegate didSelectedWithType:type];
        
    }
    
}

- (void)selectPhoto:(UITapGestureRecognizer *)tapGR {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypePhoto];
    }
    
}

@end

