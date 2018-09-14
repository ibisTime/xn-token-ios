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
    icon.image = kImage(@"头像");

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
    [tameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [tameBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kWidth(50))];
    UILabel *total =[UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    total.text = [LangSwitcher switchLang:@"共收到红包" key:nil];
    [self addSubview:total];
    self.total = total;
    
    UILabel *count =[UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:14];
    [self addSubview:count];
    self.count = count;
    icon.layer.cornerRadius = 29;
    icon.clipsToBounds = YES;
  
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
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(nike.mas_bottom).offset(20);
    }];
    
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(total.mas_centerY);
        make.left.equalTo(total.mas_right).offset(3);
    }];
    [tameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@(kWidth(84)));
        make.height.equalTo(@30);
    }];
    
}

- (void)yearChoose
{
    if (self.clickBlock) {
        self.clickBlock();
    }
    
    NSLog(@"click");
}
@end
