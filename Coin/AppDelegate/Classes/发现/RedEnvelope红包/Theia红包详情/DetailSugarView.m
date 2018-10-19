//
//  DetailSugarView.m
//  Coin
//
//  Created by shaojianfei on 2018/9/14.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "DetailSugarView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "TLUser.h"
@implementation DetailSugarView
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
    UIImageView *back = [[UIImageView alloc] init];
    back.userInteractionEnabled = YES;
    
    back.contentMode = UIViewContentModeScaleToFill;
    back.image = kImage(@"Rectangle 2");
    [self addSubview:back];
    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleToFill;
    //     icon sd_S
//    icon.image = kImage(@"头像");
    self.back = icon;
    [self addSubview:icon];
    
    UILabel *nike =[UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    nike.text = [TLUser user].nickname;
    [self addSubview:nike];
    UIButton *tameBtn = [UIButton buttonWithImageName:@"返回 白色" selectedImageName:@"返回 白色"];
   
    self.tameBtn = tameBtn;
    [self addSubview:tameBtn];
    [tameBtn addTarget:self action:@selector(yearChoose) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithImageName:@"分享" selectedImageName:@"分享"];
    self.shareBtn = shareBtn;
    shareBtn.hidden = YES;
    [self addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareChoose) forControlEvents:UIControlEventTouchUpInside];
//    [tameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [tameBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kWidth(50))];
    UILabel *total =[UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    total.text = [LangSwitcher switchLang:@"" key:nil];
    self.total = total;
    total.textAlignment = NSTextAlignmentCenter;
    [self addSubview:total];
    
    UILabel *alltotalnum =[UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    alltotalnum.text = [LangSwitcher switchLang:@"总额" key:nil];
    alltotalnum.textAlignment = NSTextAlignmentCenter;
    [self addSubview:alltotalnum];
    
    UILabel *totalnum =[UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    totalnum.text = [LangSwitcher switchLang:@"数量" key:nil];
    totalnum.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalnum];


    UILabel *alltotal =[UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
    alltotal.text = [LangSwitcher switchLang:@"" key:nil];
    alltotal.textAlignment = NSTextAlignmentCenter;
    [self addSubview:alltotal];
    self.alltotal = alltotal;


    UILabel *titleLab =[UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:18];
    titleLab.text = [LangSwitcher switchLang:@"红包详情" key:nil];
    [self addSubview:titleLab];
    UILabel *count =[UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:14];
    [self addSubview:count];
    self.count = count;
    icon.layer.cornerRadius = 29;
    icon.clipsToBounds = YES;
    UILabel *listLab =[UILabel labelWithBackgroundColor:kHexColor(@"#F7F7F7") textColor:kTextBlack font:16];
    listLab.text = [LangSwitcher switchLang:@"领取列表" key:nil];
    [self addSubview:listLab];
    
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@130);
    }];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(back.mas_bottom).offset(-28);
        make.width.height.equalTo(@58);
    }];
    
    [nike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(icon.mas_bottom).offset(8);
    }];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight+20);
    }];

    [total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(nike.mas_bottom).offset(20);
        make.width.equalTo(@(SCREEN_WIDTH/2 - 30));;
    }];

    [alltotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(total.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH/2 - 30));;
    }];
    
    [totalnum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kWidth(15));
        make.top.equalTo(total.mas_bottom).offset(5);
        make.width.equalTo(@(SCREEN_WIDTH/2 - 30));;
    }];

    [alltotalnum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alltotal.mas_centerX);
        make.centerY.equalTo(totalnum.mas_centerY);
    }];
  
    
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(total.mas_centerY);
        make.left.equalTo(total.mas_right).offset(3);
    }];
    [tameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight+20);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(@12);
        make.height.equalTo(@21);
    }];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight+20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [listLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@40);

    }];

    
}
- (void)shareChoose
{
    if (self.shareBlock) {
        self.shareBlock();
    }
    
}
- (void)yearChoose
{
    if (self.clickBlock) {
        self.clickBlock();
    }
    
    NSLog(@"click");
}

@end
