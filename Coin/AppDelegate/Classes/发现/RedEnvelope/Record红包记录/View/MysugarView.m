//
//  MysugarView.m
//  Coin
//
//  Created by shaojianfei on 2018/9/13.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MysugarView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "TLUser.h"
#import "UIImageView+WebCache.h"
#import "NSString+Check.h"
#import "NSString+Extension.h"
@implementation MysugarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kHexColor(@"#F5F5F8");
        [self initUi];
    }
    return self;
}

- (void)initUi
{
  
    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleToFill;
//     icon sd_S
    self.icon = icon;
    NSURL *u =[NSURL URLWithString:[[TLUser user].photo convertImageUrl]];
    [icon sd_setImageWithURL:u placeholderImage: kImage(@"头像")];
//    icon.image = kImage(@"头像");

    [self addSubview:icon];
    
    UILabel *nike =[UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    nike.text = [TLUser user].nickname;
    [self addSubview:nike];
    UIButton *tameBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"2018%@",[LangSwitcher switchLang:@"年" key:nil]] titleColor:kTextColor backgroundColor:kWhiteColor titleFont:14];
    [tameBtn setImage:kImage(@"下拉") forState:UIControlStateNormal];
    tameBtn.layer.borderColor = kLineColor.CGColor;
    tameBtn.layer.borderWidth = 1;
    self.tameBtn = tameBtn;
    [self addSubview:tameBtn];
    [tameBtn addTarget:self action:@selector(yearChoose) forControlEvents:UIControlEventTouchUpInside];
    [tameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kWidth(20))];
    [tameBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kWidth(60), 0, 0)];
    UILabel *total =[UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    total.text = [LangSwitcher switchLang:@"共收到红包" key:nil];
    [self addSubview:total];
    self.total = total;
    
    UILabel *count =[UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:14];
    [self addSubview:count];
    self.count = count;
    icon.layer.cornerRadius = 29;
    icon.clipsToBounds = YES;
    UILabel *ge =[UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    [self addSubview:ge];
    ge.text = [LangSwitcher switchLang:@"个" key:nil];

  
    UIButton *eyesButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [eyesButton setImage:[UIImage imageNamed:@"眼睛"] forState:(UIControlStateNormal)];
    [eyesButton setImage:[UIImage imageNamed:@"闭眼"] forState:(UIControlStateSelected)];
    self.eyesBtn = eyesButton;

    [self addSubview:eyesButton];
    [eyesButton addTarget:self action:@selector(eyesClick:) forControlEvents:UIControlEventTouchUpInside];

    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(30);
        make.width.height.equalTo(@58);
    }];
    
    [nike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(icon.mas_bottom).offset(8);
    }];
    
    [total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(-20);
        make.top.equalTo(nike.mas_bottom).offset(20);
    }];
    
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(total.mas_centerY);
        make.left.equalTo(total.mas_right).offset(3);
    }];
    [ge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(count.mas_centerY);
        make.left.equalTo(count.mas_right).offset(2);
    }];
    [tameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@(kWidth(84)));
        make.height.equalTo(@30);
    }];
    [eyesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(total.mas_centerY);
        make.left.equalTo(count.mas_right).offset(10);
        make.width.equalTo(@(kWidth(32)));
        make.height.equalTo(@16);
    }];
    
}

- (void)eyesClick: (UIButton*)btn
{
    btn.selected = !btn.selected;

    if (self.closeBlock) {
        self.closeBlock(btn.selected);
    }
//    if (btn.isSelected == YES) {
//        
//        [self.eyesBtn setImage:kImage(@"红包-隐私") forState:UIControlStateNormal];
//    }else{
//        [self.eyesBtn setImage:kImage(@"红包-隐私2") forState:UIControlStateNormal];
//
//        
//    }
    
}

- (void)yearChoose
{
    if (self.clickBlock) {
        self.clickBlock();
    }
    
    NSLog(@"click");
}
@end
